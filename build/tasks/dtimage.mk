ifneq ($(filter hikey%, $(TARGET_DEVICE)),)
ifneq ($(TARGET_NO_DTIMAGE), true)

MKDTIMG := device/linaro/hikey/installer/hikey960/mkdtimg
DTB := $(PRODUCT_OUT)/hi3660-hikey960.dtb

$(PRODUCT_OUT)/dt.img: $(DTB)
	$(MKDTIMG) -c -d $(DTB) -o $@

droidcore: $(PRODUCT_OUT)/dt.img
endif
endif
