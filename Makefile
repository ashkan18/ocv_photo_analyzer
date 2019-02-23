# Variables to override
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# ERL_CFLAGS	additional compiler flags for files using Erlang header files
# ERL_EI_LIBDIR path to libei.a
# LDFLAGS	linker flags for linking all binaries
# ERL_LDFLAGS	additional linker flags for projects referencing Erlang libraries

CFLAGS= -g
#CFLAGS += -DDEBUG

SRC=$(wildcard src/*.cpp)

CFLAGS = -I"/usr/local/include/"
ERL_ROOT_DIR = $(ERLHOME)

# Look for the EI library and header files
# For crosscompiled builds, ERL_EI_INCLUDE_DIR and ERL_EI_LIBDIR must be
# passed into the Makefile.
ifeq ($(ERL_EI_INCLUDE_DIR),)
ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ifeq ($(ERL_ROOT_DIR),)
   $(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
endif
ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

# Set Erlang-specific compile and linker flags
# ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR) -L$(/usr/lib)

LIBS_opencv = -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_video -lopencv_objdetect -lopencv_imgcodecs

HEADER_FILES = src

OBJ=$(SRC:.cpp=.o)

.PHONY: all clean

all: src priv priv/analyzer
				
priv:
	mkdir -p priv

priv/analyzer: $(OBJ)
	$(CC) -I $(HEADER_FILES) -o $@ $(LIBS_opencv)

clean:
	rm -f priv/analyzer$(EXEEXT) src/*.o src/ei_copy/*.o




