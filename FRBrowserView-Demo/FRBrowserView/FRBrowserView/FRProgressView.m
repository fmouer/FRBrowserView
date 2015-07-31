//
//  FRProgressView.m
//  TestScrollview
//
//  Created by ihotdo-fmouer on 15/7/29.
//  Copyright (c) 2015年 testNavi. All rights reserved.
//

#import "FRProgressView.h"

@implementation FRProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progressFillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    _progressFillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    self.hidden = YES;
}

-(void)setProgressFillColor:(UIColor *)progressFillColor
{
    _progressFillColor = progressFillColor;
    [self setNeedsDisplay];
}
-(void)setProgress:(float)progress
{
    if (_hideType) {
        self.hidden = _hideType;
        return;
    }
    _progress = progress;
    [self setNeedsDisplay];
    if (_progress >= 1) {
        self.hidden = YES ;
    }else{
        self.hidden = NO;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画圆*/
    //边框圆
    [_progressFillColor setStroke];
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2 - 1, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
 
    [_progressFillColor setFill];
    CGContextMoveToPoint(context, rect.size.width/2 , rect.size.height/2);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2 - 3, -M_PI_2, _progress * M_PI * 2 - M_PI_2, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
}

@end
