//
//  LSRFrameworkBluetoothSupport.h
//  Watch_1373
//
//  Created by William LaFrance on 4/2/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

#pragma once

// The purpose of this file is to import headers from the LSR C framework with as few modifications as possible.

#ifdef __cplusplus
    #define EXTERN_C       extern "C"
    #define EXTERN_C_BEGIN extern "C" {
    #define EXTERN_C_END   }
#else
    #define EXTERN_C       /* Nothing */
    #define EXTERN_C_BEGIN /* Nothing */
    #define EXTERN_C_END   /* Nothing */
#endif

#define __NO_LSR_C_FRAMEWORK_H__

#define LSR_MSG_HEADER_SIZE_OPT    (LSR_MSG_SMALL_HEADER)

#define ASSERT_SIZE(x,y) /* nop */

typedef int LSR_Result_t;

#import "lsr_msg.h"

#import "global_msgs.h"

#import "msg_codes.h"

#import "msg_ids.h"
