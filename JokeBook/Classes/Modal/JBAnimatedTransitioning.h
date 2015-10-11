//
//  JBAnimatedTransitioning.h
//  05-自定义UIPresentationController
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presented;
@end
