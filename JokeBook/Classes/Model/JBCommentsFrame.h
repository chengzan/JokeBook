//
//  JBCommentsFrame.h
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JBComments;

@interface JBCommentsFrame : NSObject
@property (strong,nonatomic) JBComments *comments;
@property (assign,nonatomic) CGFloat cellHeight;
@property (assign,nonatomic) CGFloat contentHeight;
@property (assign,nonatomic) CGFloat contentWidth;
@end
