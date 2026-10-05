{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  firefox-mod-blur = pkgs.stdenv.mkDerivation {
    pname = "firefox-mod-blur";
    version = "v2.14";
    src = pkgs.fetchFromGitHub {
      owner = "datguypiko";
      repo = "Firefox-Mod-Blur";
      rev = "refs/heads/master";
      sha256 = "sha256-J/SBMxDWxDC7o8P0t/3surUod52uUwy+xaD5dzZPGq0=";
    };
    installPhase = ''
      mkdir $out
      cp -r * "$out/"
    '';
  };
in
{
  
  home.username = "idk";
  home.homeDirectory = "/home/idk";
  home.stateVersion = "25.11";

  # 1. Allow Spotify (Unfree)
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  # 2. Import the Spicetify Home Manager module
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  #  Spicetify Config 
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.lucid;
    colorScheme = "dark";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
      hidePodcasts
      fullAppDisplay
    ];

    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      lyricsPlus
    ];
  };

  #  Kitty Config 
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
      window_padding_width = "27";

      background = "#282c34";
      foreground = "#979eab";
      cursor = "#cccccc";
      selection_background = "#979eab";
      selection_foreground = "#282c34";

      color0 = "#282c34";
      color1 = "#e06c75";
      color2 = "#98c379";
      color3 = "#e5c07b";
      color4 = "#61afef";
      color5 = "#be5046";
      color6 = "#56b6c2";
      color7 = "#979eab";

      color8 = "#393e48";
      color9 = "#d19a66";
      color10 = "#56b6c2";
      color11 = "#e5c07b";
      color12 = "#61afef";
      color13 = "#be5046";
      color14 = "#56b6c2";
      color15 = "#abb2bf";
    };
  };

  # Firefox Config
  programs.firefox = {
    enable = true;
    profiles.idk = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "svg.context-properties.content.enabled" = true;
      };
      userChrome = ''
        @import "${firefox-mod-blur}/userChrome.css";
        @import "${firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Bookmarks bar same color as toolbar/bookmarks_bar_same_color_as_toolbar.css";
        @import "${firefox-mod-blur}/EXTRA MODS/Search Bar Mods/Search box - No search engine buttons/no_search_engines_in_url_bar.css";
      '';
      userContent = ''
        @import "${firefox-mod-blur}/userContent.css";
      '';
    };
  };

  # Hyprland Settings
  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = "rgba(61afefee) rgba(e06c75ee) 45deg";
      "col.inactive_border" = "rgba(282c34ff)";
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 6;
        passes = 3;
        new_optimizations = true;
      };
      drop_shadow = true;
      shadow_range = 15;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };
  };

  #  VSCodium Config
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = [
        # This one definitely exists and is the most important for you
        pkgs.vscode-extensions.jnoortheen.nix-ide
      ];

      userSettings = {
        "workbench.colorTheme" = "One Dark Pro"; # We will install this manually
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "editor.fontSize" = 13;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "editor.formatOnSave" = true;
        "window.titleBarStyle" = "custom";
      };
    };
  };

  
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
    thunar-archive-plugin
    thunar-volman
  ];

  programs.home-manager.enable = true;
}
