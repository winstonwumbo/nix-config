{pkgs, ...}: {
  gtk = {
    # Not importing for now
    enable = true;
    # Flatpaks don't like the symlinks =/
    theme = {
      name = "Orchis-Compact";
      package = (pkgs.orchis-theme.override {
        tweaks = [ "solid" "primary"];
      });
    };
    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
  };
}
