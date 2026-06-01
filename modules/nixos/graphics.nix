{ config, pkgs, ... }:

let
  # FIXME: temporarily pin old mesa because latest causes "resource temporarily unavailable" when starting niri
  pkgs-mesa = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "b12141ef619e0a9c1c84dc8c684040326f27cdcc";
    sha256 = "sha256-ZSK0NL4a1BwVbbTBoSnWgbJy9HeZFXLYQizjb2DPF24=";
  }) { inherit (pkgs.stdenv.hostPlatform) system; };
in
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    package = pkgs-mesa.mesa;
    package32 = pkgs-mesa.pkgsi686Linux.mesa;

    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # create an `nvidia-offload` script
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
