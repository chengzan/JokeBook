//
//  JBCommentTableViewCell.h
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBCommentsFrame;

@interface JBCommentTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) JBCommentsFrame *commentsFrame;
@end

