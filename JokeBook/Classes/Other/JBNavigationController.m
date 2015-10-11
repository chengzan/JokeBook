//  JBNavigationController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBNavigationController.h"
#import "JBConst.h"

@interface JBNavigationController ()

@end

@implementation JBNavigationController


+ (void)load
{
    // 设置导航栏的主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:JBColor(245, 245, 245)];
}

@end
