BAZEL_OPT_CPU ?= -c opt
BAZEL_OPT_GPU ?= -c opt --config=cuda
PREFIX ?= $(CURDIR)/tf_serving_package

cpu:
	mkdir -p ${PREFIX}
	bazel build ${BAZEL_OPT} //tensorflow_serving:libtensorflow_serving.so \
	&& mkdir -p ${PREFIX}/include ${PREFIX}/lib && \
	sh merge2lib.sh && cp libtensorflow_serving.a ${PREFIX}/lib
	cd ${PREFIX} && rm -rf include && mkdir -p include/tensorflow include/tensorflow_serving && \
	cd $(CURDIR)/bazel-genfiles/tensorflow_serving && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow_serving \;
	cd $(CURDIR)/bazel-genfiles/external/org_tensorflow/tensorflow && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow \;
	cd $(CURDIR)/bazel-serving/external/org_tensorflow/tensorflow && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow \;
	cd $(CURDIR)/tensorflow_serving && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow_serving \;
	tar -zcf tf_serving_package_cpu.tar.gz ${PREFIX}

gpu:
	mkdir -p ${PREFIX}
	bazel build ${BAZEL_OPT_GPU} //tensorflow_serving:libtensorflow_serving.so \
	&& mkdir -p ${PREFIX}/include ${PREFIX}/lib && \
	sh merge2lib.sh && cp libtensorflow_serving.a ${PREFIX}/lib/libtensorflow_serving_gpu.a
	cd ${PREFIX} && rm -rf include && mkdir -p include/tensorflow include/tensorflow_serving && \
	cd $(CURDIR)/bazel-genfiles/tensorflow_serving && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow_serving \;
	cd $(CURDIR)/bazel-genfiles/external/org_tensorflow/tensorflow && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow \;
	cd $(CURDIR)/bazel-serving/external/org_tensorflow/tensorflow && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow \;
	cd $(CURDIR)/tensorflow_serving && find . -name "*.h" -exec cp --parents {} ${PREFIX}/include/tensorflow_serving \;
	tar -zcf tf_serving_package_gpu.tar.gz ${PREFIX}