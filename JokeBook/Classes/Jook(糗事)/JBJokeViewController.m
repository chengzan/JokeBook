//
//  JBJokeTableViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBJokeViewController.h"
#import "JBConst.h"
#import "UIView+Extension.h"
#import "JBTopViewController.h"
#import "JBExclusiveTableViewController.h"
#import "JBTitleScrollViewController.h"
#import "JBUserPreviewController.h"

@interface JBJokeViewController ()<UIScrollViewDelegate,JBTopViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (assign,nonatomic) NSInteger selectedIndex;
@property (strong,nonatomic) JBTopViewController *topViewController;

@property (strong,nonatomic) UIView *titleContainerView;
@property (strong,nonatomic) JBTitleScrollViewController *titleScrollViewController;
@property (nonatomic,strong) UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewToTopCons;

@end

@implementation JBJokeViewController

- (UIView *)titleContainerView
{
    if (_titleContainerView == nil) {
        _titleContainerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, TitleScrollWidth*2, 0.5*TitleScrollWidth)];
        
        [_titleContainerView addSubview:self.titleImageView];
        [_titleContainerView addSubview:self.titleScrollViewController.view];
        self.titleImageView.frame=_titleContainerView.bounds;
        
        self.titleScrollViewController.view.frame=CGRectMake(0, 0.5*TitleScrollWidth, TitleScrollWidth*2, 0.5*TitleScrollWidth);
        _titleContainerView.clipsToBounds=YES;
    }
    return _titleContainerView;
}

- (JBTitleScrollViewController *)titleScrollViewController
{
    if (_titleScrollViewController == nil) {
        _titleScrollViewController=[[JBTitleScrollViewController alloc] init];
    }
    
    return _titleScrollViewController;
}

- (UIImageView *)titleImageView
{
    if (_titleImageView == nil) {
        _titleImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _titleImageView.contentMode=UIViewContentModeCenter;
    }
    return _titleImageView;
}

- (JBTopViewController *)topViewController
{
    if (_topViewController == nil) {
        _topViewController=[[JBTopViewController alloc] init];
    }
    
    return _topViewController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.topViewController.delegate=self;
    self.scrollView.delegate=self;
    
    [self addScrollContentController];
    
    [self.topView addSubview:self.topViewController.view];
    
    // 监听tableView滚动的通知
    [JBNotificationCenter addObserver:self selector:@selector(tableViewScrollWithNotification:) name:JBTableViewScrollNotification object:nil];
    
    // 监听第一个tabBar被点击的通知
    [JBNotificationCenter addObserver:self selector:@selector(tabBarItemDidSelectNotification) name:JBTabBarItemDidSelectNotification object:nil];
    
    
    // 监听cell头像被点击的通知
    [JBNotificationCenter addObserver:self selector:@selector(jokeCellIconClickedNotification:) name:JBJokeCellIconClickedNotification object:nil];
    
    self.scrollView.contentSize=CGSizeMake(ScreenWidth*ScrollCount, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor=JBColor(245, 245, 245);
    
    //JBLog(@"scrollView.contentSize=%@",NSStringFromCGSize(self.scrollView.contentSize));
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    JBLog(@"viewDidAppear");
//    self.scrollView.contentSize=CGSizeMake(ScreenWidth*ScrollCount, 0);
//    JBExclusiveTableViewController *exclusiveVC = self.childViewControllers[0];
//    JBLog(@"tableView size=%@",NSStringFromCGSize(exclusiveVC.view.size));
//    exclusiveVC.view.frame = self.scrollView.bounds;
//    exclusiveVC.view.hidden=NO;
//}


- (void) tabBarItemDidSelectNotification
{
    [self sentLoadNewJokesNotificationWithIndex:self.selectedIndex];
}

- (void) jokeCellIconClickedNotification:(NSNotification *)notification
{
    NSString *userID = notification.userInfo[JBJokeCellIconKey];
    UIStoryboard *UserPreviewStoryBoard=[UIStoryboard storyboardWithName:@"UserPreview" bundle:nil];

    JBUserPreviewController *userPreviewVC=UserPreviewStoryBoard.instantiateInitialViewController;
    userPreviewVC.userID=userID;

    [self.navigationController pushViewController:userPreviewVC animated:YES];
}

- (void) tableViewScrollWithNotification:(NSNotification *)notification
{
    NSNumber *offsetYNumber = notification.userInfo[JBTableViewScrollKey];
    NSNumber *scrollType = notification.userInfo[JBTableViewScrollDirectionKey];
    //JBLog(@"offsetY=%f",offsetYNumber.floatValue);

    CGFloat delta=NavgationHeight-offsetYNumber.floatValue;
    //if(delta == self.topViewToTopCons.constant) return;
    
    //JBLog(@"y=%f",self.titleScrollViewController.view.y);
    if(offsetYNumber.floatValue == 0 && self.titleScrollViewController.view.y==0 && scrollType.intValue==ScrollDirectionTypeUnknow) {
            return;
    }
    
    self.topViewToTopCons.constant=delta;
    
    self.titleImageView.y=(-offsetYNumber.floatValue)*0.5;
    
    self.titleScrollViewController.view.y=(TopViewHeight-offsetYNumber.floatValue)*0.5;
    
    if (offsetYNumber.floatValue == 0) {
        self.titleImageView.hidden=NO;
        self.titleScrollViewController.view.hidden=YES;
    }else if (offsetYNumber.floatValue < TopViewHeight) {
        self.titleImageView.hidden=NO;
        self.titleScrollViewController.view.hidden=NO;
    }else {
        self.titleImageView.hidden=YES;
        self.titleScrollViewController.view.hidden=NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addScrollContentController
{
    NSArray *prefixArray=@[JBSuggestPrefix,JBvideoPrefix,JBtextPrefix,JBimgrankPrefix,JBDayPrefix,JBLatestPrefix];
    
   
    for (NSInteger i=0;i < prefixArray.count;i++) {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"JBExclusive" bundle:nil];
        JBExclusiveTableViewController *exclusiveVC = storyBoard.instantiateInitialViewController;
        
        [self addChildViewController:exclusiveVC];
        exclusiveVC.sourceURLPrefix=prefixArray[i];
        exclusiveVC.currentIndex=i;
        exclusiveVC.loadCount=LoadCount;
    }
    
    JBExclusiveTableViewController *exclusiveVC = self.childViewControllers[0];
    [self.scrollView addSubview:exclusiveVC.view];
    exclusiveVC.view.frame=self.scrollView.bounds;
    
}

#pragma mark -发出通知
- (void)sentLoadNewJokesNotificationWithIndex:(NSInteger)index
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBLoadNewJokesKey] = [NSNumber numberWithInteger:index];
    [JBNotificationCenter postNotificationName:JBLoadNewJokesNotification object:nil userInfo:userInfo];
}

- (void)sentButtonSelectedNotificationWithIndex:(NSInteger)index
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBSelectButtonKey] = [NSNumber numberWithInteger:index];
    [JBNotificationCenter postNotificationName:JBButtonDidSelectNotification object:nil userInfo:userInfo];
}

- (void)sentTitleChangedNotificationWithIndex:(NSInteger)index
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBSelectTitleKey] = [NSNumber numberWithInteger:index];
    [JBNotificationCenter postNotificationName:JBTitleDidSelectNotification object:nil userInfo:userInfo];
}


#pragma mark -初始化导航栏按钮
- (void)setNav
{
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_review"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(groupMemberSelect)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.leftBarButtonItems =@[negativeSpacer,leftButtonItem];
    
    UIBarButtonItem* rightButtonItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nearby_group_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(nearbyGroupAdd)];
    self.navigationItem.rightBarButtonItems =@[negativeSpacer,rightButtonItem];
    
    self.navigationItem.titleView=self.titleContainerView;
}

- (void)nearbyGroupAdd
{
    
}

- (void)groupMemberSelect
{
    
}

#pragma mark - ******************** scrollView代理方法
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //JBLog(@"offsetX=%f,offsetY=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    // 获得索引
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    //JBLog(@"index=%ld,selectedIndex=%ld",index,self.selectedIndex);
    
    if(index==self.selectedIndex) return;
    
    self.selectedIndex=index;
    
    [self sentButtonSelectedNotificationWithIndex:index];
    [self sentTitleChangedNotificationWithIndex:index];
    
    JBExclusiveTableViewController *viewVC = self.childViewControllers[index];
    viewVC.view.frame=self.scrollView.bounds;
    if (viewVC.view.superview) return;
    
    [self.scrollView addSubview:viewVC.view];

}


#pragma mark - ******************** JBTopView代理方法
- (void)indexChanged:(NSInteger)index
{
    self.selectedIndex=index;
    CGPoint point=self.scrollView.contentOffset;
    self.scrollView.contentOffset=CGPointMake(index*ScreenWidth, point.y);
    
    JBExclusiveTableViewController *exclusiveVC = self.childViewControllers[index];
    exclusiveVC.view.frame=self.scrollView.bounds;
    if (!exclusiveVC.view.superview){
        [self.scrollView addSubview:exclusiveVC.view];
    }
    
}

@end
