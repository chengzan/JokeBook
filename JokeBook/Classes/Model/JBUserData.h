//
//  JBUserData.h
//  JokeBook
//
//  Created by shanzy on 15/9/6.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBUserData : NSObject
/**	string	用户的自我介绍*/
@property (nonatomic, copy) NSString *introduce;

/**	string	location*/
@property (nonatomic, copy) NSString *location;

/**	string	登录的天数*/
@property (nonatomic, strong) NSNumber *login_eday;

/**	string	用户的年龄*/
@property (nonatomic, strong) NSNumber *qb_age;

/**	string	用户头像*/
@property (nonatomic, copy) NSString *icon;

/**	string	用户星座*/
@property (nonatomic, copy) NSString *astrology;

/**	string	用户工作所在地*/
@property (nonatomic, copy) NSString *haunt;

/**	string	手机标识*/
@property (nonatomic, copy) NSString *mobile_brand;

/**	string	big_cover_eday*/
@property (nonatomic, strong) NSNumber *big_cover_eday;

/**	string	糗事数量*/
@property (nonatomic, copy) NSString *qs_cnt;

/**	string	relationship*/
@property (nonatomic, copy) NSString *relationship;

/**	string	signature*/
@property (nonatomic, copy) NSString *signature;

/**	string	工作类型*/
@property (nonatomic, copy) NSString *job;

/**	string	bg*/
@property (nonatomic, strong) NSNumber *bg;

/**	string	性别*/
@property (nonatomic, copy) NSString *gender;

/**	string	icon_eday*/
@property (nonatomic, strong) NSNumber *icon_eday;

/**	string	uid*/
@property (nonatomic, copy) NSString *uid;

/**	string	点赞数*/
@property (nonatomic, copy) NSString *smile_cnt;

/**	string	用户名*/
@property (nonatomic, copy) NSString *login;

/**	string	封面图*/
@property (nonatomic, copy) NSString *big_cover;

/**	string	hobby*/
@property (nonatomic, copy) NSString *hobby;

/**	string	年龄*/
@property (nonatomic, copy) NSString *age;

/**	string	创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	emotion*/
@property (nonatomic, copy) NSString *emotion;

/**	string	家乡*/
@property (nonatomic, copy) NSString *hometown;
@end
