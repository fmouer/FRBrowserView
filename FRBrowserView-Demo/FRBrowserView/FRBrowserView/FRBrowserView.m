//
//  FRBrowserView.m
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/28.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import "FRBrowserView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


@interface FRBrowserView ()

- (void)selectCollectionCell:(FRCollectionViewCell *)cell;

@end
@implementation FRBrowserView
@synthesize collectionView = _browserCollectionView;
@synthesize flowLayout  = _flowLayout;

-(void)setDoubleZoomInType:(BOOL)doubleZoomInType
{
    if (_imageAdaptSizeType == NO) {
        doubleZoomInType = NO;
    }else{
        _doubleZoomInType = doubleZoomInType;
    }
}

-(void)setGestureZoomInType:(BOOL)gestureZoomInType
{
    if (_imageAdaptSizeType == NO) {
        gestureZoomInType = NO;
    }else{
        _gestureZoomInType = gestureZoomInType;
    }
}

-(void)setImageAdaptSizeType:(BOOL)imageAdaptSizeType
{
    _imageAdaptSizeType = imageAdaptSizeType;
    if (imageAdaptSizeType == NO) {
        _doubleZoomInType = NO;
        _gestureZoomInType = NO;
    }
}

-(void)setMinimumLineSpacing:(float)minimumLineSpacing
{
    _minimumLineSpacing = minimumLineSpacing;
    _flowLayout.minimumLineSpacing = minimumLineSpacing;
    if (_cellRightSpace == 0) {
        _cellRightSpace = minimumLineSpacing;
    }
    if (_cellLeftSpace == 0) {
        _cellLeftSpace = minimumLineSpacing;
    }
}

-(void)setMinimumInteritemSpacing:(float)minimumInteritemSpacing
{
    _minimumInteritemSpacing = minimumInteritemSpacing;
//    _flowLayout.minimumInteritemSpacing = _minimumInteritemSpacing;
}

-(void)setPagingEnabled:(BOOL)pagingEnabled
{
    _pagingEnabled = pagingEnabled;
    _browserCollectionView.pagingEnabled = pagingEnabled;
    _flowLayout.pagingEnabled = pagingEnabled;
}

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
    
}

-(void)setRowNumber:(NSInteger)rowNumber
{
    _rowNumber = rowNumber;
}

/**
 * 图片滚动时放大倍数
 */
-(void)setZoomFactor:(float)zoomFactor
{
    _zoomFactor = zoomFactor;
    _flowLayout.zoomFactor = _zoomFactor;
}

/**
 *指定图片cell在 uiconllectionView 的某个位置放大
 */

-(void)setZoomCenterScale:(float)zoomCenterScale
{
    _zoomCenterScale = zoomCenterScale;
    _flowLayout.zoomCenterScale = _zoomCenterScale;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _flowLayout = [[FRBrowserFlowLayout alloc] init];
       
        self.imageAdaptSizeType = YES;
    }
    return self;
}

#pragma mark 初始化 _browserCollectionView
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_browserCollectionView == nil) {
        CGRect rect = self.bounds;
        if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            rect.size.width = CGRectGetWidth(rect ) + _minimumLineSpacing;
        }else if (_rowNumber && CGSizeEqualToSize(_itemImageSize, CGSizeZero)){
            float sizeWidth = (self.frame.size.width - _minimumLineSpacing ) / (float)_rowNumber - _minimumLineSpacing ;
            _itemImageSize = CGSizeMake(sizeWidth, sizeWidth);
        }
        
        _browserCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:_flowLayout];
        _browserCollectionView.delegate = self;
        _browserCollectionView.dataSource = self;
        _browserCollectionView.backgroundColor = [UIColor clearColor];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            _browserCollectionView.alwaysBounceVertical = YES;
            _browserCollectionView.showsVerticalScrollIndicator = NO;
        }else{
            _browserCollectionView.showsHorizontalScrollIndicator = NO;
            _browserCollectionView.alwaysBounceHorizontal = YES;
        }
        [self addSubview:_browserCollectionView];
        _browserCollectionView.clipsToBounds = NO;
        [_browserCollectionView registerClass:[FRCollectionViewCell class] forCellWithReuseIdentifier:@"collection_id"];
        _browserCollectionView.pagingEnabled = _pagingEnabled;
        
        [_browserCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_showFirstItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        _flowLayout.centerIndexPath = [NSIndexPath indexPathForRow:_showFirstItem inSection:0];
        
        if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserView:centerItem:)]) {
            [_delegagte frBrowserView:self centerItem:_flowLayout.centerIndexPath.row];
        }
        
        if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
            __weak FRBrowserView    * wSelf = self;
            //下拉刷新
            if (_refreshType == FRBrowserRefreshTypeRefresh ||
                _refreshType == FRBrowserRefreshTypeRefreshAndLoading) {
                [_browserCollectionView addPullToRefreshWithActionHandler:^{
                    [wSelf refresh];
                }];
            }
           //上拉加载更多
            if (_refreshType == FRBrowserRefreshTypeLoading ||
                _refreshType == FRBrowserRefreshTypeRefreshAndLoading) {
                [_browserCollectionView addInfiniteScrollingWithActionHandler:^{
                    [wSelf loading];
                }];
            }
        }
        
       
    }
}

-(instancetype)initWithFrame:(CGRect)frame itemSpace:(float)itemSpace
{
    return nil;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection_id" forIndexPath:indexPath];
    cell.wBrowserView = self;
    cell.doubleZoomInType = _doubleZoomInType;
    cell.imageAdaptSizeType = _imageAdaptSizeType;
    cell.gestureZoomInType = _gestureZoomInType;
    cell.cornerRadius = _cellCornerRadius;
    cell.cellSelectedAnimation = _cellSelectedAnimation;
    cell.hideProgressViewState = _hideProgressViewState;
    
    if (_delegagte && [_delegagte respondsToSelector:@selector(placeholderImageForFRBrowserView:pageItem:)]) {
        UIImage * image = [_delegagte placeholderImageForFRBrowserView:self pageItem:indexPath.row];
        cell.placeholderImage = image;
    }else{
        cell.placeholderImage = nil;
    }
    NSString * imageUrl = [_delegagte imageStringForFRBrowserView:self pageItem:indexPath.row];
    cell.imageUrl = imageUrl;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberItems = [_delegagte numberItemsForFRBrowserView:self];
    return numberItems;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!CGSizeEqualToSize(_itemImageSize, CGSizeZero)) {
        return _itemImageSize;
    }
    return self.frame.size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(_minimumInteritemSpacing, _cellLeftSpace, _minimumInteritemSpacing, _cellRightSpace);
}


#pragma mark 选择或点击 FRCollectionViewCell
-(void)selectCollectionCell:(FRCollectionViewCell *)cell
{
    NSIndexPath * indexPath = [_browserCollectionView indexPathForCell:cell];
    [self collectionView:_browserCollectionView didSelectItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserView:didSelectItemAtIndexPath:)]) {
        [_delegagte frBrowserView:self didSelectItemAtIndexPath:indexPath];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserView:centerItem:)]) {
        [_delegagte frBrowserView:self centerItem:_flowLayout.centerIndexPath.row];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserView:centerItem:)]) {
        [_delegagte frBrowserView:self centerItem:_flowLayout.centerIndexPath.row];
    }
}
#pragma mark - 数据加载

//下拉刷新
- (void)refresh
{
    if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserViewRefresh:)]) {
        [_delegagte frBrowserViewRefresh:self];
    }
}

- (void)insertIndexPaths:(NSArray *)indexPaths refresh:(BOOL)refresh
{
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
    if (refresh) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }else{
        [self.collectionView.infiniteScrollingView stopAnimating];
    }
}

//上拉加载
- (void)loading
{
    if (_delegagte && [_delegagte respondsToSelector:@selector(frBrowserViewLoading:)]) {
        [_delegagte frBrowserViewLoading:self];
    }
}

-(void)reloadData
{
    [_browserCollectionView reloadData];
    [_browserCollectionView setContentOffset:CGPointMake(0.1, 0) animated:YES];
    [_browserCollectionView setContentOffset:CGPointZero animated:YES];
    if (_browserCollectionView.contentSize.height < _browserCollectionView.frame.size.height) {
        _browserCollectionView.contentSize = CGSizeMake(_browserCollectionView.frame.size.width, _browserCollectionView.frame.size.height + 1);
    }
}
- (void)reloadDataToPageIndex:(NSInteger)pageIndex
{
    [_browserCollectionView reloadData];
    [_browserCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageIndex inSection:0]
                                   atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark -FRCollectionViewCell
@interface FRCollectionViewCell ()

@end
@implementation FRCollectionViewCell
@synthesize imageView = _contentImageView;
@synthesize contentScrollView = _contentScrollView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView.delegate = self;
        [self addSubview:_contentScrollView];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(cellSinglehandleTap:)];
        [_tapGesture setNumberOfTouchesRequired:1];
        [_contentScrollView addGestureRecognizer:_tapGesture];
        [_tapGesture setNumberOfTapsRequired:1];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:_contentScrollView.bounds];
        [_contentScrollView addSubview:_contentImageView];
        
       
        float progressWidth = MIN(50, frame.size.width - 4);
        
        _progressView = [[FRProgressView alloc] initWithFrame:CGRectMake(frame.size.width/2 - progressWidth/2, frame.size.height/2 - progressWidth/2, progressWidth, progressWidth)];
        [self addSubview:_progressView];
        _contentScrollView.maximumZoomScale = 2;

    }
    return self;
}

-(void)setDoubleZoomInType:(BOOL)doubleZoomInType
{
    _doubleZoomInType = doubleZoomInType;
    if (_doubTapGesture == nil && doubleZoomInType) {
        _doubTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(cellhandleTap:)];
        [_doubTapGesture setNumberOfTouchesRequired:1];
        [_contentImageView addGestureRecognizer:_doubTapGesture];
        [_doubTapGesture setNumberOfTapsRequired:2];
        _contentImageView.userInteractionEnabled = YES;
        [_tapGesture requireGestureRecognizerToFail: _doubTapGesture];
 }

}

-(void)setCornerRadius:(float)cornerRadius
{
    if (cornerRadius == CornerRadiusToCircle) {
        _contentImageView.layer.cornerRadius = _contentImageView.frame.size.width/2;
    }else{
        _contentImageView.layer.cornerRadius = cornerRadius;
    }
    _contentImageView.layer.masksToBounds = YES;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    _isZoomIn = YES;
    if ([imageUrl hasPrefix:@"http"]) {
        //网络图片
        __weak FRCollectionViewCell * wSelf = self;
        __weak FRProgressView   * wProgressView = _progressView;
        NSURL * url = [NSURL URLWithString:imageUrl];
        _contentScrollView.zoomScale = 1;
        _contentScrollView.minimumZoomScale = 1;
        _contentScrollView.contentSize = _contentScrollView.frame.size;
        _progressView.hideType = _hideProgressViewState;
        
        UIImage *image =[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:imageUrl];
        if (image == nil && _placeholderImage) {
            [self setImage:_placeholderImage];
        }
        if (image == nil) {
            _progressView.hidden = NO;
        }
        [_contentImageView setImageWithURL:url placeholderImage:_placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
            float progress = receivedSize / (float)expectedSize;
            NSLog(@"progress is %f",progress);
            wProgressView.progress = progress;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [wSelf setImage:image];
        }];
    }else{
        //加载本地图片
        UIImage * image = [UIImage imageNamed:imageUrl];
        _contentImageView.image = image;
        [self setImage:image];
    }
}
- (void)setImage:(UIImage *)image
{
    _progressView.hidden = YES;
    if (image == nil) {
        return;
    }
    CGSize size = CGSizeZero;
    if (_imageAdaptSizeType) {
        size = [self getAdaptSizeWith:image baseViewSize:_contentScrollView.frame.size];
        _contentImageView.frame = CGRectMake(_contentScrollView.frame.size.width/2 - size.width/2, _contentScrollView.frame.size.height/2 - size.height/2, size.width,size.height);
    }else{
//        size = [self getFillSizeWith:image baseViewSize:_contentScrollView.frame.size];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            UIImage * sizeImage = [self sourceImage:image byScalingAndCroppingForSize:_contentScrollView.frame.size];
            dispatch_async(dispatch_get_main_queue(),^{
                _contentImageView.image = sizeImage;

            });

        });
//        UIImage * sizeImage = [self sourceImage:image byScalingAndCroppingForSize:_contentScrollView.frame.size];
//        _contentImageView.image = sizeImage;
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    UIImageView *iv=nil;
    for(id vw in scrollView.subviews) {
        if([vw isKindOfClass:[UIImageView class]])
        {
            iv =vw;
            break;
        }
    }
    iv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_gestureZoomInType == NO || _progressView.hidden == NO) {
        return nil;
    }
    return _contentImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
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

#pragma mark 双击图片
- (void)cellhandleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_progressView.hidden == NO) {
        return;
    }
    float scale = _contentScrollView.zoomScale ;
    if (scale < _contentScrollView.maximumZoomScale && _isZoomIn) {
        scale += (_contentScrollView.maximumZoomScale - _contentScrollView.minimumZoomScale) / 2 + 0.1;
        _isZoomIn = scale < _contentScrollView.maximumZoomScale;
    }else{
        scale -= (_contentScrollView.maximumZoomScale - _contentScrollView.minimumZoomScale) / 2;

        _isZoomIn = scale <= _contentScrollView.minimumZoomScale;

    }
    CGRect zoomRect = [self zoomRectForScale:MAX(_contentScrollView.minimumZoomScale, MIN(_contentScrollView.maximumZoomScale, scale)) withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [_contentScrollView zoomToRect:zoomRect animated:YES];
    
}

#pragma mark 单击图片
- (void)cellSinglehandleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [_wBrowserView selectCollectionCell:self];
    if (_cellSelectedAnimation) {
        [UIView animateWithDuration:0.1 animations:^{
            _contentImageView.transform = CGAffineTransformMakeScale(0.98, 0.98);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _contentImageView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }
}


/**
 * 按照 targetSize1 截取并缩放 sourceImage，并且不变形，从中间截取
 */
- (UIImage*)sourceImage:(UIImage *)sourceImage byScalingAndCroppingForSize:(CGSize)targetSize1
{
    float scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(targetSize1.width * scale, targetSize1.height *scale);
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end





