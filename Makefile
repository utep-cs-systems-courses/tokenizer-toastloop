# Title: Makefile for C/C++/Assembly Projects
# Author: Matthew Knowlton <matt at toastloop dot com>
# Date: 2023-09-19
# License: MIT License
# Usage: make [all|clean|run|test|debug|profile|info]

# Note: This Makefile is designed to be used with the GNU Make utility and assumes you
#	    have a directory structure that follows the Pitchfork Project Structure. More 
#		information can be found at https://github.com/vector-of-bool/pitchfork/

# Project Name and Test Name
TARGET_NAME			:= tokenizer
TEST_NAME			:= tokenizer_test

# Parent Folders ./<build|data|docs|examples|external|extras|include|src|tests|tools>
ROOT_DIR			:= .
BUILD_DIR			:= build
DATA_DIR			:= data
DOCS_DIR			:= docs
EXAMPLES_DIR		:= examples
EXTERNAL_DIR		:= external
EXTRAS_DIR			:= extras
INCLUDE_DIR			:= include
SRC_DIR				:= src
TESTS_DIR			:= tests
TOOLS_DIR			:= tools

# Build Folders ./build/<target>/<bin|dep|dist|obj|lib>
BIN_DIR				:= bin
DEP_DIR				:= dep
DIST_DIR			:= dist
OBJ_DIR				:= obj
LIB_DIR				:= lib

# Data Folders ./data/<img|lang>
IMG_DIR				:= img
LANG_DIR			:= lang

# Documentation Folders ./docs/<html|pdf|tex>
HTML_DIR			:= html
PDF_DIR				:= pdf
TEX_DIR				:= tex

# Source Folders
TARGET_SRC			:= $(SRC_DIR)
TEST_SRC			:= $(TESTS_DIR)

# Build Folders
TARGET_BUILD_DIR	:= $(BUILD_DIR)/$(TARGET_NAME)
TEST_BUILD_DIR		:= $(BUILD_DIR)/$(TEST_NAME)

# Object Folders
TARGET_OBJ_DIR		:= $(TARGET_BUILD_DIR)/$(OBJ_DIR)
TEST_OBJ_DIR		:= $(TEST_BUILD_DIR)/$(OBJ_DIR)

# Dependency Folders
TARGET_DEP_DIR		:= $(TARGET_BUILD_DIR)/$(DEP_DIR)
TEST_DEP_DIR		:= $(TEST_BUILD_DIR)/$(DEP_DIR)

# Binary Folders
TARGET_BIN_DIR		:= $(TARGET_BUILD_DIR)/$(BIN_DIR)
TEST_BIN_DIR		:= $(TEST_BUILD_DIR)/$(BIN_DIR)

# Library Folders
TARGET_LIB_DIR		:= $(TARGET_BUILD_DIR)/$(LIB_DIR)
TEST_LIB_DIR		:= $(TEST_BUILD_DIR)/$(LIB_DIR)

# Build Dirs
BUILD_DIRS			:= $(BUILD_DIR) $(TARGET_BUILD_DIR) $(TEST_BUILD_DIR) $(TARGET_OBJ_DIR) $(TEST_OBJ_DIR) $(TARGET_DEP_DIR) $(TEST_DEP_DIR) $(TARGET_BIN_DIR) $(TEST_BIN_DIR) $(TARGET_LIB_DIR) $(TEST_LIB_DIR)

# Executable Files
TARGET_EXECUTABLE	:= $(TARGET_BIN_DIR)/$(TARGET_NAME)
TEST_EXECUTABLE		:= $(TEST_BIN_DIR)/$(TEST_NAME)

# Compiler and Linker
CC					:= cc
CXX					:= c++
ASM					:= nasm

# # Dependency Flags
TARGET_DEP_FLAGS	:= $@ -MMD -MP -MF $(TARGET_DEP_DIR)/$*.d
TEST_DEP_FLAGS		:= $@ -MMD -MP -MF $(TEST_DEP_DIR)/$*.d

# # Library Flags
TARGET_LIB_FLAGS	:= -L$(TARGET_LIB_DIR)
TEST_LIB_FLAGS		:= -L$(TEST_LIB_DIR)

# # Include Flags
INCLUDE_FLAGS		:= -I$(INCLUDE_DIR) -I$(EXTERNAL_DIR) -I$(TARGET_SRC) -I$(TEST_SRC)

# Compiler Flags
FLAGS				:= $(INCLUDE_FLAGS)
CC_FLAGS			:= $(FLAGS) -std=c99
CXX_FLAGS			:= $(FLAGS) -std=c++2a
ASM_FLAGS			:= -f elf64

# Library Files
vpath %.c $(TARGET_SRC)
vpath %.c $(TEST_SRC)
vpath %.cpp $(TARGET_SRC)
vpath %.cpp $(TEST_SRC)
vpath %.s $(TARGET_SRC)
vpath %.s $(TEST_SRC)
vpath %.h $(INCLUDE_DIR)
vpath %.h $(EXTERNAL_DIR)
vpath %.h $(TARGET_SRC)
vpath %.h $(TEST_SRC)
vpath %.o $(TARGET_OBJ_DIR)
vpath %.o $(TEST_OBJ_DIR)
vpath %.d $(TARGET_DEP_DIR)
vpath %.d $(TEST_DEP_DIR)

# Library Files
TARGET_SOURCES		:= $(wildcard $(TARGET_SRC)/*.c) $(wildcard $(TARGET_SRC)/*.cpp) $(wildcard $(TARGET_SRC)/*.s)
TARGET_OBJECTS		:= $(patsubst $(TARGET_SRC)%,$(TARGET_OBJ_DIR)%, $(patsubst %.c,%.o, $(TARGET_SOURCES)))
TARGET_DEPENDENCIES	:= $(patsubst $(TARGET_OBJ_DIR)%,$(TARGET_DEP_DIR)%, $(patsubst %.o,%.d, $(TARGET_OBJECTS)))

TEST_SOURCES		:= $(wildcard $(TEST_SRC)/*.c) $(wildcard $(TEST_SRC)/*.cpp) $(wildcard $(TEST_SRC)/*.s)
TEST_OBJECTS		:= $(patsubst $(TEST_SRC)%,$(TEST_OBJ_DIR)%, $(patsubst %.c,%.o, $(TEST_SOURCES)))
TEST_TARGET_OBJECTS := $(patsubst $(TARGET_OBJ_DIR)/main.o,, $(TARGET_OBJECTS))
TEST_DEPENDENCIES	:= $(patsubst $(TEST_OBJ_DIR)%,$(TEST_DEP_DIR)%, $(patsubst %.o,%.d, $(TEST_OBJECTS)))

# Formatting
bold := $(shell tput bold)
sgr0 := $(shell tput sgr0)

# Windows Support
ifeq ($(OS),Windows_NT)
	# Windows
	# RM := del /Q
	RM := rm -rf
	MKDIR_P := mkdir
else
	# Linux
	RM := rm -rf
	MKDIR_P := mkdir -p
endif

# Phony Targets
.PHONY: all build clean run test debug release profile

# Targets
all: build $(TARGET_EXECUTABLE) $(TEST_EXECUTABLE)

build: clean
	@$(MKDIR_P) $(BUILD_DIRS)

debug: CC_FLAGS +=  -g -O0 -Wall -Wextra -Wpedantic -Werror -Wfatal-errors
debug: CXX_FLAGS += -g -O0 -Wall -Wextra -Wpedantic -Werror -Wfatal-errors
debug: all

release: CC_FLAGS += -O2
release: CXX_FLAGS += -O2
release: all

profile: CC_FLAGS += -pg
profile: CXX_FLAGS += -pg
profile: all

$(TARGET_EXECUTABLE): $(TARGET_OBJECTS)
	$(CC) $(CC_FLAGS) $(TARGET_LIB_FLAGS) $(TARGET_OBJECTS) -o $(TARGET_EXECUTABLE) $(TARGET_LIBRARIES)

$(TEST_EXECUTABLE): $(TEST_OBJECTS)
	$(CC) $(CC_FLAGS) $(TEST_LIB_FLAGS) $(TEST_TARGET_OBJECTS) $(TEST_OBJECTS) -o $(TEST_EXECUTABLE) $(TARGET_LIBRARIES) $(TEST_LIBRARIES) 

$(TARGET_OBJ_DIR)/%.o: $(TARGET_SRC)/%.c
	$(CC) $(CC_FLAGS) $(TARGET_DEP_FLAGS) -c $< -o $@

$(TARGET_OBJ_DIR)/%.o: $(TARGET_SRC)/%.cpp
	$(CXX) $(CXX_FLAGS) $(TARGET_DEP_FLAGS) -c $< -o $@

$(TARGET_OBJ_DIR)/%.o: $(TARGET_SRC)/%.s
	$(ASM) $(ASM_FLAGS) $(TARGET_DEP_FLAGS) -c $< -o $@

$(TEST_OBJ_DIR)/%.o: $(TEST_SRC)/%.c
	$(CC) $(CC_FLAGS) $(TEST_DEP_FLAGS) -c $< -o $@

$(TEST_OBJ_DIR)/%.o: $(TEST_SRC)/%.cpp
	$(CXX) $(CXX_FLAGS) $(TEST_DEP_FLAGS) -c $< -o $@

$(TEST_OBJ_DIR)/%.o: $(TEST_SRC)/%.s
	$(ASM) $(ASM_FLAGS) $(TEST_DEP_FLAGS) -c $< -o $@

run: all $(TARGET_EXECUTABLE)
	$(TARGET_EXECUTABLE)

test: all $(TEST_EXECUTABLE)
	$(TEST_EXECUTABLE)

clean:
	@$(RM) $(BUILD_DIR)

info:
	@echo ""
	@echo "$(bold)Title:$(sgr0) Makefile for C/C++/Assembly Projects"
	@echo "$(bold)Author:$(sgr0) Matthew Knowlton <matt at toastloop dot com>"
	@echo "$(bold)Date:$(sgr0) 2023-09-19"
	@echo "$(bold)License:$(sgr0) MIT License"
	@echo "$(bold)Usage:$(sgr0) make [all|clean|run|test|debug|release|profile|info]"

# Include Dependencies
-include $(TARGET_DEPENDENCIES)
-include $(TEST_DEPENDENCIES)