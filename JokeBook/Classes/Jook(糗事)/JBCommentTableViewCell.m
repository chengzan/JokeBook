//
//  JBCommentTableViewCell.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBCommentTableViewCell.h"
#import "JBCommentContentViewController.h"

@interface JBCommentTableViewCell()

@property (nonatomic,strong) JBCommentContentViewController *cellContentViewVC;
@end

@implementation JBCommentTableViewCell

- (JBCommentContentViewController *)cellContentViewVC
{
    if (_cellContentViewVC == nil) {
        _cellContentViewVC=[[JBCommentContentViewController alloc] init];
    }
    return _cellContentViewVC;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    JBCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JBCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候默认颜色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化评论
        [self.contentView addSubview:self.cellContentViewVC.view];
        
    }
    return self;
}

- (void)setCommentsFrame:(JBCommentsFrame *)commentsFrame
{
    //_commentsFrame=commentsFrame;
    self.cellContentViewVC.commentsFrame=commentsFrame;
}

@end