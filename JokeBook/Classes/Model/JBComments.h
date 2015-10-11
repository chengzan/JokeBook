//
//  JBComments.h
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBUsers;

@interface JBComments : NSObject
@property (nonatomic,strong) JBUsers *user;

// 评论id
@property (nonatomic,copy) NSString *ID;

// 评论内容
@property (nonatomic,copy) NSString *content;

// 属性评论内容
@property (nonatomic,copy) NSAttributedString *attributedContent;

// 评论楼数
@property (nonatomic,copy) NSString *floor;
@end
