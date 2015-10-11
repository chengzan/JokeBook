//  JBTabBarController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBTabBarController.h"
#import "JBNavigationController.h"
#import "JBConst.h"


@interface JBTabBarController ()<UITabBarControllerDelegate>

@end

@implementation JBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //3.加载storyBoard
    UIStoryboard *jokeStoryBoard=[UIStoryboard storyboardWithName:@"Joke" bundle:nil];
    
    [self addChildVc:jokeStoryBoard.instantiateInitialViewController title:@"糗事" image:@"icon_main" selectedImage:@"icon_main_active"];
    
    UIStoryboard *discoverStoryBoard=[UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    
    [self addChildVc:discoverStoryBoard.instantiateInitialViewController title:@"发现" image:@"main_tab_discovery" selectedImage:@"main_tab_discovery_active"];
    
    UIStoryboard *chatStoryBoard=[UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    
    [self addChildVc:chatStoryBoard.instantiateInitialViewController title:@"小纸条" image:@"icon_chat" selectedImage:@"icon_chat_active"];
    
    UIStoryboard *profileStoryBoard=[UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    
    [self addChildVc:profileStoryBoard.instantiateInitialViewController title:@"我" image:@"icon_me" selectedImage:@"icon_me_active"];
    
    //JBLog(@"tabBar=%@",self.tabBar);
    self.delegate=self;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = JBColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    //JBNavigationController *nav = [[JBNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:childVc];
}

#pragma mark tabBar的代理方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.childViewControllers.count && viewController == self.childViewControllers[0]) {
        [JBNotificationCenter postNotificationName:JBTabBarItemDidSelectNotification object:nil];
    }
    
}

@end
