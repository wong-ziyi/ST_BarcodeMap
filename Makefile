DIR_INC := ./inc
DIR_SRC := ./src
DIR_OBJ := ./obj

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

# Use Conda’s Boost, but system GCC
INCLUDE_DIRS = -I$(DIR_INC) -I$(CONDA_PREFIX)/include -I/usr/include/hdf5/serial
LIBRARY_DIRS = -L$(CONDA_PREFIX)/lib -L/usr/lib/x86_64-linux-gnu/hdf5/serial

SRC := $(wildcard ${DIR_SRC}/*.cpp)
OBJ := $(patsubst %.cpp,${DIR_OBJ}/%.o,$(notdir ${SRC}))

TARGET := ST_BarcodeMap
BIN_TARGET := ${TARGET}

CXX := g++
CXXFLAGS := -std=c++11 -g -O3 $(INCLUDE_DIRS)
LD_FLAGS := $(LIBRARY_DIRS) -lboost_serialization -lhdf5 -lz -lpthread

${BIN_TARGET}: ${OBJ}
	$(CXX) $(OBJ) -o $@ $(LD_FLAGS)

${DIR_OBJ}/%.o: ${DIR_SRC}/%.cpp make_obj_dir
	$(CXX) -c $< -o $@ $(CXXFLAGS)

.PHONY: clean
clean:
	rm -f ${DIR_OBJ}/*.o
	rm -f ${TARGET}

make_obj_dir:
	@if [ ! -d ${DIR_OBJ} ]; then mkdir -p ${DIR_OBJ}; fi

install:
	install ${TARGET} ${BINDIR}/${TARGET}
	@echo "Installed."
