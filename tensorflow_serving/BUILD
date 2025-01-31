# Description: Tensorflow Serving.

package(
    default_visibility = ["//tensorflow_serving:internal"],
)

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

# open source marker; do not remove

cc_binary(
    name = "libtensorflow_serving.so",
    deps = [
        "//tensorflow_serving/model_servers:server_lib",
    ],
    linkstatic=1,
    linkshared=1,
)

package_group(
    name = "internal",
    packages = [
        "//tensorflow_serving/...",
    ],
)

filegroup(
    name = "all_files",
    srcs = glob(
        ["**/*"],
        exclude = [
            "**/METADATA",
            "**/OWNERS",
            "g3doc/sitemap.md",
        ],
    ),
)

genrule(
    name = "install_eigen_headers",
    srcs = [
        "@eigen_archive//:eigen_header_files",
        "@org_tensorflow//third_party/eigen3:eigen_third_party_header_files",
    ],
    outs = ["include"],
    cmd = """
    mkdir $@
    for f in $(SRCS); do
      d="$${f%/*}"
      d="$${d#*external/eigen_archive/}"
      d="$${d#*external/org_tensorflow/}"

      mkdir -p "$@/$${d}"
      cp "$${f}" "$@/$${d}/"
    done
    """,
    tags = ["manual"],
)
