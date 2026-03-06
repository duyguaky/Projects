#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <time.h>

#include "protocol.h"

/* ================= TCP HELPERS ================= */

static int read_exact(int fd, void *buf, size_t n) {
    uint8_t *p = buf;
    size_t t = 0;
    while (t < n) {
        ssize_t r = recv(fd, p + t, n - t, 0);
        if (r <= 0) return r;
        t += r;
    }
    return 1;
}

static int write_exact(int fd, const void *buf, size_t n) {
    const uint8_t *p = buf;
    size_t t = 0;
    while (t < n) {
        ssize_t s = send(fd, p + t, n - t, 0);
        if (s <= 0) return s;
        t += s;
    }
    return 1;
}

/* ================= MAIN ================= */

int main(int argc, char *argv[]) {
    if (argc != 5) {
        fprintf(stderr,
            "Usage: %s <listen_port> <server_ip> <server_port> <noise_percent>\n",
            argv[0]);
        exit(1);
    }

    int listen_port = atoi(argv[1]);
    const char *server_ip = argv[2];
    int server_port = atoi(argv[3]);
    int noise_percent = atoi(argv[4]);

    srand(time(NULL));

    /* ---------- CLIENT → GATEWAY ---------- */
    int ls = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in la = {0};
    la.sin_family = AF_INET;
    la.sin_port = htons(listen_port);
    la.sin_addr.s_addr = INADDR_ANY;

    bind(ls, (struct sockaddr *)&la, sizeof(la));
    listen(ls, 1);

    printf("[Gateway] Listening on %d\n", listen_port);
    fflush(stdout);

    int cfd = accept(ls, NULL, NULL);
    printf("[Gateway] Client connected\n");
    fflush(stdout);

    /* ---------- GATEWAY → SERVER ---------- */
    int sfd = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in sa = {0};
    sa.sin_family = AF_INET;
    sa.sin_port = htons(server_port);
    inet_pton(AF_INET, server_ip, &sa.sin_addr);

    connect(sfd, (struct sockaddr *)&sa, sizeof(sa));
    printf("[Gateway] Connected to server %s:%d\n",
           server_ip, server_port);
    fflush(stdout);

    /* ---------- FORWARD LOOP ---------- */
    while (1) {
        FrameHeader h;
        if (read_exact(cfd, &h, sizeof(h)) <= 0)
            break;

        uint32_t payload_size = ntohl(h.payloadSize);
        uint8_t *payload = malloc(payload_size);

        read_exact(cfd, payload, payload_size);

        /* ===== NOISE INJECTION ===== */
        if (payload_size > 0 && (rand() % 100) < noise_percent) {
            int idx = rand() % payload_size;
            payload[idx] ^= 0x01;   // 1 bit boz
            printf("[Gateway] NOISE injected at byte %d\n", idx);
            fflush(stdout);
        }

        /* client → server */
        write_exact(sfd, &h, sizeof(h));
        write_exact(sfd, payload, payload_size);

        /* server → client (ACK / NACK) */
        uint8_t ack[5];
        read_exact(sfd, ack, 5);
        write_exact(cfd, ack, 5);

        free(payload);
    }

    close(cfd);
    close(sfd);
    close(ls);
    return 0;
}
