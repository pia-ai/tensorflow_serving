#!/bin/sh

# Description:
 
# This script is merging all necessary static library for tensorflow_serving and tensorflow

# ar does not supports file name containing ++, so replace to pp and make a copy
rm -fr libtensorflow_serving.a
cat ./bazel-bin/tensorflow_serving/libtensorflow_serving.so-2.params | grep bazel  | grep -v 'src/google/protobuf' | egrep -v 'external/(snappy|protobuf|boringssl|kafka)' | grep -v "contrib/kafka" | awk 'BEGIN{print "create libtensorflow_serving.a"} /\+\+/{ new_name=$0;gsub(/\+\+/, "pp", new_name); cmd=sprintf("cp -f %s %s", $0, new_name); mkdir_cmd="mkdir -p `dirname " new_name "`";system(mkdir_cmd);close(mkdir_cmd);system(cmd); close(cmd); print "ADDMOD " new_name;next;} { print "ADDMOD " $0} END{printf("save\nend\n")}' | ar -M
