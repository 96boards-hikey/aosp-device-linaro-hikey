HiAI:= true

AI_SUPPORT_IPU := true
AI_SUPPORT_GPU := false

ifeq ($(TARGET_USE_HIAI), true)

PRODUCT_PACKAGES += \
	hiaiserver \
	libai_crypto \
	libai_client \
	libai_framework \
	libai_caffe \
	libai_hcs \
	libAndroidNN \
	libneuralnetworks \
	libtextclassifier_hash \
	libgnustl_shared \
	libcngen \
	libc_secshared \
	libipu_smmu \
	libipu \
	libprotobuf-cpp-full \
	libiconv \
	libfst_maker \
	libasr_engine \
	libArmnnInterface \
	vendor.huawei.hardware.ai@1.0 \
	vendor.huawei.hardware.ai@1.1 \
	android.hardware.neuralnetworks@1.0 \


config_dir := device/linaro/hikey/ai/configs
models_dir := device/linaro/hikey/ai/models
vendor_dir := $(TARGET_OUT)/system/vendor

# for AI services
PRODUCT_COPY_FILES += \
	$(config_dir)/kirin970/ai_config.xml:$(vendor_dir)/etc/hiai/default/ai_config.xml \
	$(config_dir)/kirin970/ai_framework.xml:$(vendor_dir)/etc/hiai/default/ai_framework.xml \
	$(config_dir)/kirin970/ai_computing_resource.xml:$(vendor_dir)/etc/hiai/default/ai_computing_resource.xml \
	$(config_dir)/kirin970/ai_server.properties:$(vendor_dir)/etc/hiai/default/ai_server.properties \

# for AI models
PRODUCT_COPY_FILES += \
	$(models_dir)/ImageClassification/caffe/build/IC_conv_112x112.cambricon:$(vendor_dir)/etc/models/ImageClassification/caffe/build/IC_conv_112x112.cambricon \
	$(models_dir)/ImageClassification/caffe/build/IC_conv_112x112_mean:$(vendor_dir)/etc/models/ImageClassification/caffe/build/IC_conv_112x112_mean \
	$(models_dir)/ImageClassification/caffe/build/IC_conv_112x112_synset_words.txt:$(vendor_dir)/etc/models/ImageClassification/caffe/build/IC_conv_112x112_synset_words.txt \

endif

