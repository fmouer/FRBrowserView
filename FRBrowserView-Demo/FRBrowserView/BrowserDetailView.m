//
//  BrowserDetailView.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "BrowserDetailView.h"
#import "AppDelegate.h"
#import "FRShowImageView.h"
#import "SDImageCache.h"

@implementation BrowserDetailView

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor blackColor];
    _browserView = [[FRBrowserView alloc] initWithFrame:self.bounds];
    _browserView.delegagte = self;
    
    //图片间距
    _browserView.minimumLineSpacing = 5;
    //需在minimumLineSpacing 后赋值
    _browserView.cellLeftSpace = 0;
    //第一次展示第3张图
    _browserView.showFirstItem = _showFirstItem;
    //图片比例显示
    _browserView.imageAdaptSizeType = YES;
    //双击放大
    _browserView.doubleZoomInType = YES;
    //手势放大
    _browserView.gestureZoomInType = YES;
    _browserView.pagingEnabled = YES;
    _browserView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:_browserView];
    
    UIButton  * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 50, 30);
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor redColor];
    [self addSubview:backButton];
}

- (UIImage *)placeholderImageForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    NSString * urlString = _dataArray[pageItem%_dataArray.count];
    UIImage *image =[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:urlString];
    return image;
}

-(NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem
{
    NSString * imagUrl1 = _dataArray[pageItem%_dataArray.count];
    NSString * imageUrl = [[imagUrl1 stringByReplacingOccurrencesOfString:@"_300x250" withString:@""] stringByReplacingOccurrencesOfString:@"_320x320" withString:@""];
    return imageUrl;
}

-(NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView
{
    
    return _dataArray.count * _page;
}

-(void)frBrowserView:(FRBrowserView *)browserView centerItem:(NSInteger)centerItem
{
    NSLog(@"centerItem is %ld",(long)centerItem);
}
- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selectedItem is %ld",(long)indexPath.row);
    
}

- (void)backButtonEvent
{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    FRCollectionViewCell  * cell = (FRCollectionViewCell *)[_browserView.collectionView cellForItemAtIndexPath:_browserView.flowLayout.centerIndexPath];
    
    CGRect rect1 = [cell.superview convertRect:cell.frame toView :appDelegate.window];

    NSLog(@"image frame is %@",NSStringFromCGRect(cell.imageView.frame));
    rect1.origin.x -= cell.contentScrollView.contentOffset.x;
    rect1.origin.y -= (cell.contentScrollView.contentOffset.y == 0)?(-cell.imageView.frame.origin.y):cell.contentScrollView.contentOffset.y;
    rect1.size = cell.imageView.frame.size;
    
    CGRect rect = [_wController getBrowserItemRectWith:_browserView.flowLayout.centerIndexPath];
    
    
    FRShowImageView  * view = [[FRShowImageView alloc] initWithFrame:rect1];
    [appDelegate.window addSubview:view];
    view.toSmall = YES;
    __weak FRShowImageView * wView = view;
    [view setImageUrlString:cell.imageUrl placeholderImage:cell.imageView.image imageSizeBlock:^(CGSize size) {
        [wView showToFrame:rect finished:nil];
    }];
    [self removeFromSuperview];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
