//
//  JBExclusiveTableViewCell.m
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBExclusiveTableViewCell.h"
#import "JBExclusiveTableViewCellContentViewController.h"
#import "JBJokesFrame.h"
#import "JBConst.h"
@interface JBExclusiveTableViewCell()
@property (nonatomic,strong) JBExclusiveTableViewCellContentViewController *cellContentViewVC;
@end

@implementation JBExclusiveTableViewCell

- (JBExclusiveTableViewCellContentViewController *)cellContentViewVC
{
    if (_cellContentViewVC == nil) {
        _cellContentViewVC=[[JBExclusiveTableViewCellContentViewController alloc] init];
    }
    return _cellContentViewVC;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Joke";
    JBExclusiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JBExclusiveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        
        //JBLog(@"cell create");
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
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // 初始化糗事
        [self.contentView addSubview:self.cellContentViewVC.view];
        
    }
    return self;
}

- (void)setJokesFrame:(JBJokesFrame *)jokesFrame
{
    //_jokesFrame=jokesFrame;
    self.cellContentViewVC.jokesFrame=jokesFrame;
    
}

/*
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{ 
    
}
*/
@end
