OPTIONS = -Wall -Wextra -shared -fPIC -I/user/local/include -o
LIBFLAGS = -lncurses -L/user/local/lib/ 
OUTPUT   = sluacurses.so
SRC      = sluacurses.c
CC       = gcc

all:
	$(CC) $(OPTIONS)$(OUTPUT) $(LIBFLAGS) $(SRC)
