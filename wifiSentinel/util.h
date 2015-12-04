/*
 *  util.h
 *
 *  Created by michael russell on 10-11-15.
 *  Copyright 2010 Thumb Genius Software. All rights reserved.
 *
 */


#define TGLog(message, ...) NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:message, ##__VA_ARGS__])
#define TGMark    TGLog(@"");


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
