# ===================== 配置项 =====================
#KERNEL_SRC  := linux-4.19.90   # 内核源码目录
#BUILD_DIR   := build           # 编译输出目录
#TARGET_DIR  := target          # 安装目录
#ARCH        := x86_64          # x86_64位架构
# ==================================================
KERNEL_SRC  := linux-4.19.90
BUILD_DIR   := build
TARGET_DIR  := target
ARCH        := x86_64

# 内核编译通用参数
KERNEL_MAKE := make -C $(KERNEL_SRC) O=$(abspath $(BUILD_DIR)) ARCH=$(ARCH)

# 默认：编译内核
all: kernel

# 配置 + 编译内核
kernel:
	mkdir -p $(BUILD_DIR)
	$(KERNEL_MAKE) x86_64_defconfig
	#$(KERNEL_MAKE) -j$(nproc)
	$(KERNEL_MAKE) -j2

# 安装命令依然是 make install，安装到 target 目录
install:
	mkdir -p $(TARGET_DIR)/boot
	$(KERNEL_MAKE) INSTALL_MOD_PATH=$(abspath $(TARGET_DIR)) modules_install
	cp -arf $(BUILD_DIR)/arch/x86/boot/bzImage $(TARGET_DIR)/boot

# 清理输出文件
clean:
	rm -rf $(BUILD_DIR)

# 彻底清理：源码distclean + 外部文件全清
distclean:
	make -C $(KERNEL_SRC) distclean
	make -C $(KERNEL_SRC) clean
	rm -rf $(BUILD_DIR) $(TARGET_DIR)

.PHONY: all kernel install clean distclean
