NAME ?= msec
CFLAGS ?= -Wall -Wextra -Werror -pedantic -std=c17 -O3 -ffast-math -march=native -mtune=native
PREFIX ?= /usr/local/bin

.PHONY: all
all: install

$(NAME): $(NAME).c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm -f $(NAME)

.PHONY: install
install: $(NAME)
	cp -f $(NAME) $(PREFIX)/$(NAME)

.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/$(NAME)

