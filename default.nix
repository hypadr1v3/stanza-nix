{ stdenv, lib, libgccjit, autoPatchelfHook, fetchzip }:

stdenv.mkDerivation rec {
    name = "stanza";
    version = "0.18.22";
    otherver = builtins.replaceStrings ["."] ["_"] version;

    src = fetchzip {
        url = "https://github.com/StanzaOrg/lbstanza/releases/download/${version}/lstanza_${otherver}.zip";
        sha256 = "sha256-LJC+GfBhiIkZyg/6c/oXKxO1YWT2Eub3fJh/8QVbamw=";
        stripRoot = false;
    };

    sourceRoot = ".";

    nativeBuildInputs = [
        autoPatchelfHook
    ];

    buildInputs = [
        libgccjit
        stdenv.cc.cc.lib
    ];

    installPhase = ''
        install -Dm755 $src/stanza $out/bin/stanza
    '';

    meta = with lib; {
        homepage = https://lbstanza.org/;
        description = "The Stanza programming language";
        license = licenses.bsd3;
        platforms = platforms.linux;
        maintainers = with maintainers; [ hypadr1v3 ];
    };
}
