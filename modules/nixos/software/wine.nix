{ pkgs, ... }:

{
  # Wine + DXVK para rodar .exe Windows (builds Unity, etc.) no NixOS.
  # wineWowPackages.staging: suporte 32/64-bit + patches staging (melhor
  # compatibilidade que o `stable`).
  # dxvk: traduz DirectX 9/10/11 para Vulkan — necessário pra builds Unity
  # que usam D3D11 ou têm problemas com o D3D12 nativo do Wine.
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    winetricks
    dxvk
  ];
}
