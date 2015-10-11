//
//  JBCoverView.m
//  JokeBook
//
//  Created by shanzy on 15/9/8.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBCoverView.h"
#import "UIView+Extension.h"

@implementation JBCoverView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (instancetype)coverView
{
    return [[self alloc] init];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

- (void)setContentControllerViewOrigin:(CGPoint)origin
{
    self.contentController.view.centerY=origin.y;
    self.contentController.view.x=origin.x-self.contentController.view.width;
    
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    self.contentController.view.size=[UIImage imageNamed:@"commentMoreBackgroundView"].size;
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController=contentController;
    
    [self addSubview:_contentController.view];
}
@end
