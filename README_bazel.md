# Using Unity Test with Bazel

In your MODULE.bazel file:

    bazel_dep(name = "unity",    version = "2.6.1", dev_dependency=True)

In your cc_test targets:

    deps = ["@unity//lib:unity", ...]

That's all.

If you need to customize using UNITY_* macros like
UNITY_INCLUDE_DOUBLE, UNITY_INT_WIDTH, etc. then you must use a
`unity_config.h` file. So first create that file, let's say in the
`test` subdir of your project: `test/unity_config.h`. You must also
create a BUILD.bazel file in the same directory, containing:

    exports_files(["unity_config.h"])

This makes the file accessible via the Bazel Label `//test:unity_config.h`.

In the BUILD.bazel file containing your cc_test targets:

    load("@unity//src:BUILD.bzl", "unity_library")
    unity_library(
        name = "libunity",
        config = "//test:unity_config.h"
    )

`unity_library` is a macro that will generate a `cc_library` target
that builds Unity with `-DUNITY_INCLUDE_CONFIG_H` and depends on your
`unity_config.h` file.

Then in your cc_test target:

a. Depend on the lib you built wth unity_library()

    deps = [":libunity", ...]

b. Your test code must also depend on unity_config.h:

    local_defines = ["UNITY_INCLUDE_CONFIG_H", ...],

d.  Treat your `unity_config.h` as a build source file:

    srcs = ["//test:unity_config.h", ...]

c.  The compiler will search for both `unity.h` and
    `unity_config.h`; make both accessible by adding:

    copts = ["-Iexternal/{}/src".format(Label("@unity").repo_name), -Itest, ...]

You can find a demo of this technique in `examples/bazel/test/BUILD.bazel`.

