load("@rules_cc//cc:defs.bzl", "cc_binary")


cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [
        "@helper_dll",
    ],
    #linkstatic=False, # uncomment to link dynamically
)


#
#cc_binary(
#    name = "main",
#    srcs = ["main.cc"],
#    deps = [
#        "@helper_dll//:helper",
#    ],
#    linkstatic=False,
#)

# This rule doesn't work as filesystem is readonly for another bazel call
#genrule(
#    name = "ensure_helper",
#    outs = ["helper_so_ok"],
#    cmd = """
#        if [[ -f $@ ]]; then rm -rf $@; fi
#        cur_dir=$$(pwd)
#        echo "=== $$cur_dir ==="
#        cd /home/spodlesnyy/repos/tron/src/hello/hello_local_repo/dll
#        #ok=$$(bazel build helper)
#        ok=true
#        echo "=== $$ok ==="
#        cd $$cur_dir
#        if [[ ok ]]; then touch $@; fi
#    """
#)

