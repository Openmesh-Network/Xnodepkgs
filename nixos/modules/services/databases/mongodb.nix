{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mongodb;

  mongodb = cfg.package;

  mongoCnf = cfg: pkgs.writeText "mongodb.conf"
  ''
    net.bindIp: ${cfg.bind_ip}
    ${optionalString cfg.bind_ip_all "net.bindIpAll: true"}
    ${optionalString cfg.quiet "systemLog.quiet: true"}
    systemLog.destination: syslog
    storage.dbPath: ${cfg.dbpath}
    ${optionalString cfg.enableAuth "security.authorization: enabled"}
    ${optionalString (cfg.replSetName != "") "replication.replSetName: ${cfg.replSetName}"}
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.mongodb = {

      enable = mkEnableOption "the MongoDB server";

      package = mkPackageOption pkgs "mongodb" { };

      user = mkOption {
        type = types.str;
        default = "mongodb";
        description = "User account under which MongoDB runs";
      };

      bind_ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "IP to bind to";
      };

      bind_ip_all = mkOption {
        type = types.bool;
        default = true;
        description = "Allow connections from any ip.";
      };

      quiet = mkOption {
        type = types.bool;
        default = false;
        description = "quieter output";
      };

      enableAuth = mkOption {
        type = types.bool;
        default = false;
        description = "Enable client authentication. Creates a default superuser with username root!";
      };

      initialRootPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Password for the root user if auth is enabled.";
      };

      dbpath = mkOption {
        type = types.str;
        default = "/var/db/mongodb";
        description = "Location where MongoDB stores its files";
      };

      pidFile = mkOption {
        type = types.str;
        default = "/run/mongodb.pid";
        description = "Location of MongoDB pid file";
      };

      replSetName = mkOption {
        type = types.str;
        default = "";
        description = ''
          If this instance is part of a replica set, set its name here.
          Otherwise, leave empty to run as single node.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          storage.journal.enabled: false
        '';
        description = "MongoDB extra configuration in YAML format";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to open ports in the firewall for this application.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf config.services.mongodb.enable {
    assertions = [
      { assertion = !cfg.enableAuth || cfg.initialRootPassword != null;
        message = "`enableAuth` requires `initialRootPassword` to be set.";
      }
    ];

    users.users.mongodb = mkIf (cfg.user == "mongodb")
      { name = "mongodb";
        isSystemUser = true;
        group = "mongodb";
        description = "MongoDB server user";
      };
    users.groups.mongodb = mkIf (cfg.user == "mongodb") {};

    environment.systemPackages = [ mongodb ];

    systemd.services.mongodb =
      { description = "MongoDB server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${mongodb}/bin/mongod --config ${mongoCnf cfg} --fork --pidfilepath ${cfg.pidFile}";
          User = cfg.user;
          PIDFile = cfg.pidFile;
          Type = "forking";
          TimeoutStartSec=120; # initial creating of journal can take some time
          PermissionsStartOnly = true;
        };

        preStart = let
          cfg_ = cfg // { enableAuth = false; bind_ip = "127.0.0.1"; };
        in ''
          rm ${cfg.dbpath}/mongod.lock || true
          if ! test -e ${cfg.dbpath}; then
              install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
              # See postStart!
              touch ${cfg.dbpath}/.first_startup
          fi
          if ! test -e ${cfg.pidFile}; then
              install -D -o ${cfg.user} /dev/null ${cfg.pidFile}
          fi '' + lib.optionalString cfg.enableAuth ''
        '';
        postStart = ''
        '';
      };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 27017 ];
    };
  };

}
