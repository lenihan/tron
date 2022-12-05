load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "helper",
    srcs = ["helper.cc"],
    hdrs = ["helper.hh"],
)

# The main-stat target linked with the STATIC helper library
cc_binary(
    name = "main-stat",
    srcs = ["main.cc"],
    deps = [
        ":helper",
    ],
    linkstatic=True,
)

# The main-dyn target uses the SHARED helper library
cc_binary(
    name = "main-dyn",
    srcs = ["main.cc"],
    deps = [
        ":helper",
    ],
    linkstatic=False,
)
