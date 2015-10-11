//
//  JBTopViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/2.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBTopViewController.h"
#import "UIView+Extension.h"
#import "JBConst.h"

@interface JBTopViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftSpaceCons;
@property (strong,nonatomic) UIButton * selectedButton;

@end

@implementation JBTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelWidthCons.constant=ScreenWidth/ScrollCount;
    [self addButton];
    
    // 按钮改变的通知
    [JBNotificationCenter addObserver:self selector:@selector(changeButtonIndex:) name:JBButtonDidSelectNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  按钮被选中了
 */
- (void)changeButtonIndex:(NSNotification *)notification
{
    NSNumber *tagNumber = notification.userInfo[JBSelectButtonKey];
    
    UIButton * button=[self.view subviews][tagNumber.intValue+1];
    [self changedSelectedButton:button];
}

- (void)addButton
{
    NSArray *array=@[@"专享",@"视频",@"纯文",@"纯图",@"精华",@"最新"];
    
    CGFloat w=ScreenWidth/ScrollCount;
    for (int i= 0; i<ScrollCount; i++) {
        UIButton *btn=[[UIButton alloc] init];
        btn.tag=i;
        btn.width=w;
        btn.height=TopViewHeight;
        btn.x=i*w;
        btn.y=0;
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(buttomClicked:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
    }
    
    UIButton *btn=[self.view subviews][1];
    [self buttomClicked:btn];
    
}

- (void)changedSelectedButton:(UIButton *)button
{
    self.selectedButton.selected=NO;
    self.selectedButton=button;
    button.selected=YES;
    
    [self indicatorViewChangedIndex:button.tag];
}

- (void)sentTitleChangedNotificationWithIndex:(NSInteger)index
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBSelectTitleKey] = [NSNumber numberWithInteger:index];
    [JBNotificationCenter postNotificationName:JBTitleDidSelectNotification object:nil userInfo:userInfo];
}

- (void)buttomClicked:(UIButton *)button
{
    if(button==self.selectedButton) return;
    
    [self sentTitleChangedNotificationWithIndex:button.tag];
    [self changedSelectedButton:button];
    
    if ([self.delegate respondsToSelector:@selector(indexChanged:)]) {
        [self.delegate indexChanged:button.tag];
    }
}

- (void)indicatorViewChangedIndex:(NSInteger)index
{
    if (self.labelLeftSpaceCons.constant == self.labelWidthCons.constant*index) return;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.labelLeftSpaceCons.constant=index*self.labelWidthCons.constant;
    }];
}

@end
