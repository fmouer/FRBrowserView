//
//  FRShowImageView.m
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import "FRShowImageView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "AppDelegate.h"

@implementation FRShowImageView

-(void)setImageUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage  imageSizeBlock:(void (^)(CGSize))sizeBlock
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
    __weak FRShowImageView  * wSelf = self;
    
    [_imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

    }];
    CGSize size = [wSelf setImage:_imageView.image];
    sizeBlock(size);
    
    shadowView = [[UIView alloc] initWithFrame:self.superview.bounds];
    shadowView.backgroundColor = _shadowColor?_shadowColor: [UIColor blackColor];
    shadowView.alpha = _toSmall;
    [self.superview insertSubview:shadowView belowSubview:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        shadowView.alpha = !_toSmall;
    }completion:^(BOOL finished) {
        ;
    }];
}

- (CGSize)setImage:(UIImage *)image
{
    if (image == nil) {
        return self.frame.size;
    }
    CGSize size = _toSmall?[self getAdaptSizeWith:image baseViewSize:self.frame.size]:[self getFillSizeWith:image baseViewSize:self.frame.size];
    _imageView.frame = CGRectMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2, size.width, size.height);
    return size;
}

-(void)showToFrame:(CGRect)rect finished:(void (^)())frameFinished
{
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    UIView  * shadowView = [[UIView alloc] initWithFrame:appDelegate.window.bounds];
//    shadowView.backgroundColor = [UIColor blackColor];
//    shadowView.alpha = _toSmall;
//    [appDelegate.window insertSubview:shadowView belowSubview:self];
    
    CGSize size = _toSmall?[self getFillSizeWith:_imageView.image baseViewSize:rect.size]:[self getAdaptSizeWith:_imageView.image baseViewSize:rect.size];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = rect;
        _imageView.frame = CGRectMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2, size.width, size.height);
    } completion:^(BOOL finished) {
        [shadowView removeFromSuperview];
        [self removeFromSuperview];
        if (frameFinished) {
            frameFinished();
        }
    }];
}

#pragma mark - 计算封面图片的size，保证图片宽高都不小于显示的大小
- (CGSize)getFillSizeWith:(UIImage *)image baseViewSize:(CGSize)viewSize
{
    if (image == nil) {
        return CGSizeZero;
    }
    float scale = [UIScreen mainScreen].scale;
    
    CGSize imageSize = image.size;
    float x = viewSize.width * scale / imageSize.width;
    float y = viewSize.height * scale / imageSize.height;
    if (imageSize.height < viewSize.height * scale) {
        y = viewSize.height * scale / (float)imageSize.height;
    }
    if (imageSize.width < viewSize.width * scale){
        x  = viewSize.width * scale/ (float)imageSize.width;
    }
    float temp = MAX(y, x);
    CGSize size = CGSizeMake(imageSize.width * temp /scale, imageSize.height * temp/scale);
    return size;
}

- (CGSize)getAdaptSizeWith:(UIImage *)image baseViewSize:(CGSize)viewSize
{
    if (image == nil) {
        return CGSizeZero;
    }
    float scale = [UIScreen mainScreen].scale;
    
    CGSize imageSize = image.size;
    float x = viewSize.width * scale / imageSize.width;
    float y = viewSize.height * scale / imageSize.height;
    if (imageSize.height > viewSize.height * scale) {
        y = viewSize.height * scale / (float)imageSize.height;
    }
    if (imageSize.width > viewSize.width * scale){
        x  = viewSize.width * scale/ (float)imageSize.width;
    }
    float temp = MIN(y, x);
    CGSize size = CGSizeMake(imageSize.width * temp /scale, imageSize.height * temp/scale);
    return size;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
