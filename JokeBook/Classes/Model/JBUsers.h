//
//  JBUsers.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBUsers : NSObject
/**	string	字符串型的用户名*/
@property (nonatomic, copy) NSString *login;

/**	string	字符串型的用户头像*/
@property (nonatomic, copy) NSString *icon;

/**	string	头像更新时间*/
@property (nonatomic, copy) NSString *avatar_updated_at;

/**	string	用户创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	用户角色*/
@property (nonatomic, copy) NSString *role;

/**	string	用户ID*/
@property (nonatomic, copy) NSString *ID;

/**	string	用户email*/
@property (nonatomic, copy) NSString *email;

/**	string	最后一次登录的设备*/
@property (nonatomic, copy) NSString *last_device;

/**	string	用户状态*/
@property (nonatomic, copy) NSString *state;

/**	string	最后访问时间*/
@property (nonatomic, copy) NSString *last_visited_at;
@end
