{ stdenv
, pkgs
, lib
, ...
} :
let

name = "xnode-personaliser";
version = "v0.0.0-0xnodepkgs0";

src = pkgs.fetchFromGitHub {
  owner = "Openmesh-Network";
  repo = name;
  rev = "a0aca399f3ca0791cbf109bd05e5a1af5bb39ab5";
  sha256 = "0a7bn703dsby4l4fprsy0a73jzf3cbi2iskrxjcj62gii92x6f8q";
};

inputs = with pkgs; [ jq curl gnugrep gzip ];

script = ( pkgs.writeScriptBin name (
    builtins.readFile "${src}/src/xnode-personaliser.sh"
    )
  ).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });

in

pkgs.symlinkJoin {
  name = name;
  version = version;

  buildInputs = [ pkgs.makeWrapper ];

  paths = [ script ]  ++ inputs;

  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Installs a simple script that takes a script from any applicable personalisation interface (kernel cmdline base64/etc) and provides a well defined runtime environment.";
    mainProgram = name;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ j-openmesh ];
  };
}
