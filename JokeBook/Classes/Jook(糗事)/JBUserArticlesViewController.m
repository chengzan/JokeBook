//
//  JBUserArticlesViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBUserArticlesViewController.h"
#import "JBConst.h"

@interface JBUserArticlesViewController ()

@end

@implementation JBUserArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupNav
{
    UINavigationController *navgationVC=self.navigationController;
    navgationVC.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                    NSForegroundColorAttributeName:[UIColor blackColor]};
    
    //navgationVC.navigationBar.barTintColor=JBColor(150, 165, 252);
    self.navigationItem.title=@"TA的糗事";
    
    // 设置左边的返回按钮
    UIImage *image=[UIImage imageNamed:@"icon_back"];
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem =leftBarItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
