//
//  JBCommentViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBCommentViewController.h"
#import "JBJokesFrame.h"
#import "JBJokes.h"
#import "JBExclusiveTableViewCellContentViewController.h"
#import "JBHttpTool.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "JBConst.h"
#import "MBProgressHUD+MJ.h"
#import "JBComments.h"
#import "JBCommentsFrame.h"
#import "JBCommentTableViewCell.h"
#import "UIView+Extension.h"
#import "JBTransition.h"
#import "JBUserPreviewController.h"
#import "JBReplyViewController.h"
#import "JBCoverView.h"
#import "JBTextView.h"

@interface JBCommentViewController ()<UIScrollViewDelegate>
@property (nonatomic,copy) NSString *sourceURLPrefix;
@property (nonatomic,assign) NSInteger pageIndex;

/** 评论数组（里面放的都是JBComments模型，一个JBComments对象就代表一条评论）*/
@property (nonatomic, strong) NSMutableArray *commentsFrame;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomCons;


@property (weak, nonatomic) IBOutlet JBTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (strong,nonatomic) JBCoverView *coverView;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation JBCommentViewController

- (NSMutableArray *)commentsFrame
{
    if (!_commentsFrame) {
        _commentsFrame = [NSMutableArray array];
    }
    return _commentsFrame;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView=self.view.subviews[0];
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupUpRefresh];
    [self setupDownRefresh];
    [self setupTextView];
    
    [self addObserver];
}

-(void)addObserver
{
    // 监听用户头像被点击的通知
    [JBNotificationCenter addObserver:self selector:@selector(commentCellIconClickedNotification:) name:JBCommentCellIconClickedNotification object:nil];
    
    // 监听回复按钮被点击的通知
    [JBNotificationCenter addObserver:self selector:@selector(replyButtonClickedNotification:) name:JBShowReplyViewNotification object:nil];
    
    // 监听键盘
    //[JBNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //[JBNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [JBNotificationCenter addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [JBNotificationCenter addObserver:self selector:@selector(replyFloor:) name:JBJokeReplyViewReplyClickedNotification object:nil];
}

-(void)setupTextView
{
    self.inputTextView.backgroundColor=[UIColor whiteColor];
    self.inputTextView.layer.borderColor = [JBColor(198, 198, 203)CGColor];
    self.inputTextView.layer.borderWidth = 1.0;
    self.inputTextView.layer.cornerRadius = 5;
    [self.inputTextView.layer setMasksToBounds:YES];
    
    self.inputTextView.placeholder=@"说点什么吧...";
    self.inputTextView.placeholderColor=[UIColor lightGrayColor];
}

-(void)keyboardWillChange:(NSNotification *)noti
{
    //JBLog(@"%@",noti);
    // 获取键盘的高度
    CGRect keyBoardEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval time = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //JBLog(@"self.inputView.y=%f",self.inputView.y);
    [UIView animateWithDuration:time animations:^{
        self.inputView.y = keyBoardEndFrame.origin.y-self.inputView.height;
    }];
    
    if (keyBoardEndFrame.origin.y==ScreenHeight) {
        self.inputViewBottomCons.constant = 0;
    }else {
        self.inputViewBottomCons.constant = keyBoardEndFrame.size.height;
    }
    
    //JBLog(@"self.inputView.y=%f,self.inputViewBottomCons.constant=%f",self.inputView.y,self.inputViewBottomCons.constant);
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    //JBLog(@"%@",noti);
    // 获取键盘的高度
    CGRect keyBoardEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval time = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:time animations:^{
        self.inputViewBottomCons.constant = keyBoardEndFrame.size.height;
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    
    NSTimeInterval time = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        //距离底部的约束永远为0
        self.inputViewBottomCons.constant = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor=JBColor(245, 245, 245);
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                  NSForegroundColorAttributeName:[UIColor blackColor]};
    
    
#warning-   // 给tableview添加headerView的时候一定要先创建uiview，再把uiview赋值给headerView
    JBExclusiveTableViewCellContentViewController *contentVC=self.childViewControllers[0];
    contentVC.tableHeader=YES;
    contentVC.jokesFrame=self.jokesFrame;
    UIView * view=[[UIView alloc] initWithFrame:contentVC.view.frame];
    [view addSubview:contentVC.view];
    
    self.tableView.tableHeaderView=view;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) replyFloor:(NSNotification *)notification
{
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
    }
    
    JBComments *comments = notification.userInfo[JBJokeReplyViewReplyKey];
    if (self.inputTextView.isFirstResponder) {
        self.inputViewHeightCons.constant=55;
    }else {
        [self.inputTextView becomeFirstResponder];
    }
    
    self.inputViewHeightCons.constant=55;
    self.inputTextView.text=[NSString stringWithFormat:@"回复 %@楼：",comments.floor];
}

- (void) replyButtonClickedNotification:(NSNotification *)notification
{
    NSValue *pointValue = notification.userInfo[JBShowReplyViewKey];
    JBComments *comments=notification.userInfo[JBJokeReplyViewReplyKey];
    JBReplyViewController *replyVC=[[JBReplyViewController alloc] init];
    replyVC.comments=comments;
    self.coverView=[JBCoverView coverView];
    self.coverView.contentController=replyVC;
    [self.coverView setContentControllerViewOrigin:pointValue.CGPointValue];
}

- (IBAction)commentClicked:(id)sender {
    [self.inputTextView endEditing:YES];
    self.inputTextView.text=nil;
}


- (void) commentCellIconClickedNotification:(NSNotification *)notification
{
   NSString *userID = notification.userInfo[JBCommentCellIconKey];
    UIStoryboard *UserPreviewStoryBoard=[UIStoryboard storyboardWithName:@"UserPreview" bundle:nil];
    
    JBUserPreviewController *userPreviewVC=UserPreviewStoryBoard.instantiateInitialViewController;
    userPreviewVC.userID=userID;
    
    [self.navigationController pushViewController:userPreviewVC animated:YES];

}

/**
 *  集成上拉刷新控件
 */
- (void)setupUpRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreComments)];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewComments)];
}

- (void)setupNav
{
    // 设置左边的返回按钮
    UIImage *image=[UIImage imageNamed:@"icon_back"];
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem =leftBarItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setJokesFrame:(JBJokesFrame *)jokesFrame
{
    self.sourceURLPrefix=JBJokesArticleComment;
    
    JBExclusiveTableViewCellContentViewController *contentVC=[[JBExclusiveTableViewCellContentViewController alloc] init];
    [self addChildViewController:contentVC];
    _jokesFrame=jokesFrame;
    
    contentVC.view.height=jokesFrame.cellHeight;
    
    self.navigationItem.title=[NSString stringWithFormat:@"糗事%@",jokesFrame.jokes.ID];
    
    self.tableView.sectionHeaderHeight=jokesFrame.cellHeight;
    self.sourceURLPrefix=[NSString stringWithFormat:_sourceURLPrefix,jokesFrame.jokes.ID];
    // 2.进入刷新状态
    [self.tableView headerBeginRefreshing];
}

- (void)loadMoreComments
{
    self.tableView.userInteractionEnabled =NO;
    // 2.发送请求
    NSString * url=[NSString stringWithFormat:@"%@count=%d&page=%ld",self.sourceURLPrefix,LoadCount,++self.pageIndex];
    [JBHttpTool get:url params:nil success:^(id json) {
        //JBLog(@"Jokes=%@",json);
        NSNumber *errNumber=json[@"err"];
        if (errNumber.integerValue) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误信息：%@",json[@"err_msg"]] toView:window];
        }
        
        NSNumber *itemsCount=json[@"count"];
        if (itemsCount.integerValue-1) {
            
            // 将 "糗事字典"数组 转为 "糗事模型"数组
            NSArray *newItems = [JBComments objectArrayWithKeyValuesArray:json[@"items"]];
            //JBLog(@"JBComments=%@",json);
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"为您刷新了%@条数据",[NSString stringWithFormat:@"%ld",newItems.count]] toView:window];

            NSArray *newFrames = [self commentsFramesWithComments:newItems];
            // 将更多的微博数据，添加到总数组的最后面
            [self.commentsFrame addObjectsFromArray:newFrames];
            //JBLog(@"commentsFrame=%@",self.commentsFrame);
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
- (NSArray *)commentsFramesWithComments:(NSArray *)comments
{
    NSMutableArray *frames = [NSMutableArray array];
    for (JBComments *comment in comments) {
        JBCommentsFrame *f = [[JBCommentsFrame alloc] init];
        f.comments = comment;
        [frames addObject:f];
    }
    return frames;
}


- (void)loadNewComments
{
    self.tableView.userInteractionEnabled =NO;
    // 2.发送请求
    NSString *url=[NSString stringWithFormat:@"%@count=%d&page=1",self.sourceURLPrefix,LoadCount];
    [JBHttpTool get:url params:nil success:^(id json) {
        //JBLog(@"Jokes=%@",json);
        NSNumber *errNumber=json[@"err"];
        if (errNumber.integerValue) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误信息：%@",json[@"err_msg"]] toView:window];
        }
        
        NSNumber *itemsCount=json[@"count"];
        if (itemsCount.integerValue-1) {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            
            // 将 "糗事字典"数组 转为 "糗事模型"数组
            NSArray *newItems = [JBComments objectArrayWithKeyValuesArray:json[@"items"]];
            
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"为您刷新了%@条数据",[NSString stringWithFormat:@"%ld",newItems.count]] toView:window];
            //JBLog(@"Jokes=%@",json[@"items"]);

            // 将 newItems数组 转为 JBJokesFrame数组
            NSArray *newFrames = [self commentsFramesWithComments:newItems];
            //JBLog(@"newFrames=%@",newFrames);
            // 将最新的微博数据，添加到总数组的最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.commentsFrame insertObjects:newFrames atIndexes:set];
            //JBLog(@"commentsFrame=%@",self.commentsFrame);
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
    return self.commentsFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    JBCommentTableViewCell *cell = [JBCommentTableViewCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    //JBLog(@"jokesFrame=%@",self.jokesFrames[indexPath.row]);
    cell.commentsFrame = self.commentsFrame[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBCommentsFrame *frame=self.commentsFrame[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.inputTextView.isFirstResponder) {
        [self.inputTextView endEditing:YES];
    }else {
        [self.inputTextView becomeFirstResponder];
        self.countLabelHeightCons.constant=0;
        self.countLabel.text=nil;
        self.commentButton.enabled=YES;
        self.inputViewHeightCons.constant=55;
        
        JBCommentsFrame *commentsFrame=self.commentsFrame[indexPath.row];
        JBComments *comments=commentsFrame.comments;
        self.inputTextView.text=[NSString stringWithFormat:@"回复 %@楼：",comments.floor];
    }
}

#pragma mark - ******************** scrollView代理方法
/** 开始拖拽视图 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputTextView endEditing:YES];
}

#pragma mark - ******************** textView代理方法
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat textHeight=textView.contentSize.height;
    if (textHeight <= 36) {
        self.inputViewHeightCons.constant=55;
    }else if (textHeight > 36 && textHeight < 95) {
        self.inputViewHeightCons.constant=textHeight+20;
    }else {
        //JBLog(@"textView.text.length=%ld",textView.text.length);
    }
    
    if (textView.text.length > 200) {
        self.countLabel.text=[NSString stringWithFormat:@"-%ld",textView.text.length - 200];
        self.countLabelHeightCons.constant=21;
        self.commentButton.enabled=NO;
    }else {
        self.countLabelHeightCons.constant=0;
        self.countLabel.text=nil;
        self.commentButton.enabled=YES;
    }
    //JBLog(@"textView=%@",textView);
}
@end
