STM32L1xx Template
==================

## Toolchain

You will need an ARM bare-metal toolchain to build code for STM32L1 targets.
You can get a toolchain from the
[gcc-arm-embedded](https://launchpad.net/gcc-arm-embedded) project that is
pre-built for your platform. Extract the package and add the `bin` folder to
your PATH.

You will also need to download and extract the STM32L1 StdPeriphLib, which can
be found
[here](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/PF257913)

## Writing and Building Firmware

1. Clone the
   [stm32l1-template](https://github.com/uctools/stm32l1-template)
   repository (or fork it and clone your own repository).

        git clone git@github.com/uctools:stm32l1-template

2. Modify the Makefile:
    * Set TARGET to the desired name of the output file (eg: TARGET = main)
    * Set SOURCES to a list of your sources (eg: SOURCES = main.c
      startup\_gcc.c)
    * Set PERIPHLIB\_PATH to the full path to where you extracted the STM32L1
      peripherial library.
    * Set PART\_TYPE to the type of your part. This can be md (medium density),
      mdp (medium density plus), or hd (high density).

3. Run `make`

4. The output files will be created in the 'build' folder

## Flashing

You can flash and using your device using stlink. More information is available 
on the [stlink project page](https://github.com/texane/stlink).

## Supported Hardware

This template has been tested on the [STM32L 
Discovery](http://www.st.com/web/en/catalog/tools/PF250990) development board.
