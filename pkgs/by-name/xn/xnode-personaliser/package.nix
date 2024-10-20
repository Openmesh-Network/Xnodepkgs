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
  rev = "8bfeeb69d3e9057130ba1ec728f7db02a741f8af";
  sha256 = "0avr8n6y39b9swr9isd6psyjhb8i5m4mxif51ygmyxfkw0cc1n54";
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
