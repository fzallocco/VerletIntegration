CC = gcc
CFLAGS = -Wall -std=c99 -O2

OUTPUT = app
SRC_DIR = src
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:.c=.o)

UNAME_S := $(shell uname -s)
BREW_PREFIX := $(shell brew --prefix 2>/dev/null)

ifeq ($(UNAME_S),Darwin)
	CFLAGS += -I$(BREW_PREFIX)/include
	LDFLAGS = -L$(BREW_PREFIX)/lib -lpthread -lglfw -lGLEW \
		-framework Cocoa \
		-framework OpenGL \
		-framework IOKit \
		-framework CoreVideo
else
	CFLAGS += -Isrc/dependencies/include
	LDFLAGS = -Lsrc/dependencies/library -lpthread -lglfw -lGLEW
endif

all: $(OUTPUT)

$(OUTPUT): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

debug: CFLAGS += -DDEBUG -O0 -g
debug: clean $(OUTPUT)

clean:
	rm -f $(OBJ) $(OUTPUT)

run: all
	./$(OUTPUT)
