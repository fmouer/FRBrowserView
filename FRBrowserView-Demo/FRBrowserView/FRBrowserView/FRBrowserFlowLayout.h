//
//  FRBrowserFlowLayout.h
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/28.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRBrowserFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong)NSIndexPath    * centerIndexPath;

@property (nonatomic, assign)float zoomCenterScale;

@property (nonatomic, assign)float zoomFactor;

@property (nonatomic, assign)BOOL pagingEnabled;

@end
