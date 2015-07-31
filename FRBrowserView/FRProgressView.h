//
//  FRProgressView.h
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/29.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRProgressView : UIView

@property (nonatomic, assign)float  progress;

@property (nonatomic, strong)UIColor * progressFillColor;

@property (nonatomic, assign)BOOL hideType;
@end
