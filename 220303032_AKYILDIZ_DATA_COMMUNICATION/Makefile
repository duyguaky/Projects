CC=gcc
CFLAGS=-Wall -Wextra -O2

all: server gateway client

server: server.c crc32.c
	$(CC) $(CFLAGS) -o server server.c crc32.c

gateway: gateway.c
	$(CC) $(CFLAGS) -o gateway gateway.c

client: client.c crc32.c
	$(CC) $(CFLAGS) -o client client.c crc32.c

clean:
	rm -f server gateway client
