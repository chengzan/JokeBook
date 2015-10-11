//
//  JBJokeMartViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/9.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//http://www.wemart.cn/v2/weimao/index.html?wemartIOSApp=true&user_id=ios_418B5BBE9F40F8364D8E4EA25015E7B9&user_name=shanzy&shopId=shop001201501095297

#import "JBJokeMartViewController.h"

@interface JBJokeMartViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation JBJokeMartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupWebView];
}

- (void)setupWebView
{
    self.webView.opaque=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    NSString *path = @"http://www.wemart.cn/v2/weimao/index.html?wemartIOSApp=true&user_id=ios_418B5BBE9F40F8364D8E4EA25015E7B9&user_name=shanzy&shopId=shop001201501095297";
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setupNav
{
    // 设置左边的返回按钮
    UIImage *image=[UIImage imageNamed:@"icon_back"];
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem =leftBarItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
    
    self.navigationItem.title=@"糗百货";
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
