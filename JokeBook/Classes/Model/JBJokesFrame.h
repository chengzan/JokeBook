//
//  JBJokesFrame.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JBJokes;
@interface JBJokesFrame : NSObject
@property (nonatomic, strong) JBJokes *jokes;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat imageHeight;
/** 文字的高度 */
@property (nonatomic, assign) CGFloat textHeight;
/** 赞按钮选中 */
@property (nonatomic, assign) BOOL upSelected;
/** 踩按钮选中 */
@property (nonatomic, assign) BOOL downSelected;
@end
