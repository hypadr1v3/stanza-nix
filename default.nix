{ stdenv, lib, makeWrapper, fetchurl, unzip }:
stdenv.mkDerivation rec {
    name = "stanza";
    version = "0.18.22";
    otherver = builtins.replaceStrings ["."] ["_"] version;
    nativeBuildInputs = [ unzip ];

    src = fetchurl {
        url = "https://github.com/StanzaOrg/lbstanza/releases/download/${version}/lstanza_${otherver}.zip";
        sha256 = "6ec3840567270de6457f0ec1de91deb214d1567a809f7779e0edce1892a7f50a";
    };
    sourceRoot = ".";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
        mkdir -p $out/bin
        cp -R stanza.proj stanza License.txt bin build compiler core docs examples include pkgs runtime 
        ln -s "$out/stanza" "$out/bin/stanza"
    '';
    preFixup = let
        libPath = lib.makeLibraryPath [
            stdenv.cc.cc.lib
        ];
    in ''
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}" $out/bin/stanza
    '';

    postInstall = ''
        stanza install -platform linux
    '';

    meta = with lib; {
        homepage = https://lbstanza.org/;
        description = "The Stanza programming language";
        license = licenses.bsd3;
        platforms = platforms.linux;
        maintainers = with maintainers; [ hypadr1v3 ];
    };
}
