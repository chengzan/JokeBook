//
//  JBJokes.m
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBJokes.h"
#import "MJExtension.h"

@implementation JBJokes

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

- (NSString *)getImage
{
    if ([self.image isEqualToString:@"<null>"]) return @"";
    
    return self.image;
}


@end
