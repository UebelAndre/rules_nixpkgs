load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")

ResolvedRustToolchainInfo = provider()
ResolvedCargoToolchainInfo = provider()

def _rust_toolchain_impl(ctx):
    rust = ctx.toolchains["@rules_rust//rust:toolchain_type"]
    return [
        ResolvedRustToolchainInfo(rust = rust),
    ]

_rust_toolchain = rule(
    _rust_toolchain_impl,
    toolchains = ["@rules_rust//rust:toolchain_type"],
)

def _cargo_toolchain_impl(ctx):
    cargo = ctx.toolchains["@rules_rust//cargo:toolchain_type"]
    return [
        ResolvedCargoToolchainInfo(cargo = cargo),
    ]

_cargo_toolchain = rule(
    _cargo_toolchain_impl,
    toolchains = ["@rules_rust//cargo:toolchain_type"],
)

def _rust_toolchain_test_impl(ctx):
    env = unittest.begin(ctx)

    rust = ctx.attr.toolchain[ResolvedRustToolchainInfo].rust
    toolchain_label = rust.rustc.owner
    asserts.true(env, toolchain_label.workspace_name.endswith("nixpkgs_config_rust"), "Rust toolchain must be provided by rules_nixpkgs_rust.")

    return unittest.end(env)

_rust_toolchain_test = unittest.make(
    _rust_toolchain_test_impl,
    attrs = {
        "toolchain": attr.label(),
    },
)

def _cargo_toolchain_test_impl(ctx):
    env = unittest.begin(ctx)

    cargo = ctx.attr.toolchain[ResolvedCargoToolchainInfo].cargo
    toolchain_label = cargo.cargo.owner
    asserts.true(env, toolchain_label.workspace_name.endswith("nixpkgs_config_rust"), "Cargo toolchain must be provided by rules_nixpkgs_rust.")

    return unittest.end(env)

_cargo_toolchain_test = unittest.make(
    _cargo_toolchain_test_impl,
    attrs = {
        "toolchain": attr.label(),
    },
)

def rust_test_suite(name):
    _rust_toolchain(name = "rust-toolchain")
    _cargo_toolchain(name = "cargo-toolchain")
    unittest.suite(
        name,
        lambda name: _rust_toolchain_test(name = name, toolchain = ":rust-toolchain"),
        lambda name: _cargo_toolchain_test(name = name, toolchain = ":cargo-toolchain"),
    )
