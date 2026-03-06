#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <arpa/inet.h>

#include "protocol.h"
#include "crc32.h"

#define MAX_PAYLOAD 512
#define MAX_RETRY   3

static int read_exact(int fd, void *buf, size_t n) {
    size_t t = 0; uint8_t *p = buf;
    while (t < n) {
        ssize_t r = recv(fd, p+t, n-t, 0);
        if (r <= 0) return 0;
        t += r;
    }
    return 1;
}

static int write_exact(int fd, const void *buf, size_t n) {
    size_t t = 0; const uint8_t *p = buf;
    while (t < n) {
        ssize_t s = send(fd, p+t, n-t, 0);
        if (s <= 0) return 0;
        t += s;
    }
    return 1;
}

static int wait_ack(int fd, uint16_t id) {
    char tag[3]; uint16_t rid;
    read_exact(fd, tag, 3);
    read_exact(fd, &rid, 2);
    return memcmp(tag,"ACK",3)==0 && ntohs(rid)==id;
}

static void send_frame(int fd, FrameHeader *h, uint8_t *payload) {
    write_exact(fd, h, sizeof(*h));
    write_exact(fd, payload, ntohl(h->payloadSize));
}

void send_telemetry(int fd) {
    for (uint16_t i=1;i<=5;i++) {
        char msg[256];
        snprintf(msg,sizeof(msg),
            "t=%u alt=%.2f vel=%.2f temp=%.2f fuel=%.2f accel=%.2f",
            i,10*i,5*i,20+0.2*i,100-0.8*i,9.8);

        FrameHeader h = {
            .frameType = FRAME_TYPE_TELEMETRY,
            .frameID = htons(i),
            .totalFrames = htonl(0),
            .payloadSize = htonl(strlen(msg)),
            .crc32 = htonl(crc32_compute((uint8_t*)msg, strlen(msg)))
        };

        for(int r=0;r<MAX_RETRY;r++){
            send_frame(fd,&h,(uint8_t*)msg);
            if(wait_ack(fd,i)) break;
        }
        sleep(1);
    }
}

void send_image(int fd, const char *path) {
    FILE *f = fopen(path,"rb");
    fseek(f,0,SEEK_END);
    long size = ftell(f);
    rewind(f);

    uint32_t total = (size + MAX_PAYLOAD -1)/MAX_PAYLOAD;
    uint8_t buf[MAX_PAYLOAD];

    for(uint32_t i=0;i<total;i++){
        size_t n = fread(buf,1,MAX_PAYLOAD,f);

        FrameHeader h = {
            .frameType = FRAME_TYPE_IMAGE,
            .frameID = htons(i),
            .totalFrames = htonl(total),
            .payloadSize = htonl(n),
            .crc32 = htonl(crc32_compute(buf,n))
        };

        for(int r=0;r<MAX_RETRY;r++){
            send_frame(fd,&h,buf);
            if(wait_ack(fd,i)) break;
        }
    }
    fclose(f);
}

int main(int argc,char*argv[]){
    int sock = socket(AF_INET,SOCK_STREAM,0);
    struct sockaddr_in a={0};
    a.sin_family=AF_INET;
    a.sin_port=htons(atoi(argv[2]));
    inet_pton(AF_INET,argv[1],&a.sin_addr);
    connect(sock,(void*)&a,sizeof(a));

    send_telemetry(sock);
    send_image(sock,"image.jpg");

    close(sock);
}
