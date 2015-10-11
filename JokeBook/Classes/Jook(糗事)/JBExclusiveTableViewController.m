//
//  JBExclusiveTableViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/2.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBExclusiveTableViewController.h"
#import "JBConst.h"
#import "JBHttpTool.h"
#import "MJRefresh.h"
#import "JBJokesFrame.h"
#import "MJExtension.h"
#import "JBExclusiveTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
#import "JBCommentViewController.h"
#import "JBTransition.h"
#include "JBJokes.h"


@interface JBExclusiveTableViewController ()<UIScrollViewDelegate>
/** 糗事数组（里面放的都是JBJokesFrame模型，一个JBJokesFrame对象就代表一条糗事）*/
@property (nonatomic, strong) NSMutableArray *jokesFrames;
@property (assign,nonatomic) NSInteger pageIndex;//下拉刷新的适合page++

//判断scrollView的滚动方向：向上或者向下滚动
@property (assign,nonatomic) CGFloat contentOffsetY;
@property (assign,nonatomic) CGFloat oldContentOffsetY;
@property (assign,nonatomic) CGFloat newContentOffsetY;

@property (assign,nonatomic) ScrollDirectionType scrollType;
@end

@implementation JBExclusiveTableViewController

- (NSMutableArray *)jokesFrames
{
    if (!_jokesFrames) {
        _jokesFrames = [NSMutableArray array];
    }
    return _jokesFrames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex=1;
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉刷新控件
    [self setupUpRefresh];
    
    // 监听加载新的jokes的通知
    [JBNotificationCenter addObserver:self selector:@selector(loadNewJokesNotificationWithIndex:) name:JBLoadNewJokesNotification object:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    JBLog(@"viewWillAppear");
//}


- (void)loadNewJokesNotificationWithIndex:(NSNotification *)notification
{
    NSNumber *indexNumber = notification.userInfo[JBLoadNewJokesKey];
    if (indexNumber.integerValue==self.currentIndex) {
        //JBLog(@"currentIndex=%ld load New Jokes",self.currentIndex);
        // 2.进入刷新状态
        [self.tableView headerBeginRefreshing];
    }
}

- (void)dealloc
{
    [JBNotificationCenter removeObserver:self];
}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreJokes)];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewJokes)];
    
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}

- (void)loadMoreJokes
{
    self.tableView.userInteractionEnabled =NO;
    // 2.发送请求
    NSString * url=[NSString stringWithFormat:@"%@count=%d&page=%ld",self.sourceURLPrefix,LoadCount,++self.pageIndex];
    [JBHttpTool get:url params:nil success:^(id json) {
        
        NSNumber *errNumber=json[@"err"];
        if (errNumber.integerValue) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误信息：%@",json[@"err_msg"]] toView:window];
        }
        
        NSNumber *itemsCount=json[@"count"];
        if (itemsCount.integerValue) {
            
            // 将 "糗事字典"数组 转为 "糗事模型"数组
            NSArray *newItems = [JBJokes objectArrayWithKeyValuesArray:json[@"items"]];
            //JBLog(@"Jokes=%@",json);
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"为您刷新了%@条数据",itemsCount] toView:window];
            // 将 newItems数组 转为 JBJokesFrame数组
            NSArray *newFrames = [self jokeFramesWithJokes:newItems];
            //JBLog(@"newFrames=%@",newFrames);
            // 将更多的微博数据，添加到总数组的最后面
            [self.jokesFrames addObjectsFromArray:newFrames];
            //JBLog(@"jokesFrames=%@",self.jokesFrames);
            // 刷新表格
            [self.tableView reloadData];
        }
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
        self.tableView.userInteractionEnabled =YES;
    } failure:^(NSError *error) {
        JBLog(@"请求失败-%@", error);
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [MBProgressHUD showError:@"您的网络不给力，请稍后再试" toView:window];
        // 结束刷新
        [self.tableView footerEndRefreshing];
        self.tableView.userInteractionEnabled =YES;
    }];
}

/**
 *  将JBJokes模型转为JBJokesFrame模型
 */
- (NSArray *)jokeFramesWithJokes:(NSArray *)jokeses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (JBJokes *jokes in jokeses) {
        JBJokesFrame *f = [[JBJokesFrame alloc] init];
        f.jokes = jokes;
        [frames addObject:f];
    }
    return frames;
}


/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 *  http://m2.qiushibaike.com/article/112722093/comments?article=1&count=50&page=1&AdID=14414621357804556AEEF1
 */
- (void)loadNewJokes
{
    self.tableView.userInteractionEnabled =NO;
    // 2.发送请求
    NSString *url=[NSString stringWithFormat:@"%@count=%ld&page=1",self.sourceURLPrefix,self.loadCount];
    [JBHttpTool get:url params:nil success:^(id json) {
        //JBLog(@"Jokes=%@",json);
        //JBLog(@"url=%@",url);
        
        NSNumber *errNumber=json[@"err"];
        if (errNumber.integerValue) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误信息：%@",json[@"err_msg"]] toView:window];
        }
        
        NSNumber *itemsCount=json[@"count"];
        if (itemsCount.integerValue) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"为您刷新了%@条数据",itemsCount] toView:window];
            // 将 "糗事字典"数组 转为 "糗事模型"数组
            NSArray *newItems = [JBJokes objectArrayWithKeyValuesArray:json[@"items"]];
            //JBLog(@"Jokes=%@",json[@"items"]);
            // 将 newItems数组 转为 JBJokesFrame数组
            NSArray *newFrames = [self jokeFramesWithJokes:newItems];
            //JBLog(@"newFrames=%@",newFrames);
            // 将最新的微博数据，添加到总数组的最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.jokesFrames insertObjects:newFrames atIndexes:set];
            //JBLog(@"jokesFrames=%@",self.jokesFrames);
            // 刷新表格
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView headerEndRefreshing];
        self.tableView.userInteractionEnabled =YES;
        
        // 显示最新微博的数量
        //[self showNewStatusCount:newStatuses.count];
    } failure:^(NSError *error) {
        JBLog(@"请求失败-%@", error);
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [MBProgressHUD showError:@"您的网络不给力，请稍后再试" toView:window];
        // 结束刷新刷新
        [self.tableView headerEndRefreshing];
        self.tableView.userInteractionEnabled =YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jokesFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获得cell
    JBExclusiveTableViewCell *cell = [JBExclusiveTableViewCell cellWithTableView:tableView];

    // 给cell传递模型数据
    cell.jokesFrame = self.jokesFrames[indexPath.row];
    
    //JBLog(@"cell=%@,row=%ld",cell,indexPath.row);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBJokesFrame *frame = self.jokesFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JBJokesFrame *frame = self.jokesFrames[indexPath.row];
    //if (frame.jokes.user == nil) return;
    
    UIStoryboard *UserPreviewStoryBoard=[UIStoryboard storyboardWithName:@"Comment" bundle:nil];
    
    
    JBCommentViewController *commentVC=UserPreviewStoryBoard.instantiateInitialViewController;
    commentVC.jokesFrame=frame;

    [self.navigationController pushViewController:commentVC animated:YES];
#pragma mark //如果用self.view.window.rootViewController这个方法将无法使用全屏手势返回
    //[self.view.window.rootViewController presentViewController:navgationVC animated:YES completion:nil];
}

#pragma mark - ******************** scrollView代理方法
/** 开始拖拽视图 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentOffsetY = scrollView.contentOffset.y;
}

/** 滚动结束 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkScrollDirection:scrollView];
    
    if(!self.jokesFrames.count) return;
   
    if (self.jokesFrames.count == 1) {
        JBJokesFrame *frame = self.jokesFrames[0];
        if(frame.cellHeight < self.view.height) return;
    }
    
    // 获得索引
    CGFloat offsetY = scrollView.contentOffset.y;
    //JBLog(@"offsetY=%f",offsetY);
    if (offsetY < 0) {
        [self sentNotificationWithOffsetY:0];
    }else if (offsetY >= 0 && offsetY <= TopViewHeight) {
        [self sentNotificationWithOffsetY:offsetY];
    }else{
        [self sentNotificationWithOffsetY:TopViewHeight];
    }
    //JBLog(@"offsetY=%f",offsetY);
}

/** 完成拖拽(滚动停止时调用此方法，手指离开屏幕前) */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.oldContentOffsetY = scrollView.contentOffset.y;
}

- (void)checkScrollDirection:(UIScrollView *)scrollView
{
    self.newContentOffsetY = scrollView.contentOffset.y;
    if (self.newContentOffsetY > self.oldContentOffsetY && self.oldContentOffsetY > self.contentOffsetY) {  // 向上滚动
        //JBLog(@"up");
        self.scrollType=ScrollDirectionTypeUp;
        
    } else if (self.newContentOffsetY < self.oldContentOffsetY && self.oldContentOffsetY < self.contentOffsetY) { // 向下滚动
        //JBLog(@"down");
        self.scrollType=ScrollDirectionTypeDown;
    }
    
    if (scrollView.dragging) {  // 拖拽
        if ((scrollView.contentOffset.y - self.contentOffsetY) > 5.0f) {  // 向上拖拽
            //JBLog(@"up");
            self.scrollType=ScrollDirectionTypeUp;

        } else if ((self.contentOffsetY - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
            //JBLog(@"down");
            self.scrollType=ScrollDirectionTypeDown;

        }
    }
}

#pragma mark -发出通知
- (void)sentNotificationWithOffsetY:(CGFloat)offsetY
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBTableViewScrollKey] = [NSNumber numberWithFloat:offsetY];
    userInfo[JBTableViewScrollDirectionKey] = [NSNumber numberWithInt:self.scrollType];
    [JBNotificationCenter postNotificationName:JBTableViewScrollNotification object:nil userInfo:userInfo];
}

@end
