{ config, lib, pkgs, ... }:

let
  cfg = config.darwin.windowManager.aerospace;
  tomlFormat = pkgs.formats.toml { };
in
{
  meta.maintainers = [ lib.maintainers.t-monaghan ];

  options.darwin.windowManager.aerospace = {
    enable = lib.mkEnableOption "aerospace";

    package = lib.mkPackageOption pkgs "aerospace" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = {
        "gaps.inner" = {
          "horizontal" = 0;
          "vertical" = 0;
        };
      };
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/aerospace/aerospace.toml`.
        Documentation for configuration can be found here <https://nikitabobko.github.io/AeroSpace/guide>.
      '';
    };
  };

  config = lib.mkIf cfg.enable
    {
      home.packages = [ cfg.package ];

      xdg.configFile =
        let
          settings = {
            "aerospace/aerospace.toml" = lib.mkIf (cfg.settings != { }) {
              source = tomlFormat.generate "aerospace-config" cfg.settings;
            };
          };
        in
        settings;
    };
}
