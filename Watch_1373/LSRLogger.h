//
//  LSRLogger.h
//  Watch_1373
//
//  Created by William LaFrance on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

#import <Foundation/Foundation.h>


void _LSRLogImpl(NSString *filename, int lineNumber, NSString *functionName, NSString *domain, int level, NSString *message);
