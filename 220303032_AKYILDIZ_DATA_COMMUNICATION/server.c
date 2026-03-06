#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <arpa/inet.h>

#include "protocol.h"
#include "crc32.h"

static int read_exact(int fd, void *buf, size_t n){
    size_t t=0; uint8_t*p=buf;
    while(t<n){
        ssize_t r=recv(fd,p+t,n-t,0);
        if(r<=0) return 0;
        t+=r;
    }
    return 1;
}

static void send_ack(int fd,uint16_t id){
    char t[3]={'A','C','K'};
    id=htons(id);
    send(fd,t,3,0);
    send(fd,&id,2,0);
}

static void send_nack(int fd,uint16_t id){
    char t[3]={'N','A','C'};
    id=htons(id);
    send(fd,t,3,0);
    send(fd,&id,2,0);
}

int main(int argc,char*argv[]){
    int s=socket(AF_INET,SOCK_STREAM,0);
    struct sockaddr_in a={0};
    a.sin_family=AF_INET;
    a.sin_port=htons(atoi(argv[1]));
    a.sin_addr.s_addr=INADDR_ANY;

    bind(s,(void*)&a,sizeof(a));
    listen(s,1);
    int c=accept(s,NULL,NULL);

    FILE *img=NULL;

    while(1){
        FrameHeader h;
        if(!read_exact(c,&h,sizeof(h))) break;

        h.frameID=ntohs(h.frameID);
        h.payloadSize=ntohl(h.payloadSize);
        h.crc32=ntohl(h.crc32);

        uint8_t *p=malloc(h.payloadSize);
        read_exact(c,p,h.payloadSize);

        if(crc32_compute(p,h.payloadSize)!=h.crc32){
            send_nack(c,h.frameID);
            free(p); continue;
        }

        send_ack(c,h.frameID);

        if(h.frameType==FRAME_TYPE_TELEMETRY){
            printf("[TELEMETRY] %.*s\n",(int)h.payloadSize,p);
        }

        if(h.frameType==FRAME_TYPE_IMAGE){
            if(h.frameID==0) img=fopen("received.jpg","wb");
            fwrite(p,1,h.payloadSize,img);
            if(h.frameID+1==ntohl(h.totalFrames)) fclose(img);
        }
        free(p);
    }
}
