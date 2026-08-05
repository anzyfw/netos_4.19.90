#!/bin/bash
set -e

# ====================== 可配置区 ======================
KERNEL_SRC="linux-4.19.90"
MAKE_EXTRA="LOCALVERSION="
BUILD_DIR="build"
TARGET_DIR="target"
CONFIG_DIR="config"
ARCH="x86_64"
CONFIG="config.x86_64"
# ======================================================


# 获取当前脚本所在绝对目录
CUR_DIR=$(cd "$(dirname "$0")" && pwd)
# 拼接绝对路径
ABS_KERNEL_SRC="${CUR_DIR}/${KERNEL_SRC}"
ABS_BUILD_DIR="${CUR_DIR}/${BUILD_DIR}"
ABS_TARGET_DIR="${CUR_DIR}/${TARGET_DIR}"
ABS_CONFIG_DIR="${CUR_DIR}/${CONFIG_DIR}"

# 内核统一编译前缀命令
KERNEL_MAKE="make -C ${ABS_KERNEL_SRC} O=${ABS_BUILD_DIR} ARCH=${ARCH}"


# 1. 清理：删除产物 + 内核distclean深度清理
make_clean()
{
    echo "===== 开始清理 ====="
    #rm -rf "${ABS_BUILD_DIR}" "${ABS_TARGET_DIR}"
    # O=构建要求输出目录必须存在，重建空目录再执行distclean
    mkdir -p "${ABS_BUILD_DIR}"
    ${KERNEL_MAKE} distclean
    rm -rf "${ABS_BUILD_DIR}" "${ABS_TARGET_DIR}"
    echo "===== 清理完成 ====="
}

# 2. 导入内核配置到build目录（外部编译要求.config在O目录）
make_config()
{
    echo "===== 生成build配置 ====="
    mkdir -p "${ABS_BUILD_DIR}"
    if [ ! -f "${ABS_CONFIG_DIR}/${CONFIG}" ]; then
        echo "错误：当前目录缺少config.xyz配置文件！"
        exit 1
    fi
    cp -a "${ABS_CONFIG_DIR}/${CONFIG}" "${ABS_BUILD_DIR}/.config"
    echo "===== 配置导入完成 ====="
}

# 3. 编译bzImage内核镜像
make_bzImage()
{
    echo "===== 编译内核bzImage ====="
    #${KERNEL_MAKE} bzImage -j$(nproc) ${MAKE_EXTRA}
    ${KERNEL_MAKE} bzImage -j 3 ${MAKE_EXTRA}
    echo "===== bzImage编译完成 ====="
}

# 4. 编译内核模块
make_modules()
{
    echo "===== 编译内核modules ====="
    #${KERNEL_MAKE} modules -j$(nproc) ${MAKE_EXTRA}
    ${KERNEL_MAKE} modules -j 3 ${MAKE_EXTRA}
    echo "===== modules编译完成 ====="
}

# 5. 安装模块到target，并拷贝bzImage到target/boot
make_install()
{
    echo "===== 安装内核模块至target ====="
    rm -rf "${ABS_TARGET_DIR}"
    mkdir -p "${ABS_TARGET_DIR}/boot"

    # 模块安装使用绝对路径
    ${KERNEL_MAKE} INSTALL_MOD_PATH="${ABS_TARGET_DIR}" modules_install ${MAKE_EXTRA}

    # 拷贝内核镜像
    cp -a "${ABS_BUILD_DIR}/arch/x86/boot/bzImage" "${ABS_TARGET_DIR}/boot/"
    echo "===== 模块与bzImage导出完成 ====="
}

# 主逻辑入口
main()
{
    case "$1" in
        clean)
            make_clean
            ;;
        config)
            make_config
            ;;
        bzImage)
            make_config
            make_bzImage
            ;;
        modules)
            make_config
            make_bzImage
            make_modules
            ;;
        install)
            make_config
            make_bzImage
            make_modules
            make_install
            ;;
        "")
            # 无参数：完整编译流水线
            echo ">>> 无参数，执行完整编译流程 <<<"
            make_clean
            make_config
            make_bzImage
            make_modules
            make_install
            ;;
        *)
            echo "使用方式："
            echo "  ./compile.sh clean      仅清理编译产物"
            echo "  ./compile.sh config     仅导入.config配置"
            echo "  ./compile.sh bzImage    仅编译内核镜像"
            echo "  ./compile.sh modules    仅编译驱动模块"
            echo "  ./compile.sh install    仅安装模块+拷贝bzImage"
            echo "  ./compile.sh            一键完整构建：clean -> config -> bzImage -> modules -> install"
	    ;;
    esac
}

# 执行入口
main "$@"
