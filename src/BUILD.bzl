load("@rules_cc//cc:defs.bzl", "cc_library", "cc_import")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//rules:common_settings.bzl",
     "bool_flag", "string_flag")

def define_module_version():
    return ["'{}_MODULE_VERSION=\"{}\"'".format(
        native.module_name().upper(),
        native.module_version()
    )]

def unity_library(name, config, **kwargs):
    if config:
        DEFS = ["UNITY_INCLUDE_CONFIG_H"]
    else:
        DEFS = []

    native.filegroup(
        name = name + "_cfg_file",
        srcs = [config]
    )

    cc_library(
        name  = name,
        linkstatic = True,
        srcs  = ["@unity//src:unity.c",
                 "@unity//src:unity_internals.h",
                 name + "_cfg_file",
                 config
                 ],
        hdrs  = ["@unity//src:unity.h"],
        # includes = [".", "src"],
        # data  = [config],
        # deps = [":my_test_lib"],
        data  = [name + "_cfg_file"],
        copts = [
            "-x", "c", "-Isrc",
            "-I$(UNITY_CONFIG_H_DIR)",
        ] + select({
            "@platforms//os:linux": [
                "-std=gnu11",
                "-fPIC",
            ],
            "//conditions:default": ["-std=c11"],
        }),
        local_defines = DEFS,
        toolchains = [name + "_unity_config_h_tc"],
        **kwargs
    )

    _unity_config_h(
        name = name + "_unity_config_h_tc",
        cfg_file = config
    )

def _unity_config_h_impl(ctx):
    return [
        platform_common.TemplateVariableInfo({
            "UNITY_CONFIG_H_DIR": ctx.attr.cfg_file.label.package,
        }),
    ]

_unity_config_h = rule(
    implementation = _unity_config_h_impl,
    attrs = {
        "cfg_file": attr.label(
        allow_single_file = True
    )}
)
