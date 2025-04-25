BIN = hello
OBJ = src/main.o

.PHONY: all clean

all: $(BIN)

clean:
	rm -f $(BIN) $(OBJ)

$(BIN): $(OBJ)
	$(CC) -o $@ $^

%.o: %.c
	$(CC) -o $@ -c $<
