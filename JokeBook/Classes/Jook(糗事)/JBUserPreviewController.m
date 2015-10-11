//
//  JBUserPreviewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/6.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBUserPreviewController.h"
#import "JBConst.h"
#import "UIView+Extension.h"
#import "JBHttpTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "JBUserData.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "UIImage+MJ.h"
#import "JBUserArticlesViewController.h"
#import "JBTransition.h"

@interface JBUserPreviewController ()
@property (weak, nonatomic) IBOutlet UIButton *horoscopeButton; // 星座按钮
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView; // 背景
@property (weak, nonatomic) IBOutlet UIImageView *iconView; // 头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel; // 用户名
@property (weak, nonatomic) IBOutlet UIButton *sexButton; // 性别按钮
@property (weak, nonatomic) IBOutlet UIView *jokeView; // 里面放着下面两个按钮
@property (weak, nonatomic) IBOutlet UIButton *postButton; // 发送糗事按钮
@property (weak, nonatomic) IBOutlet UIButton *happyCountButton; // 糗事点赞按钮

@property (weak, nonatomic) IBOutlet UIButton *workButton; // 工作的地方
@property (weak, nonatomic) IBOutlet UIButton *ageButton; // 糗事年龄
@property (weak, nonatomic) IBOutlet UIButton *phoneButton; // 手机标识
@property (weak, nonatomic) IBOutlet UIButton *workTypeButton; // 工作的类型
@property (weak, nonatomic) IBOutlet UIButton *homeButton; // 家乡

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workPlaceWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ageWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jokeCountWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smileCountWidthCons;

@property (strong, nonatomic) UITapGestureRecognizer* tapRecognizer;

@property (strong,nonatomic) JBUserData *userData;
@end

@implementation JBUserPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupHoroscopeButton];
    [self addTapGesture];
}

- (void)addTapGesture
{
    // 单击的 Recognizer
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jokeViewTapGuesture)];
    self.tapRecognizer.numberOfTapsRequired = 1; // 单击
    [self.jokeView addGestureRecognizer:self.tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor=JBColor(150, 165, 252);
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)jokeViewTapGuesture
{
    if (self.userData.qs_cnt.integerValue == 0) return;
    
    UIStoryboard *userArticlesStoryBoard=[UIStoryboard storyboardWithName:@"UserArticles" bundle:nil];
    
    UINavigationController * navgationVC=userArticlesStoryBoard.instantiateInitialViewController;
    navgationVC.modalPresentationStyle = UIModalPresentationCustom;
    navgationVC.transitioningDelegate = [JBTransition sharedtransition];
    
    
    JBUserArticlesViewController *userArticlesVC=navgationVC.childViewControllers[0];
    
    
    if (self.userData.qs_cnt.integerValue < LoadCount) {
        userArticlesVC.loadCount=self.userData.qs_cnt.integerValue;
    }
    userArticlesVC.sourceURLPrefix=[NSString stringWithFormat:JBUserArticles,self.userID];
    
    
    [self presentViewController:navgationVC animated:YES completion:nil];
}

- (void)dealloc
{
    [self.jokeView removeGestureRecognizer:self.tapRecognizer];
}

- (void)setupHoroscopeButton
{
    [self.horoscopeButton.layer setMasksToBounds:YES];
    [self.horoscopeButton.layer setCornerRadius:2];//设置矩形四个圆角半径
    
    /*
     [btn.layer setBorderWidth:1.0];//边框宽度
     */
    
    NSArray * array=@[self.workButton,self.ageButton,self.phoneButton,self.workTypeButton,self.homeButton];
    for (UIButton* button in array) {
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:button.height*0.5];
        [button.layer setBorderWidth:2.0];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
    }

}

- (void)setupNav
{ 
    //navgationVC.navigationBar.barTintColor=JBColor(150, 165, 252);
    
    // 设置左边的返回按钮
    UIImage *image=[UIImage imageNamed:@"nearby_back_button"];
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
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUserID:(NSString *)userID
{
    _userID=userID;
    
    self.view.userInteractionEnabled =NO;
    // 2.发送请求
    NSString * url=[NSString stringWithFormat:JBUserDetailURL,userID];
    [JBHttpTool get:url params:nil success:^(id json) {

        //JBLog(@"userdata=%@",json[@"userdata"]);
        if (json[@"userdata"]) {
            
            //JBLog(@"userdata=%@",json[@"userdata"]);
            // 将 "用户信息字典字典" 转为 "糗事用户信息模型"
            self.userData=[JBUserData objectWithKeyValues:json[@"userdata"]];
            
            if (self.userData) {
                [self updateValues];
            }else {
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                [MBProgressHUD showError:@"您的网络不给力，请稍后再试" toView:window];
            }

        }else {
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [MBProgressHUD showError:@"您的网络不给力，请稍后再试" toView:window];
        }
        
        self.view.userInteractionEnabled =YES;
    } failure:^(NSError *error) {
        JBLog(@"请求失败-%@", error);
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [MBProgressHUD showError:@"您的网络不给力，请稍后再试" toView:window];

        self.view.userInteractionEnabled =YES;
    }];
}

- (void)updateValues
{
    self.view.userInteractionEnabled=NO;
    
    self.navigationItem.title=self.userData.login;
    UIImage *oldImage=[UIImage reSizeImage:[UIImage imageNamed:@"default_avatar"] toSize:CGSizeMake(44, 44)];
    UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor whiteColor]];
    [self.iconView setImage:newImage];
    
    [self updateSexValues];
    
    [self updateJokeViewValues];
    [self updateButtonValues];
    
    self.view.userInteractionEnabled=YES;
    
    [self setUserIcon];
    [self setBackgroundImage];
}

- (void)updateSexValues
{
    self.userNameLabel.text=self.userData.login;
    self.horoscopeButton.hidden=!self.userData.astrology.length;
    [self.horoscopeButton setTitle:self.userData.astrology forState:UIControlStateNormal];
    self.horoscopeButton.hidden=[self.userData.gender isEqualToString:@"U"];
    self.sexButton.hidden=!self.userData.gender.length || [self.userData.gender isEqualToString:@"U"];
    [self.sexButton setTitle:self.userData.age forState:UIControlStateNormal];
    
    if ([self.userData.gender isEqualToString:@"F"]) {
        self.horoscopeButton.backgroundColor=JBColor(225, 128, 194);
        [self.sexButton setBackgroundImage:[UIImage imageNamed:@"user_center_girl_with_rect"] forState:UIControlStateNormal];
    }else if ([self.userData.gender isEqualToString:@"M"]) {
        self.horoscopeButton.backgroundColor=JBColor(125, 170, 252);
        [self.sexButton setBackgroundImage:[UIImage imageNamed:@"user_center_boy_with_rect"] forState:UIControlStateNormal];
    }
}

- (void)setBackgroundImage
{
    UIImage *palceholderImage=[UIImage imageNamed:@"user_center_big_cover_default"];
    if (self.userData.big_cover.length == 0) {
        [self.backgroundImageView setImage:palceholderImage];
        return;
    }
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.userData.big_cover] placeholderImage:palceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            JBLog(@"下载背景图片失败 url=%@",imageURL.absoluteString);
            [self.backgroundImageView setImage:palceholderImage];
        }
    }];
}

- (void)setUserIcon
{
    NSUInteger len=4;
    (self.userID.length==7)?(len=3):(len);
    NSString *avtnewID = [self.userID substringWithRange:NSMakeRange(0, len)];
    NSString *newImageURL = [NSString stringWithFormat:avtNew, avtnewID, self.userID, self.userData.icon];
    
    //JBLog(@"self.userData.icon=%@",self.userData.icon);
    UIImage *oldImage=[UIImage reSizeImage:[UIImage imageNamed:@"default_avatar"] toSize:CGSizeMake(44, 44)];
    UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor whiteColor]];
    
    BOOL condition= !self.userData.icon.length;
    if (condition) return;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:newImageURL] placeholderImage:newImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            UIImage *oldImage=[UIImage reSizeImage:image toSize:CGSizeMake(44, 44)];
            UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor whiteColor]];
            
            [self.iconView setImage:newImage];
        }else
        {
            [self.iconView setImage:newImage];
            JBLog(@"下载头像失败 url=%@,user.icon=%@,avtnewID=%@,user.ID=%@",imageURL.absoluteString, self.userData.icon,avtnewID,self.userData.uid);
        }
    }];
}

- (void)updateJokeViewValues
{
    if (self.userData.qs_cnt.integerValue == 0 && self.userData.smile_cnt.integerValue == 0) {
        self.jokeView.hidden=YES;
    }else {
        self.jokeView.hidden=NO;
        
        NSString *strText=self.userData.qs_cnt;
        UIFont *font=[UIFont systemFontOfSize:12];
        if (self.userData.qs_cnt.integerValue > 999 && self.userData.qs_cnt.integerValue <= 9999) {
            strText=[NSString stringWithFormat:@"%ldK",self.userData.qs_cnt.integerValue/1000];
        }else if (self.userData.qs_cnt.integerValue > 9999){
            strText=[NSString stringWithFormat:@"%ldW",self.userData.qs_cnt.integerValue/10000];
        }
        
        [self.postButton setTitle:strText forState:UIControlStateNormal];
        self.jokeCountWidthCons.constant=[strText sizeWithFont:font].width+2*ButtonContentMargin+ButtonIconWidth;
        
        strText=self.userData.smile_cnt;
        if (self.userData.smile_cnt.integerValue > 999 && self.userData.smile_cnt.integerValue <= 9999) {
            strText=[NSString stringWithFormat:@"%ldK",self.userData.smile_cnt.integerValue/1000];
        }else if (self.userData.smile_cnt.integerValue > 9999){
            strText=[NSString stringWithFormat:@"%ldW",self.userData.smile_cnt.integerValue/10000];
        }
        
        [self.happyCountButton setTitle:strText forState:UIControlStateNormal];
        self.smileCountWidthCons.constant=[strText sizeWithFont:font].width+ButtonContentMargin+2*ButtonIconWidth+2*ButtonSpaceMargin;
    }
    
    //JBLog(@"qs_cnt=%@,smile_cnt=%@",self.userData.qs_cnt,self.userData.smile_cnt);

}

- (void)updateButtonValues
{
    self.phoneButton.hidden=!self.userData.mobile_brand.length;
    self.workButton.hidden=!self.userData.haunt.length;
    self.ageButton.hidden=!self.userData.age.integerValue;
    self.workTypeButton.hidden=!self.userData.job.length;
    self.homeButton.hidden=!self.userData.hometown.length;
    
    UIFont *font=[UIFont systemFontOfSize:13];
    
    if (self.userData.qb_age.integerValue) {
        NSString *ageStr;
        
        if (self.userData.qb_age.integerValue < 30) {
            ageStr=[NSString stringWithFormat:@"%@天",self.userData.qb_age];
        }else if(self.userData.qb_age.integerValue < 365) {
            ageStr=[NSString stringWithFormat:@"%ld月",self.userData.qb_age.integerValue/30];
        }else if(self.userData.qb_age.integerValue > 365) {
            ageStr=[NSString stringWithFormat:@"%ld年",self.userData.qb_age.integerValue/365];
        }
        
        [self.ageButton setTitle:ageStr forState:UIControlStateNormal];
        self.ageWidthCons.constant=[ageStr sizeWithFont:font].width+ButtonContentMargin+ButtonIconWidth+2*ButtonSpaceMargin;
    }
    
    if (self.userData.haunt.length) {
        [self.workButton setTitle:self.userData.haunt forState:UIControlStateNormal];
        self.workPlaceWidthCons.constant=[self.userData.haunt sizeWithFont:font].width+ButtonContentMargin+ButtonIconWidth+2*ButtonSpaceMargin;
    }
    
    if (self.userData.mobile_brand.length) {
        [self.phoneButton setTitle:self.userData.mobile_brand forState:UIControlStateNormal];
        self.phoneWidthCons.constant=[self.userData.mobile_brand sizeWithFont:font].width+ButtonContentMargin+ButtonIconWidth+2*ButtonSpaceMargin;
    }
    
    if (self.userData.job.length) {
        [self.workTypeButton setTitle:self.userData.job forState:UIControlStateNormal];
        self.jobWidthCons.constant=[self.userData.job sizeWithFont:font].width+ButtonContentMargin+ButtonIconWidth+2*ButtonSpaceMargin;
    }
    
    if (self.userData.hometown.length) {
        [self.homeButton setTitle:self.userData.hometown forState:UIControlStateNormal];
        self.homeWidthCons.constant=[self.userData.hometown sizeWithFont:font].width+ButtonContentMargin+ButtonIconWidth+2*ButtonSpaceMargin;
    }
}

@end
