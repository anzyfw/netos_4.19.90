# ========================================================
KERNEL_SRC  := linux-4.19.90
MAKE_EXTRA  := LOCALVERSION=  
BUILD_DIR   := build
TARGET_DIR  := target
ARCH        := x86_64

# 当前Makefile完整绝对路径
MK_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))

# Makefile所在目录
TOP_DIR := $(dir $(MK_FILE))

# ======== 拼接全局绝对路径（等价mk.sh ABS_XXX）=========
ABS_KERNEL_SRC := $(TOP_DIR)$(KERNEL_SRC)
ABS_BUILD_DIR  := $(TOP_DIR)$(BUILD_DIR)
ABS_TARGET_DIR := $(TOP_DIR)$(TARGET_DIR)
ABS_CONFIG     := $(TOP_DIR)config.netos

# 统一内核编译前缀命令（等价mk.sh KERNEL_MAKE）
KERNEL_MAKE := make -C $(ABS_KERNEL_SRC) O=$(ABS_BUILD_DIR) ARCH=$(ARCH)

# 0. 全套编译操作 
all:
	make clean
	make config
	make bzImage
	make modules
	make install

# 1. 彻底清理
clean:
	make -C $(ABS_KERNEL_SRC) distclean
	rm -rf $(ABS_BUILD_DIR) $(ABS_TARGET_DIR)

# 2. 只生成官方默认配置
config:
	mkdir -p $(ABS_BUILD_DIR)
	cp -a config.x86_64 $(ABS_BUILD_DIR)/.config

# 3. 只编译内核
bzImage:
	mkdir -p $(ABS_BUILD_DIR)
	#$(KERNEL_MAKE) bzImage -j$(nproc) $(MAKE_EXTRA)
	$(KERNEL_MAKE) bzImage -j 3 $(MAKE_EXTRA)

# 4. 只编译模块
modules:
	mkdir -p $(ABS_BUILD_DIR)
	#$(KERNEL_MAKE) modules -j$(nproc) $(MAKE_EXTRA)
	$(KERNEL_MAKE) modules -j 3 $(MAKE_EXTRA)

# 5.安装命令依然是 make install，安装到 target 目录
install:
	mkdir -p $(ABS_TARGET_DIR)/boot
	$(KERNEL_MAKE) INSTALL_MOD_PATH=$(ABS_TARGET_DIR) modules_install
	cp -arf $(ABS_BUILD_DIR)/arch/x86/boot/bzImage $(ABS_TARGET_DIR)/boot

.PHONY: all clean config bzImage modules install
