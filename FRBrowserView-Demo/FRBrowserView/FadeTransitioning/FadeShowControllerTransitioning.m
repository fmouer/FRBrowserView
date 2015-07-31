/*
 **************************************************************************************
 * Copyright (c) 2013-2015年 testNavi. All rights reserved.
 
 *
 * Project	    : TestNavigation
 *
 * File			: FadeShowControllerTransitioning.m
 *
 * Author		: Ihotdo-fmouer on 15-4-21.
 *
 **************************************************************************************
 **/

#import "FadeShowControllerTransitioning.h"
#import "BrowserType4ViewController.h"
#import "BrowserType1ViewController.h"
#import "FRShowImageView.h"

@implementation FadeShowControllerTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BrowserType4ViewController *fromViewController = (BrowserType4ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BrowserType1ViewController *toViewController = (BrowserType1ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    
    FRCollectionViewCell * cell = [fromViewController getSelectCell:[NSIndexPath indexPathForItem:toViewController.showFirstItem inSection:0]];
    CGRect rect = [cell.superview convertRect:cell.frame toView :containerView];
    
    
    //cell image 放大动画
    FRShowImageView  * view = [[FRShowImageView alloc] initWithFrame:rect];
    [containerView addSubview:view];
    view.shadowColor = toViewController.view.backgroundColor;
    
    CGSize windowSize = containerView.frame.size;
    float width = windowSize.width;
    __weak FRShowImageView * wView = view;
    
    NSString * imageUrl = [[cell.imageUrl stringByReplacingOccurrencesOfString:@"_300x250" withString:@""] stringByReplacingOccurrencesOfString:@"_320x320" withString:@""];
    
    [view setImageUrlString:imageUrl placeholderImage:cell.imageView.image imageSizeBlock:^(CGSize size) {
        float height = size.height / size.width * width;
        [wView showToFrame: CGRectMake(0, windowSize.height/2 - height/2, windowSize.width, height) finished:^{
        }];
    }];

    
    //controller 切换动画
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toViewController.view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
