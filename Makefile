# STM32l1xx Makefile
# #####################################
#
# Part of the uCtools project
# uctools.github.com
#
#######################################
# user configuration:
#######################################

# SOURCES: list of sources in the user application
SOURCES = main.c

# TARGET: name of the user application
TARGET = main

# BUILD_DIR: directory to place output files in
BUILD_DIR = build

# LD_SCRIPT: location of the linker script
LD_SCRIPT = stm32l1xx.ld

# PERIPHLIB_PATH: path to periphlib files
PERIPHLIB_PATH = /home/eric/code/stm32l1-template/STM32L1xx_StdPeriph_Lib_V1.2.0

# USER_DEFS user defined macros
USER_DEFS =
# USER_INCLUDES: user defined includes
USER_INCLUDES =
# USER_CFLAGS: user C flags (enable warnings, enable debug info) 
USER_CFLAGS = -Wall -g
# USER_LDFLAGS:  user LD flags
USER_LDFLAGS =

# PART_TYPE: the type of part being used, choose from:
# hd = high density
# md = medium density
# mdp = medium density plus
PART_TYPE = md

#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc-4.7.3
AR = ar
MKDIR = mkdir -p
#######################################

# core and CPU type for Cortex M0
# ARM core type (CORE_M0, CORE_M3)
CORE = CORE_M0
# ARM CPU type (cortex-m0, cortex-m3)
CPU = cortex-m0

# where to build the peripherial library
PERIPHLIB_BUILD_DIR = $(BUILD_DIR)/stm32-periphlib

# various paths within the STmicro library
CMSIS_PATH = $(PERIPHLIB_PATH)/Libraries/CMSIS
CMSIS_DEVICE_PATH = $(CMSIS_PATH)/Device/ST/STM32L1xx
DRIVER_PATH = $(PERIPHLIB_PATH)/Libraries/STM32L1xx_StdPeriph_Driver

# includes for gcc
INCLUDES = -I$(CMSIS_PATH)/Include
INCLUDES += -I$(CMSIS_DEVICE_PATH)/Include
INCLUDES += -I$(DRIVER_PATH)/inc
INCLUDES += -Isrc
INCLUDES += -ISTM32L1xx_StdPeriph_Lib_V1.2.0/Project/STM32L1xx_StdPeriph_Templates
INCLUDES += $(USER_INCLUDES)

# macros for gcc
DEFS = -D$(CORE) -DUSE_STDPERIPH_DRIVER $(USER_DEFS)

# compile gcc flags
CFLAGS = $(DEFS) $(INCLUDES)
CFLAGS += -mcpu=$(CPU) -mthumb
CFLAGS += $(USER_CFLAGS)

# default action: build the user application
all: $(BUILD_DIR)/$(TARGET).elf

#######################################
# build the st micro peripherial library
# (drivers and CMSIS)
#######################################

PERIPHLIB = $(PERIPHLIB_BUILD_DIR)/libstperiphlib.a

# List of stm32 driver objects
PERIPHLIB_DRIVER_OBJS = $(addprefix $(PERIPHLIB_BUILD_DIR)/, $(patsubst %.c, %.o, $(notdir $(wildcard $(DRIVER_PATH)/src/*.c))))

# shortcut for building core library (make periphlib)
periphlib: $(PERIPHLIB)

$(PERIPHLIB): $(PERIPHLIB_DRIVER_OBJS)
	$(AR) rv $@ $(PERIPHLIB_DRIVER_OBJS)

$(PERIPHLIB_BUILD_DIR)/%.o: $(DRIVER_PATH)/src/%.c | $(PERIPHLIB_BUILD_DIR)
	$(CC) -c $(CFLAGS) -o $@ $^

$(PERIPHLIB_BUILD_DIR):
	$(MKDIR) $@

#######################################
# build the user application
#######################################

# add cmsis system code source
SOURCES += system_stm32l1xx.c

# list of user program objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(SOURCES:.c=.o)))
# add an object for the startup code
OBJECTS += $(BUILD_DIR)/startup_stm32l1xx_$(PART_TYPE).o

# use the periphlib core library, plus generic ones (libc, libm, libnosys)
LIBS = -lstperiphlib -lc -lm -lnosys
LDFLAGS = -T $(LD_SCRIPT) -L $(PERIPHLIB_BUILD_DIR) $(LIBS) $(USER_LDFLAGS)

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) $(PERIPHLIB)
	$(CC) -o $@ $(CFLAGS) $(OBJECTS) \
		-L$(PERIPHLIB_BUILD_DIR) -static $(LIBS) -Xlinker \
		-Map=$(BUILD_DIR)/$(TARGET).map \
		-T $(LD_SCRIPT)
	size $@

$(BUILD_DIR)/%.o: src/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $^

$(BUILD_DIR)/%.o: src/%.s | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $^

$(BUILD_DIR):
	$(MKDIR) $@

# delete all user application files, keep the libraries
clean:
		-rm $(BUILD_DIR)/*.o
		-rm $(BUILD_DIR)/*.elf
		-rm $(BUILD_DIR)/*.map

.PHONY: clean all periphlib
