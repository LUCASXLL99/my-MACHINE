# Ryzen 7 5700U (Zen 2 mobile) — não suporta Curve Optimizer.
# STAPM=10W, FAST=12W, SLOW=10W, TCTL=75°C
# Reaplicado após suspend/hibernate.

{ pkgs, ... }:

{
  systemd.services.ryzenadj = {
    description = "RyzenAdj power cap — Ryzen 7 5700U";
    wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" ];
    after    = [ "multi-user.target" "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type      = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "ryzenadj-apply" ''
        ${pkgs.ryzenadj}/bin/ryzenadj \
          --stapm-limit=10000 \
          --fast-limit=12000  \
          --slow-limit=10000  \
          --tctl-temp=75

        for policy in /sys/devices/system/cpu/cpufreq/policy*; do
          echo 3500000 > "$policy/scaling_max_freq" 2>/dev/null || true
        done
      '');
    };
  };
}
