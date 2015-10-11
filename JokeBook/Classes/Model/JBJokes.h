//
//  JBJokes.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBImageSize;
@class JBUsers;
@class JBVotes;

@interface JBJokes : NSObject
/**	string	发布时间*/
@property (nonatomic, copy) NSString *published_at;

/**	string	发布文字*/
@property (nonatomic, copy) NSString *content;

/**	string	发布状态*/
@property (nonatomic, copy) NSString *state;

/**	string	糗事ID*/
@property (nonatomic, copy) NSString *ID;

/**	string	创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	糗事类型*/
@property (nonatomic, copy) NSString *type;


/**	string	糗事tag*/
@property (nonatomic, copy) NSString *tag;

/**	string	image*/
@property (nonatomic, copy) NSString *image;

/**	string	image的绝对地址*/
@property (nonatomic, copy) NSString *imageAbsolutelyURL;

/**	图片的小尺寸和大尺寸*/
@property (nonatomic, strong) JBImageSize *image_size;

/**	string	允许评论*/
@property (nonatomic, strong) NSNumber *allow_comment;

/**	string	评论数量*/
@property (nonatomic, strong) NSNumber *comments_count;

/**	用户信息*/
@property (nonatomic, strong) JBUsers *user;

/**	string	分享数量*/
@property (nonatomic, strong) NSNumber *share_count;

/**	投票信息*/
@property (nonatomic, strong) JBVotes *votes;

/** pic_size 视频图片大小 */
@property (nonatomic, strong) NSArray *pic_size;

/**	string	视频的判断*/
@property (nonatomic, copy) NSString *loop;

/**	string	pic_url*/
@property (nonatomic, copy) NSString *pic_url;

/**	string	low_url  不清晰视频*/
@property (nonatomic, copy) NSString *low_url;


/**	string	high_url 高清晰视频地址*/
@property (nonatomic, copy) NSString *high_url;

@end
