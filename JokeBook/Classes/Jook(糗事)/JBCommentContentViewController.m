//
//  JBCommentContentViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/7.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBCommentContentViewController.h"
#import "JBConst.h"
#import "UIImage+MJ.h"
#import "UIView+Extension.h"
#import "JBCommentsFrame.h"
#import "JBComments.h"
#import "JBUsers.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@interface JBCommentContentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthCons;

@end

@implementation JBCommentContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view=[[[NSBundle mainBundle] loadNibNamed:@"JBCommentContentViewController" owner:self options:nil] lastObject];
    
    UIImage *oldImage=[UIImage reSizeImage:[UIImage imageNamed:@"default_avatar"] toSize:CGSizeMake(36, 36)];
    UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor whiteColor]];
    [self.userButton setBackgroundImage:newImage forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //JBLog(@"viewDidAppear");
    
    self.view.width=ScreenWidth;
    self.view.height=_commentsFrame.cellHeight;
    
}

- (void)setCommentsFrame:(JBCommentsFrame *)commentsFrame
{
    _commentsFrame=commentsFrame;
    
    JBComments *comments=commentsFrame.comments;
    JBUsers *user=comments.user;
    
    self.floorLabel.text=comments.floor;
    self.nameLabel.text=user.login;
    //self.contentLabel.text=comments.content;
    self.contentLabel.attributedText=comments.attributedContent;
    
    if (commentsFrame.contentHeight > 21) {
        self.contentLabelWidthCons.constant=CommentCellContentMaxWidth+ButtonContentMargin;
    }else {
        self.contentLabelWidthCons.constant=commentsFrame.contentWidth+ButtonContentMargin;
    }
    
    [self setUserIcon];
}

- (IBAction)replyButtonClicked:(id)sender {
    UIButton *button=sender;

    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point=[self.view convertPoint:CGPointMake(button.x, button.centerY) toView:window];
    NSValue *value=[NSValue valueWithCGPoint:point];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBShowReplyViewKey] = value;
    userInfo[JBJokeReplyViewReplyKey]=self.commentsFrame.comments;
    [JBNotificationCenter postNotificationName:JBShowReplyViewNotification object:nil userInfo:userInfo];
}

- (IBAction)userButtonClicked:(id)sender {
    JBUsers *user=self.commentsFrame.comments.user;
    if(user == nil || user.ID.length == 0 ) return;

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[JBCommentCellIconKey] = user.ID;
    [JBNotificationCenter postNotificationName:JBCommentCellIconClickedNotification object:nil userInfo:userInfo];
}

- (void)setUserIcon
{
    JBComments *comments=self.commentsFrame.comments;
    JBUsers *user=comments.user;
    
    NSUInteger len;
    //(user.ID.length==7)?(len=3):(len);
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
    
    //JBLog(@"self.userData.icon=%@",self.userData.icon);
    UIImage *oldImage=[UIImage reSizeImage:[UIImage imageNamed:@"default_avatar"] toSize:CGSizeMake(36, 36)];
    UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor orangeColor]];
    
    BOOL condition= !user.icon.length;
    if (condition) return;
    
    [self.userButton.imageView sd_setImageWithURL:[NSURL URLWithString:newImageURL] placeholderImage:newImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            UIImage *oldImage=[UIImage reSizeImage:image toSize:CGSizeMake(44, 44)];
            UIImage *newImage=[UIImage circleImageWithImage:oldImage borderWidth:2 borderColor:[UIColor orangeColor]];
            
            [self.userButton setBackgroundImage:newImage forState:UIControlStateNormal];
        }else
        {
            [self.userButton setBackgroundImage:newImage forState:UIControlStateNormal];
            JBLog(@"下载头像失败 url=%@,user.icon=%@,avtnewID=%@,user.ID=%@",imageURL.absoluteString, user.icon,avtnewID,user.ID);
        }
    }];
}


@end
