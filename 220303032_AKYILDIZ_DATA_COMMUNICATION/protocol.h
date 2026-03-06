#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdint.h>

#define FRAME_TYPE_TEXT      0
#define FRAME_TYPE_TELEMETRY 1
#define FRAME_TYPE_IMAGE     2

typedef struct __attribute__((packed)) {
    uint8_t  frameType;      // TEXT / TELEMETRY / IMAGE
    uint8_t  reserved;
    uint16_t frameID;        // unique frame id
    uint32_t totalFrames;    // image için toplam frame sayısı
    uint32_t payloadSize;    // payload uzunluğu
    uint32_t crc32;          // CRC32
} FrameHeader;

#endif
