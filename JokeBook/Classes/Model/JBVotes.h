//
//  JBVotes.h
//  JokeBook
//
//  Created by shanzy on 15/9/3.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JBVotes : NSObject
/**	NSNumber	赞数*/
@property (nonatomic, strong) NSNumber* up;
/**	NSString	踩数*/
@property (nonatomic, strong) NSNumber* down;
@end
