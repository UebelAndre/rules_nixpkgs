{ ... }:
let
  nixpkgs = import <nixpkgs> {};
  openssl-static = nixpkgs.openssl.override {
    static = true;
  };
in
  nixpkgs.symlinkJoin {
    name = "openssl-static.bzl";
    paths = [
        openssl-static.dev
        openssl-static.out
    ];
    # Tell the build script of the `openssl-sys` crate where to find OpenSSL.
    # Using the absolute Nix store path keeps the generated crate targets
    # independent of the layout of the Bazel execution root.
    postBuild = ''
      echo "OPENSSL_DIR=$out" > $out/openssl.env
    '';
  }
