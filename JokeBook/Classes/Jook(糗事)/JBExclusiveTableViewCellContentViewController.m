//
//  JBExclusiveTableViewCellContentViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBExclusiveTableViewCellContentViewController.h"
#import "UIView+Extension.h"
#include "JBJokesFrame.h"
#import "JBJokes.h"
#import "JBUsers.h"
#import "JBVotes.h"
#import "JBConst.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MJ.h"
#import "JBUserPreviewController.h"
#import "JBTransition.h"
#import "NSString+Extension.h"
#import "PhotoBroswerVC.h"
#import "ALMoviePlayerController.h"
#import "UIView+AutoLayout.h"

@interface JBExclusiveTableViewCellContentViewController()<ALMoviePlayerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uesrButton;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *laughLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCons; // 文字的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countAndImageCons; // 点赞数字与中间图片之间的间隙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userButtonWidthCons; // 头像按钮的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeightCons; //容纳图片或者视频播放器的高度

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *playView;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeText;
@property (strong,nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong,nonatomic) UITapGestureRecognizer *movieViewTap;
@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;//视频播放器
@property (nonatomic, assign) BOOL playBegin;
@end

@implementation JBExclusiveTableViewCellContentViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view=[[[NSBundle mainBundle] loadNibNamed:@"JBExclusiveTableViewCellContentView" owner:self options:nil] lastObject];

    [self setUpImageView];
    [self setUpImageBlock];
    
    [self addTapRecognizerForPlayView];
    [self containViewAddMovieView];
    
    [JBNotificationCenter addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)addTapRecognizerForPlayView
{
    //添加手势
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPlayView:)];
    [self.playView addGestureRecognizer:tapRecognizer];
    
    //JBLog(@"self.playView.gestureRecognizers=%@",self.playView.gestureRecognizers);
}



- (ALMoviePlayerController *)moviePlayer
{
    if (_moviePlayer == nil) {
        _moviePlayer = [[ALMoviePlayerController alloc] init];
        _moviePlayer.view.alpha = 1;
        //_moviePlayer.delegate = self;
        
        //create the controls
        ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:_moviePlayer style:ALMoviePlayerControlsStyleNone];
        //[movieControls setAdjustsFullscreenImage:NO];
        //[movieControls setBarColor:[UIColor colorWithRed:195/255.0 green:29/255.0 blue:29/255.0 alpha:0.5]];
        //[movieControls setTimeRemainingDecrements:YES];
        //[movieControls setFadeDelay:2.0];
        //[movieControls setBarHeight:100.f];
        //[movieControls setSeekRate:2.f];
        
        _moviePlayer.repeatMode=MPMovieRepeatModeNone;
        _moviePlayer.scalingMode=MPMovieScalingModeFill;
        _moviePlayer.shouldAutoplay=NO;
        //_moviePlayer.controlStyle=ALMoviePlayerControlsStyleDefault;
        
        //assign controls
        [_moviePlayer setControls:movieControls];
        //[movieControls autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_moviePlayer.view];
        //[movieControls autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_moviePlayer.view];
        //[movieControls autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_moviePlayer.view];
        _moviePlayer.controls.hidden=YES;
        
         self.movieViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movieTapAction:)];
    }
    
    return _moviePlayer;
}

- (void)containViewAddMovieView
{
    [self.containView insertSubview:self.moviePlayer.view belowSubview:self.contentImageView];
    //[self.moviePlayer.view autoCenterInSuperview];
    [self.moviePlayer.view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containView];
    [self.moviePlayer.view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containView];
    [self.moviePlayer.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containView];
    [self.moviePlayer.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containView];
    
}

#pragma mark // ALMoviePlayerController 的 delegate方法
- (void)moviePlayerWillMoveFromWindow {
    //movie player must be readded to this view upon exiting fullscreen mode.
    //if (![self.containView.subviews containsObject:self.moviePlayer.view])
        //[self.containView addSubview:self.moviePlayer.view];
    
    //_moviePlayer.scalingMode=MPMovieScalingModeFill;
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    //[self.moviePlayer setFrame:self.containView.bounds];
}

- (void)setUpImageView
{
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 超出边框的内容都剪掉
    self.contentImageView.clipsToBounds = YES;
}

- (void)setTableHeader:(BOOL)tableHeader
{
    _tableHeader=tableHeader;
    //开启事件
    self.contentImageView.userInteractionEnabled = YES;
    self.contentImageView.tag=0;
    
    //添加手势
    self.tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)];
    [self.contentImageView addGestureRecognizer:self.tapRecognizer];
}

- (void)setUpImageBlock
{
    __weak typeof(self) weakSelf=self;
    self.ClickImageBlock= ^(NSUInteger index){
        [PhotoBroswerVC show:weakSelf type:PhotoBroswerVCTypePush index:index photoModelBlock:^NSArray *{
            JBJokes *jokes=weakSelf.jokesFrame.jokes;
       
            NSArray *networkImages=@[jokes.imageAbsolutelyURL];
            
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
            for (NSUInteger i = 0; i< networkImages.count; i++) {
                
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = i + 1;
                pbModel.title = nil;
                pbModel.desc = nil;
                pbModel.image_HD_U = networkImages[i];
                
                //源frame
                UIImageView *imageV =(UIImageView *) weakSelf.contentImageView;
                pbModel.sourceImageView = imageV;
                
                [modelsM addObject:pbModel];
            }
            
            return modelsM;
        }];
    };
}

-(void)touchImage:(UITapGestureRecognizer *)tap{
    if(self.ClickImageBlock != nil) self.ClickImageBlock(tap.view.tag);
}


- (void)dealloc
{
    if (self.isTableHeader) {
        [self.contentImageView removeGestureRecognizer:self.tapRecognizer];
    }
    
    [JBNotificationCenter removeObserver:self];
    [self.playView removeGestureRecognizer:self.playView.gestureRecognizers.lastObject];
}

- (IBAction)userButtonClicked:(id)sender {
    
    JBUsers *user=self.jokesFrame.jokes.user;
    if(user == nil || user.ID.length == 0 ) return;
    
    if (self.navigationController==nil) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[JBJokeCellIconKey] = user.ID;
        [JBNotificationCenter postNotificationName:JBJokeCellIconClickedNotification object:nil userInfo:userInfo];
        return;
    }
    
    UIStoryboard *UserPreviewStoryBoard=[UIStoryboard storyboardWithName:@"UserPreview" bundle:nil];
    
    //UINavigationController * navgationVC=UserPreviewStoryBoard.instantiateInitialViewController;
    //navgationVC.modalPresentationStyle = UIModalPresentationCustom;
    //navgationVC.transitioningDelegate = [JBTransition sharedtransition];
    
    
    //JBUserPreviewController *userPreviewVC=navgationVC.childViewControllers[0];
    JBUserPreviewController *userPreviewVC=UserPreviewStoryBoard.instantiateInitialViewController;
    userPreviewVC.userID=user.ID;
    //JBLog(@"self.navigationController=%@",self.navigationController);
    [self.navigationController pushViewController:userPreviewVC animated:YES];
    
    
//    if (self.isPresenting) {
//        [self presentViewController:navgationVC animated:YES completion:nil];
//    }else {
//        [self.view.window.rootViewController presentViewController:navgationVC animated:YES completion:nil];
//    }
    
}

- (IBAction)upButtonClicked:(id)sender {
    self.downButton.selected=NO;
    self.upButton.selected=YES;
    
    self.jokesFrame.upSelected=YES;
    self.jokesFrame.downSelected=NO;
    
    [self updateLaughLabelTextWithCount:1];
}

- (void)updateLaughLabelTextWithCount:(NSInteger)count
{
    JBJokes *jokes=self.jokesFrame.jokes;
    JBVotes *votes=jokes.votes;
    NSInteger upCount=votes.up.longValue+count;
    NSInteger downCount=votes.down.longValue+count;
    votes.up=[NSNumber numberWithInteger:upCount];
    votes.down=[NSNumber numberWithInteger:downCount];
    
    self.laughLabel.text=[NSString stringWithFormat:@"好笑 %ld",upCount+downCount];
}

- (IBAction)downButtonClicked:(id)sender {
    self.downButton.selected=YES;
    self.upButton.selected=NO;
    
    self.jokesFrame.upSelected=NO;
    self.jokesFrame.downSelected=YES;
    
    [self updateLaughLabelTextWithCount:-1];
}

- (IBAction)commentButtonClicked:(id)sender {
    
}

- (IBAction)shareButtonClicked:(id)sender {
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    JBLog(@"viewWillAppear");
//}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.jokesFrame.jokes.loop.length) {
        
        [self.moviePlayer stop];
        self.playView.hidden=NO;
    }
    //JBLog(@"viewWillDisappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //JBLog(@"viewDidAppear");
    
    self.view.width=ScreenWidth;
    self.view.height=_jokesFrame.cellHeight;
}

- (void)movieTapAction:(UITapGestureRecognizer *)tap{
    //JBLog(@"movieTapAction");
    
    [self.moviePlayer pause];
    self.playView.hidden=NO;
    //self.playBegin=NO;
}

-(void)touchPlayView:(UITapGestureRecognizer *)tap{
    //JBLog(@"tap.view=%@",tap.view);
}

- (IBAction)playButtonClicked:(id)sender {
//    if (![self.moviePlayer.contentURL.absoluteString isEqualToString:self.jokesFrame.jokes.high_url]) {
//        [self.moviePlayer setContentURL:[NSURL URLWithString:self.jokesFrame.jokes.high_url]];
//        [self.moviePlayer prepareToPlay];
//    }
    //self.playBegin=YES;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.jokesFrame.jokes.imageAbsolutelyURL] placeholderImage:[UIImage imageNamed:@"im_img_placeholder"]];
    [self.moviePlayer play];
    self.playView.hidden=YES;
    self.contentImageView.hidden=YES;
    //JBLog(@"view=%@",self.containView.subviews[1]);
    //if (self.containView.subviews[1] == self.contentImageView) {
        //[self.containView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    //}
}

- (void)movieFinished
{
    //JBLog(@"notification.userInfo=%@",notification.userInfo);
    //JBLog(@"self.playBegin=%d",self.playBegin);
    
    //JBLog(@"movieFinished");
    //if (self.playBegin) {
        
//        self.playBegin=NO;
//        JBLog(@"movieFinished--1");
//        [self.moviePlayer prepareToPlay];
//        [self.containView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//        self.playView.hidden=NO;
    //}
    
    if (self.jokesFrame.jokes.loop.length) {
        //self.playBegin=NO;
        //JBLog(@"movieFinished--1");
        //[self.moviePlayer prepareToPlay];
        //[self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.jokesFrame.jokes.imageAbsolutelyURL] placeholderImage:[UIImage imageNamed:@"im_img_placeholder"]];
        
        //self.playView.hidden=YES;
        //if(self.containView.subviews[1] != self.contentImageView)
        //[self.containView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        [self.moviePlayer stop];
        self.playView.hidden=NO;
        self.contentImageView.hidden=NO;
    }
    
}

- (void)setContainImageOrVideo
{
    
    //JBLog(@"self.moviePlayer=%@",self.moviePlayer);
    JBJokes *jokes=self.jokesFrame.jokes;
    //[self.moviePlayer stop];
    //JBLog(@"setContainImageOrVideo--1");
    //self.playBegin=NO;
    if (self.jokesFrame.imageHeight) {
        self.containViewHeightCons.constant=self.jokesFrame.imageHeight;
        self.countAndImageCons.constant=CellMargin;
        
        
        //self.playView.hidden=YES;
        //if (self.containView.subviews[1] != self.contentImageView) {
            //[self.containView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        //}
        
        if (jokes.loop.length) {
            self.playView.hidden=NO;
            //[self containViewAddMovieView];
            //self.contentImageView.height=0;
            //self.contentImageView.hidden=YES;
            self.moviePlayer.view.hidden=NO;
            self.moviePlayer.view.height=self.jokesFrame.imageHeight;
            
            [self.moviePlayer setContentURL:[NSURL URLWithString:self.jokesFrame.jokes.high_url]];
//             JBLog(@"setContainImageOrVideo--2");
            //[self.moviePlayer prepareToPlay];
//             JBLog(@"setContainImageOrVideo--3");
            
            
            //JBLog(@"self.moviePlayer.view.subviews=%@",self.moviePlayer.view.subviews);
            
            UIView *subView = self.moviePlayer.view.subviews[0];
            if (![subView.gestureRecognizers containsObject:self.movieViewTap]) {
                [subView addGestureRecognizer:self.movieViewTap];
            }
            
            jokes.imageAbsolutelyURL=jokes.pic_url;
            [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:jokes.imageAbsolutelyURL] placeholderImage:[UIImage imageNamed:@"im_img_placeholder"]];
            self.contentImageView.hidden=NO;
            
            [self movieFinished];
        }else{

            UIView *subView = self.moviePlayer.view.subviews[0];
            if ([subView.gestureRecognizers containsObject:self.movieViewTap])
            [subView removeGestureRecognizer:self.movieViewTap];
            self.playView.hidden=YES;
            self.moviePlayer.view.hidden=YES;
            //if (self.moviePlayer.view.superview) [self.moviePlayer.view removeFromSuperview];
            self.moviePlayer.view.height=0;
            
            //self.contentImageView.hidden=NO;
            //self.contentImageView.height=self.jokesFrame.imageHeight;
            
            NSString *midImageStr = [jokes.ID substringWithRange:NSMakeRange(0, 5)];
            jokes.imageAbsolutelyURL = [NSString stringWithFormat:picturesNew, midImageStr, jokes.ID,jokes.image];
            
            [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:jokes.imageAbsolutelyURL] placeholderImage:[UIImage imageNamed:@"im_img_placeholder"]];
            self.contentImageView.hidden=NO;
        }
        
        
        self.contentImageView.height=self.jokesFrame.imageHeight;
        
        
        
        //JBLog(@"imageURL=%@",newImageMidURL);
    }
    else{
        
        UIView *subView = self.moviePlayer.view.subviews[0];
        if ([subView.gestureRecognizers containsObject:self.movieViewTap])
        [subView removeGestureRecognizer:self.movieViewTap];
        
        //if (self.moviePlayer.view.superview) [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer.view.height=0;
        self.moviePlayer.view.hidden=YES;
        self.playView.hidden=YES;
        
        self.contentImageView.hidden=YES;
        self.containViewHeightCons.constant=0;
        self.countAndImageCons.constant=0;
        self.contentImageView.height=0;
    }
    
    //JBLog(@"self.moviePlayer.view.superview=%@",self.moviePlayer.view.superview);
    //JBLog(@"self.moviePlayer.view.subviews=%@",self.moviePlayer.view.subviews);
}



- (void)setJokesFrame:(JBJokesFrame *)jokesFrame
{
    _jokesFrame=jokesFrame;
    [self setContainImageOrVideo];

    self.downButton.selected=self.jokesFrame.downSelected;
    self.upButton.selected=jokesFrame.upSelected;
    
    JBJokes *jokes=jokesFrame.jokes;
    self.contentLabel.text=jokes.content;

    
    self.contentHeightCons.constant=0;
    if (self.contentLabel.text.length) {
        self.contentHeightCons.constant=jokesFrame.textHeight;
    }
    
    self.typeIcon.hidden=NO;
    self.typeText.hidden=NO;
    if ([jokes.type  isEqualToString:@"fresh"]) {
        self.typeText.text=@"新鲜";
        self.typeIcon.image=[UIImage imageNamed:@"subscribe_follow"];
    }else if ([jokes.type  isEqualToString:@"hot"]) {
        self.typeText.text=@"热门";
        self.typeIcon.image=[UIImage imageNamed:@"subscribe_hot"];
    }else {
        self.typeIcon.hidden=YES;
        self.typeText.hidden=YES;
    }

    [self setUserIconWithJokes:jokes];
    
    
    JBUsers *user=jokes.user;
    JBVotes *vote=jokes.votes;
    
    UIFont *font=[UIFont systemFontOfSize:14];
    NSString *userNameStr;
    if (!user.login.length) {
        userNameStr=@"匿名用户";
        [self.uesrButton setTitle:userNameStr forState:UIControlStateNormal];
        [self.uesrButton setTitle:userNameStr forState:UIControlStateHighlighted];
    }else{
        userNameStr=user.login;
        [self.uesrButton setTitle:userNameStr forState:UIControlStateNormal];
        [self.uesrButton setTitle:userNameStr forState:UIControlStateHighlighted];
    }
    
    self.userButtonWidthCons.constant=[userNameStr sizeWithFont:font].width+CellMargin+UserIconHeight;
    
    //JBLog(@"user.login.length=%ld----",user.login.length);
    
    if (!user.login.length) {
        [self.uesrButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.uesrButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }else{
        [self.uesrButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.uesrButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    }
    
    NSString * string=[[[NSNumberFormatter alloc] init] stringFromNumber:jokes.share_count];
    self.shareLabel.text=[NSString stringWithFormat:@"分享 %@",string];
    string=[[[NSNumberFormatter alloc] init] stringFromNumber:jokes.comments_count];
    self.commentLabel.text=[NSString stringWithFormat:@"评论 %@",string];
    
    NSInteger laughValue=vote.up.longValue+vote.down.longValue;
    self.laughLabel.text=[NSString stringWithFormat:@"好笑 %ld",laughValue];
}

- (void)setUserIconWithJokes:(JBJokes *)jokes
{
    JBUsers *user=jokes.user;
    
    NSUInteger len;
    if (user.ID.length == 6) {
        len=2;
    }else if(user.ID.length == 7) {
        len=3;
    }else if(user.ID.length == 8) {
        len=4;
    }else {
        len=5;
    }

    
    NSString *avtnewID = [user.ID substringWithRange:NSMakeRange(0, len)];
    NSString *newImageURL = [NSString stringWithFormat:avtNew, avtnewID, user.ID, user.icon];
    
    //JBLog(@"user.icon=%@",user.icon);
    UIImage *oldImage=[UIImage reSizeImage:[UIImage imageNamed:@"default_avatar"] toSize:CGSizeMake(34, 34)];
    UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor orangeColor]];
    [self.uesrButton setImage:newImage forState:UIControlStateNormal];
    [self.uesrButton setImage:newImage forState:UIControlStateHighlighted];
    
    BOOL condition= !user.icon.length || !user.ID.length || [user.icon isEqualToString:@"(null)"];
    if (condition) return;
    
    [self.uesrButton.imageView sd_setImageWithURL:[NSURL URLWithString:newImageURL] placeholderImage:newImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            UIImage *oldImage=[UIImage reSizeImage:image toSize:CGSizeMake(34, 34)];
            UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor orangeColor]];
            
            [self.uesrButton setImage:newImage forState:UIControlStateNormal];
            [self.uesrButton setImage:newImage forState:UIControlStateHighlighted];
        }else
        {
            [self.uesrButton setImage:newImage forState:UIControlStateNormal];
            [self.uesrButton setImage:newImage forState:UIControlStateHighlighted];
            JBLog(@"下载头像失败 url=%@,user.icon=%@,avtnewID=%@,user.ID=%@",imageURL.absoluteString, user.icon,avtnewID,user.ID);
        }
    }];
}

@end
