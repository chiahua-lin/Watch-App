//
//  TestPackableStruct.h
//  Watch_1373
//
//  Created by William LaFrance on 5/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

#pragma once

#import <stdint.h>

#pragma pack(push, 1)
typedef struct {
    uint8_t  u8;
    uint16_t u16;
    uint32_t u32;
    uint64_t u64;
} TestPackable;
#pragma pop
