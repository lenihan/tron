load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [
        "@helper_dll//:helper",
    ],
    linkstatic=False,
)
