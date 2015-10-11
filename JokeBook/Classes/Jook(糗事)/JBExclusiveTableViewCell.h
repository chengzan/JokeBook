//
//  JBExclusiveTableViewCell.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBJokesFrame;

@interface JBExclusiveTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) JBJokesFrame *jokesFrame;
@end
