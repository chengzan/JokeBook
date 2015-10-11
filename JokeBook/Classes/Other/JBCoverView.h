//
//  JBCoverView.h
//  JokeBook
//
//  Created by shanzy on 15/9/8.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBCoverView : UIView
+ (instancetype)coverView;

- (void)setContentControllerViewOrigin:(CGPoint)origin;

@property (nonatomic, strong) UIViewController *contentController;
@end
