//
//  JBExclusiveTableViewCellContentViewController.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBJokesFrame;

@interface JBExclusiveTableViewCellContentViewController : UIViewController
@property (nonatomic,assign,getter=isTableHeader) BOOL tableHeader;
@property (nonatomic, strong) JBJokesFrame *jokesFrame;

@property (nonatomic,copy) void (^ClickImageBlock)(NSUInteger index);
@end
