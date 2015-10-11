//
//  JBTransition.m
//  05-自定义UIPresentationController
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 All rights reserved.
//

#import "JBTransition.h"
#import "JBPresentationController.h"
#import "JBAnimatedTransitioning.h"

@implementation JBTransition
SingletonM(transition)

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[JBPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    JBAnimatedTransitioning *anim = [[JBAnimatedTransitioning alloc] init];
    anim.presented = YES;
    return anim;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    JBAnimatedTransitioning *anim = [[JBAnimatedTransitioning alloc] init];
    anim.presented = NO;
    return anim;
}
@end
