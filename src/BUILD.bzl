load("@rules_cc//cc:defs.bzl", "cc_library")
load("@bazel_skylib//rules:common_settings.bzl",
     "bool_flag", "string_flag")

def define_module_version():
    return ["'{}_MODULE_VERSION=\"{}\"'".format(
        native.module_name().upper(),
        native.module_version()
    )]

def _unity_macro_impl(name, config, visibility, **kwargs):
    if config:
        DEFS = ["UNITY_INCLUDE_CONFIG_H"]
        CFGFILE = [config]
        CFGPATH = ["-I" + config.package]
    else:
        DEFS = []
        CFGFILE = []
        CFGPATH = []

    cc_library(
        name  = name,
        linkstatic = True,
        srcs  = ["@unity//src:unity.c",
                 "@unity//src:unity_internals.h"
                 ] + CFGFILE,
        hdrs  = ["@unity//src:unity.h"],
        # includes = [".", "src"],
        copts = ["-x", "c", "-Isrc"] + select({
            "@platforms//os:linux": [
                "-std=gnu11",
                "-fPIC",
            ],
            "//conditions:default": ["-std=c11"],
        }) + CFGPATH,
        local_defines = DEFS,
        visibility = visibility
    )

unity_library = macro(
    implementation = _unity_macro_impl,
    attrs = {
        "config": attr.label(configurable = False)
    },
)
