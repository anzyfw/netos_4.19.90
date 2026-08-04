# ======================== 配置项 ========================
#KERNEL_SRC  := linux-4.19.90   	# 内核源码目录
#MAKE_EXTRA  := LOCALVERSION=           # 版本末尾加号+
#CONFIG_DEF  := x86_64_defconfig        # 默认配置文件
#BUILD_DIR   := build           	# 编译输出目录
#TARGET_DIR  := target          	# 安装目录
#ARCH        := x86_64          	# x86_64位架构
# ========================================================
KERNEL_SRC  := linux-4.19.90
MAKE_EXTRA  := LOCALVERSION= 
CONFIG_DEF  := x86_64_defconfig
BUILD_DIR   := build
TARGET_DIR  := target
ARCH        := x86_64

# 内核编译通用参数
KERNEL_MAKE := make -C $(KERNEL_SRC) O=$(abspath $(BUILD_DIR)) ARCH=$(ARCH)

# 默认：编译内核
all:
	make clean
	make config
	make bzImage
	make modules
	make install

# 1. 彻底清理
clean:
	make -C $(KERNEL_SRC) distclean
	make -C $(KERNEL_SRC) clean
	rm -rf $(BUILD_DIR) $(TARGET_DIR)

# 2. 生成默认配置
config:
	mkdir -p $(BUILD_DIR)
	$(KERNEL_MAKE) x86_64_defconfig

# 3. 编译内核
bzImage:
	mkdir -p $(BUILD_DIR)
	#$(KERNEL_MAKE) bzImage -j$(nproc) $(MAKE_EXTRA)
	$(KERNEL_MAKE) bzImage -j2 $(MAKE_EXTRA)

# 4. 编译模块
modules:
	mkdir -p $(BUILD_DIR)
	#$(KERNEL_MAKE) modules -j$(nproc) $(MAKE_EXTRA)
	$(KERNEL_MAKE) modules -j2 $(MAKE_EXTRA)

# 5. 安装
install:
	mkdir -p $(TARGET_DIR)/boot
	$(KERNEL_MAKE) INSTALL_MOD_PATH=$(abspath $(TARGET_DIR)) modules_install
	cp -arf $(BUILD_DIR)/arch/x86/boot/bzImage $(TARGET_DIR)/boot


.PHONY: all clean config bzImage modules install
