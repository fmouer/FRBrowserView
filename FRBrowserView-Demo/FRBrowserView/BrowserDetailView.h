//
//  BrowserDetailView.h
//  FRBrowserView
//
//  Created by ihotdo-fmouer on 15/7/30.
//  Copyright (c) 2015年 FRBrowserView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRBrowserView.h"
#import "BrowserType3ViewController.h"

@interface BrowserDetailView : UIView<FRBrowserViewDelegate>
{
//    NSArray * _dataArray;
    FRBrowserView   * _browserView;
}

@property (nonatomic, copy)NSArray * dataArray;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, assign)NSInteger showFirstItem;


@property (nonatomic, weak)BrowserType3ViewController   * wController;

@end

