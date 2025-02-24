{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    kdePackages.kdenlive
    # jetbrains.pycharm-professional
    # jre8
    # qemu
    # quickemu
  ];
}
