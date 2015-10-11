//
//  JBTopViewController.h
//  JokeBook
//
//  Created by shanzy on 15/9/2.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBTopViewDelegate <NSObject>

@optional
- (void)indexChanged:(NSInteger)index;
@end


@interface JBTopViewController : UIViewController
@property (nonatomic,weak) id<JBTopViewDelegate> delegate;
@end
