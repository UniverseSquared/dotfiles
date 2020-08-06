OBJS = src/main.o
BIN = %%PROJECT%%

.PHONY: all clean

all: $(BIN)

clean:
	rm -f $(BIN) $(OBJS)

$(BIN): $(OBJS)
	$(CC) -o $@ $^

%.o: %.c
	$(CC) -o $@ -c $<
