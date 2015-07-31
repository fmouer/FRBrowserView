//
//  FRBrowserView.h
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/28.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRProgressView.h"
#import "SVPullToRefresh.h"

///图片为圆形显示
#define CornerRadiusToCircle    -1

#import "FRBrowserFlowLayout.h"


/**
 *刷新方式
 */
typedef enum {
    ///不需要下拉刷新和上拉加载更多
    FRBrowserRefreshTypeNone = 0,
    ///下拉刷新
    FRBrowserRefreshTypeRefresh ,
    ///上拉加载
    FRBrowserRefreshTypeLoading,
    ///上拉加载和下拉刷新
    FRBrowserRefreshTypeRefreshAndLoading,
}FRBrowserRefreshType;

@protocol FRBrowserViewDelegate ;

@interface FRBrowserView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView        * _browserCollectionView;
    FRBrowserFlowLayout     * _flowLayout;
}

@property (nonatomic, assign)id<FRBrowserViewDelegate>delegagte;

@property (nonatomic, readonly)UICollectionView * collectionView;

@property (nonatomic, strong)FRBrowserFlowLayout * flowLayout;

@property (nonatomic, assign)NSInteger  showFirstItem;

/**
 *  双击放大图片,默认NO
 */
@property (nonatomic, assign)BOOL doubleZoomInType;

/**
 *  手势放大，默认NO
 */
@property (nonatomic, assign)BOOL gestureZoomInType;

/**
 * 图片适应size，默认YES；
 * YES：则图片按自身比例显示。NO：则填充显示，且不支持放大；
 */
@property (nonatomic, assign)BOOL imageAdaptSizeType;

/**
 *图片左右间距，需要初始化时设置
 */
@property (nonatomic, assign)float  minimumLineSpacing;

/**
 *行首图片离collectionView的左间距，默认等于minimumLineSpacing
 */
@property (nonatomic, assign)float cellLeftSpace;

/**
 *行末图片离collectionView的右间距，默认等于minimumLineSpacing
 */
@property (nonatomic, assign)float cellRightSpace;

/**
 *图片上下间距，需要初始化时设置
 */
@property (nonatomic, assign)float minimumInteritemSpacing;

/**
 *  cell size.用于横向显示时设置image大小
 */
@property (nonatomic, assign)CGSize itemImageSize;

/**
 *  是否按分页显示
 */
@property (nonatomic, assign)BOOL pagingEnabled;

/**
 *图片圆角设置
 */
@property (nonatomic, assign)float cellCornerRadius;

/**
 *一行显示图片的个数，上下滑动时设置
 */
@property (nonatomic, assign)NSInteger  rowNumber;

/**
 *cell点击选择时动画
 */
@property (nonatomic, assign)BOOL cellSelectedAnimation;

@property (nonatomic, assign)UICollectionViewScrollDirection scrollDirection;

/**
 *隐藏进度条，默认NO(即不隐藏)
 */
@property (nonatomic, assign)BOOL hideProgressViewState;

/**
 *设置上拉加载和下拉刷新方式，仅在UICollectionViewScrollDirectionVertical方式下有效
 */
@property (nonatomic, assign)FRBrowserRefreshType refreshType;

/**
 * 图片滚动时放大倍数
 */
@property (nonatomic, assign)float zoomFactor;

/**
 *指定图片cell在 uiconllectionView 的某个位置放大
 */
@property (nonatomic, assign)float zoomCenterScale;


-(instancetype)initWithFrame:(CGRect)frame itemSpace:(float)itemSpace;

- (void)reloadData;

- (void)reloadDataToPageIndex:(NSInteger)pageIndex;

- (void)insertIndexPaths:(NSArray *)indexPaths refresh:(BOOL)refresh;

@end



@interface FRCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
{
    UIScrollView        *   _contentScrollView;
    
    UIImageView         *   _contentImageView;
    
    BOOL                    _isZoomIn;
    
    FRProgressView      *   _progressView;
    
    UITapGestureRecognizer * _tapGesture;
    
    UITapGestureRecognizer  * _doubTapGesture;
}

@property (nonatomic, strong)NSString * imageUrl;

@property (nonatomic, assign)BOOL doubleZoomInType;

@property (nonatomic, assign)BOOL gestureZoomInType;

@property (nonatomic, assign)BOOL imageAdaptSizeType;

@property (nonatomic, weak)FRBrowserView    * wBrowserView;

@property (nonatomic, assign)float cornerRadius;

@property (nonatomic, assign)BOOL cellSelectedAnimation;

@property (nonatomic, assign)BOOL hideProgressViewState;

@property (nonatomic, readonly)UIImageView  * imageView;
@property (nonatomic, readonly)UIScrollView  * contentScrollView;

@property (nonatomic, strong)UIImage * placeholderImage;

@end


@protocol FRBrowserViewDelegate <NSObject>

- (NSString *)imageStringForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem;

- (NSInteger)numberItemsForFRBrowserView:(FRBrowserView *)browserView;

@optional

- (UIImage *)placeholderImageForFRBrowserView:(FRBrowserView *)browserView pageItem:(NSInteger)pageItem;

- (void)frBrowserView:(FRBrowserView *)browserView centerItem:(NSInteger)centerItem;

- (void)frBrowserView:(FRBrowserView *)browserView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *下拉刷新
 */
- (void)frBrowserViewRefresh:(FRBrowserView *)browserView;

/**
 *上拉加载更多
 */
- (void)frBrowserViewLoading:(FRBrowserView *)browserView;

@end