//
//  FadeBackControllerTransitioning.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "FadeBackControllerTransitioning.h"
#import "BrowserType1ViewController.h"
#import "BrowserType4ViewController.h"
#import "AppDelegate.h"
#import "FRShowImageView.h"

@implementation FadeBackControllerTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    BrowserType1ViewController *fromViewController = (BrowserType1ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BrowserType4ViewController *toViewController = (BrowserType4ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    
    FRCollectionViewCell * cell = [fromViewController getSelectCell];
    
    CGRect rect1 = [cell.superview convertRect:cell.frame toView :containerView];
    NSLog(@"image frame is %@",NSStringFromCGRect(cell.imageView.frame));
    rect1.origin.x -= cell.contentScrollView.contentOffset.x;
    rect1.origin.y -= (cell.contentScrollView.contentOffset.y == 0)?(-cell.imageView.frame.origin.y):cell.contentScrollView.contentOffset.y;
    rect1.size = cell.imageView.frame.size;
    
    CGRect rect = [toViewController getBrowserItemRectWith:[NSIndexPath indexPathForItem:[fromViewController getBrowserAtIndexPathRow] inSection:0]];
    
    
    //cell image 隐藏动画
    FRShowImageView  * cellImageView = [[FRShowImageView alloc] initWithFrame:rect1];
    cellImageView.toSmall = YES;
    [containerView addSubview:cellImageView];
    cellImageView.shadowColor = toViewController.view.backgroundColor;
    
    __weak FRShowImageView * wView = cellImageView;
    
    NSString * imageUrl = [[cell.imageUrl stringByReplacingOccurrencesOfString:@"_300x250" withString:@""] stringByReplacingOccurrencesOfString:@"_320x320" withString:@""];
    
    [cellImageView setImageUrlString:imageUrl placeholderImage:cell.imageView.image imageSizeBlock:^(CGSize size) {
        [wView showToFrame: rect finished:nil];
    }];
    
    
    //controller 动画
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    //    toViewController.view.center = CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height*1.5);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    fromViewController.view.alpha = 1;
    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        //        toViewController.view.center = CGPointMake(toViewController.view.center.x, toViewController.view.frame.size.height/2);
        fromViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        //        [fromViewController.view removeFromSuperview];
        
    }];
    
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

@end
