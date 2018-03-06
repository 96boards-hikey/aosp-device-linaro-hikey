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
	$(models_dir)/ImageSegmentation/caffe/build/IS_conv_473x473.cambricon:$(vendor_dir)/etc/models/ImageSegmentation/caffe/build/IS_conv_473x473.cambricon \
	$(models_dir)/ImageSegmentation/caffe/build/IS_conv_473x473_mean:$(vendor_dir)/etc/models/ImageSegmentation/caffe/build/IS_conv_473x473_mean \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_506_506.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_506_506.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_666_378.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_666_378.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_666_506.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_666_506.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_666_346.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_666_346.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_586_586.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_586_586.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_778_394.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_778_394.cambricon \
	$(models_dir)/CameraDlsr/caffe/build/HWSR-s_778_586.cambricon:$(vendor_dir)/etc/models/CameraDlsr/caffe/build/HWSR-s_778_586.cambricon \
	$(models_dir)/ObjectDetection/caffe/build/od.cambricon:$(vendor_dir)/etc/models/ObjectDetection/caffe/build/od.cambricon \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_112x112.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_112x112.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_312x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_312x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_372x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_372x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_412x312.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_412x312.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_412x545.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_412x545.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_492x372.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_492x372.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_492x652.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_492x652.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_530x530.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_530x530.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_545x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_545x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x1/SR_face_x1_652x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x1_652x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_112x112.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_112x112.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_312x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_312x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_372x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_372x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_412x312.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_412x312.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_412x545.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_412x545.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_492x372.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_492x372.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_492x652.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_492x652.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_530x530.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_530x530.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_545x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_545x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_face_x3/SR_face_x3_652x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_face_x3_652x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_112x112.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_112x112.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_312x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_312x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_372x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_372x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_412x312.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_412x312.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_412x545.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_412x545.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_492x372.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_492x372.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_492x652.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_492x652.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_530x530.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_530x530.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_545x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_545x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x1/SR_x1_652x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x1_652x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_112x112.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_112x112.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_312x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_312x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_372x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_372x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_412x312.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_412x312.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_412x545.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_412x545.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_492x372.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_492x372.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_492x652.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_492x652.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_530x530.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_530x530.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_545x412.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_545x412.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_common_x3/SR_x3_652x492.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_x3_652x492.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_PD_112x112/SR_PD_112x112.cambricon:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_PD_112x112.cambricon  \
	$(models_dir)/SuperResolution/caffe/build/SR_PD_112x112/SR_PD_112x112_mean:$(vendor_dir)/etc/models/SuperResolution/caffe/build/SR_PD_112x112_mean

endif

