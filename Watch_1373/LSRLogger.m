//
//  LSRLogger.m
//  Watch_1373
//
//  Created by William LaFrance on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

#import "LSRLogger.h"
#import "NSLogger.h"

void _LSRLogImpl(NSString *filename, int lineNumber, NSString *functionName, NSString *domain, int level, NSString *message) {
    LogMessageF([filename cStringUsingEncoding:NSUTF8StringEncoding],
                lineNumber,
                [functionName cStringUsingEncoding:NSUTF8StringEncoding],
                domain,
                level,
                @"%@",
                message);
}
