//
//  JBSpecial.m
//  
//
//  Created by apple on 14/11/15.
//  Copyright (c) 2014年 All rights reserved.
//

#import "JBSpecial.h"

@implementation JBSpecial
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}
@end
