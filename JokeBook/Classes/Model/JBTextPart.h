//
//  JBTextPart.h
//
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年  All rights reserved.
//  文字的一部分

#import <Foundation/Foundation.h>

@interface JBTextPart : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
@end
