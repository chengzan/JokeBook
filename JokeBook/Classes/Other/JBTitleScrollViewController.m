//
//  JBTitleScrollViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/5.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBTitleScrollViewController.h"
#import "JBConst.h"
#import "UIView+Extension.h"

@interface JBTitleScrollViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation JBTitleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view=[[[NSBundle mainBundle] loadNibNamed:@"JBTitleScrollViewController" owner:self options:nil] lastObject];
    
    [self setupScrollContent];
    
    // 按钮改变的通知
    [JBNotificationCenter addObserver:self selector:@selector(changeScrollIndex:) name:JBTitleDidSelectNotification object:nil];
    
    self.view.backgroundColor=[UIColor clearColor];
    
    //self.view.width=TitleScrollWidth*2;
    //self.view.height=TitleScrollWidth*0.5;
    self.scrollView.contentSize=CGSizeMake(TitleScrollWidth*2*ScrollCount, 0);
}

/**
 *  按钮被选中了
 */
- (void)changeScrollIndex:(NSNotification *)notification
{
    NSNumber *indexNumber = notification.userInfo[JBSelectTitleKey];
    
    //CGPoint point=self.scrollView.contentOffset;
    self.scrollView.contentOffset=CGPointMake(indexNumber.integerValue*2*TitleScrollWidth, 0);
    
    self.pageControl.currentPage=indexNumber.integerValue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupScrollContent
{
    NSArray *stringsArray=@[@"专享",@"视频",@"纯文",@"纯图",@"精华",@"最新"];
    
    
    for (NSInteger i=0;i<stringsArray.count;i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(2*TitleScrollWidth*i, -7, TitleScrollWidth*2, TitleScrollWidth*0.5)];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:14];
        [label setTextColor:[UIColor darkTextColor]];
        label.text=stringsArray[i];
        
        [self.scrollView addSubview:label];
    }
}

@end
