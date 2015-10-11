//
//  JBExclusiveTableViewController.h
//  JokeBook
//
//  Created by shanzy on 15/9/2.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBExclusiveTableViewController : UITableViewController
@property (nonatomic,copy) NSString *sourceURLPrefix;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger loadCount;
@end
