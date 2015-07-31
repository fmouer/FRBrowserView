//
//  FRBrowserFlowLayout.m
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/28.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import "FRBrowserFlowLayout.h"

#define ZOOM_FACTOR 0.15

@implementation FRBrowserFlowLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.zoomCenterScale = 0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    if (_zoomCenterScale == 0) {
        return array;
    }
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    float space = 0;
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetWidth(visibleRect) * _zoomCenterScale + CGRectGetMinX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / (self.itemSize.width + self.minimumLineSpacing);
            if (ABS(distance) < space + self.itemSize.width + self.minimumLineSpacing) {
                CGFloat zoom = MAX(1, 1 + _zoomFactor*(1 - ABS(normalizedDistance)));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }else{
            CGFloat zoom = 1 ;//+ ZOOM_FACTOR*(1 - ABS(normalizedDistance));
            attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
            attributes.zIndex =1;
        }
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if ((_pagingEnabled == NO || self.scrollDirection == UICollectionViewScrollDirectionVertical)
        && self.zoomCenterScale == 0) {
        return proposedContentOffset;
    }
    
    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) * _zoomCenterScale);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            self.centerIndexPath = layoutAttributes.indexPath;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
