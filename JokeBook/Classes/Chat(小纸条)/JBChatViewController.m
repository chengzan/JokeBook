//
//  JBChatViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBChatViewController.h"

@interface JBChatViewController ()

@end

@implementation JBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIBarButtonItem* rightButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"create_newSession"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(startChat)];
    self.navigationItem.rightBarButtonItems =@[negativeSpacer,rightButtonItem];
}

- (void)startChat
{
    
}

@end
