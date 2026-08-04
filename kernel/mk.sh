#!/bin/bash

ARCH=x86_64

kernel_clean()
{
        echo "clean linux-4.19.90 start ... ..."
        rm -rf build
        rm -rf target
        cd linux-4.19.90
        make distclean
        make clean
        cd -
        echo "clean linux-4.19.90 finished ..."
}

kernel_build()
{
        echo "make linux-4.19.90 start ... ..."
        rm -rf build
        mkdir build 
        cd linux-4.19.90
        make distclean
        make clean
        make O=../build x86_64_defconfig 
        make O=../build LOCALVERSION= -j$(nproc) 
        #make O=../build LOCALVERSION= -j2
        cd -
        echo "make linux-4.19.90 finished ..." 
}

kernel_install()
{
        echo "install linux-4.19.90 start ... ..."
        rm -rf target
        mkdir -p target/boot 
        cd linux-4.19.90
        make O=../build INSTALL_MOD_PATH=../target modules_install
        cp -arf ../build/arch/x86_64/boot/bzImage ../target/boot
        cd -
        echo "install linux-4.19.90 finished ..." 
}

main()
{
        if [ "x"$1 == "xclean" ]; then
                kernel_clean
                exit 0
        elif [ "x"$1 == "xmake" ]; then
                kernel_build
                exit 0
        elif [ "x"$1 == "xinstall" ]; then
                kernel_install
                exit 0
        else 
		"Error: (clean | make | install)"
		exit 1
	fi
}

main $@
