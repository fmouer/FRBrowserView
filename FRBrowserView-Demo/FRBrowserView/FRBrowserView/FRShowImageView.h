//
//  FRShowImageView.h
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRShowImageView : UIView
{
    UIImageView     * _imageView;
    UIView  * shadowView;
}
@property (nonatomic, assign)BOOL toSmall;

@property (nonatomic, strong)UIColor * shadowColor;

//- (void)setImageUrlString:(NSString *)urlString
//         placeholderImage:(UIImage *)placeholderImage
//                  loading:(void(^)())loading
//           imageSizeBlock:(void(^)(CGSize size))sizeBlock;

-(void)setImageUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage  imageSizeBlock:(void (^)(CGSize))sizeBlock;


- (void)showToFrame:(CGRect)rect finished:(void(^)())frameFinished;

@end
