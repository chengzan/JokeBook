//
//  JBReplyViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/8.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBReplyViewController.h"
#import "UIView+Extension.h"
#import "JBConst.h"
#import "JBComments.h"

@interface JBReplyViewController()
@end

@implementation JBReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view=[[[NSBundle mainBundle] loadNibNamed:@"ReplyView" owner:self options:nil] lastObject];
}

- (IBAction)replyButtonClicked:(id)sender {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBJokeReplyViewReplyKey] = self.comments;
    [JBNotificationCenter postNotificationName:JBJokeReplyViewReplyClickedNotification object:nil userInfo:userInfo];
}


@end
