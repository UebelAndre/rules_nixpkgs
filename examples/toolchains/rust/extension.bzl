"""Module extensions providing the Nix based C and Rust toolchains of this example."""

load("@rules_nixpkgs_cc//:cc.bzl", "nixpkgs_cc_configure")
load("@rules_nixpkgs_rust//:rust.bzl", "nixpkgs_rust_configure")

def _cc_configure_impl(_module_ctx):
    nixpkgs_cc_configure(
        name = "nixpkgs_config_cc",
        repository = "@nixpkgs",
        register = False,
    )

cc_configure = module_extension(
    implementation = _cc_configure_impl,
)

def _rust_configure_impl(_module_ctx):
    nixpkgs_rust_configure(
        name = "nixpkgs_rust",
        default_edition = "2021",
        repository = "@nixpkgs",
        register = False,
    )

rust_configure = module_extension(
    implementation = _rust_configure_impl,
)
