//
//  ETTRadarIndictorView.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 2017/3/23.
//  Copyright © 2017年 iOS. All rights reserved.
//

#import "ETTRadarIndictorView.h"
#define RADAR_DEFAULT_SECTIONS_NUM 3
#define RADAR_DEFAULT_RADIUS 100.f
#define RADAR_ROTATE_SPEED 60.f
#define INDICATOR_START_COLOR [UIColor colorWithRed:142.0/255.0 green:229.0/255.0 blue: 283.0/255.0 alpha:1]
#define INDICATOR_END_COLOR [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue: 250.0/255.0 alpha:0]
#define INDICATOR_ANGLE 90.f
#define INDICATOR_CLOCKWISE YES
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

static NSString * const rotationAnimationKey = @"rotationAnimation";

@implementation ETTRadarIndictorView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _angle = INDICATOR_ANGLE;
        _startColor = INDICATOR_START_COLOR;
        _endColor = INDICATOR_END_COLOR;
        _clockwise = INDICATOR_CLOCKWISE;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画扇形
    UIColor *startColor = self.startColor;
    CGContextSetFillColorWithColor(context, startColor.CGColor); // 填充颜色
    CGContextSetLineWidth(context, 0);  // 线宽
    CGContextMoveToPoint(context, self.center.x, self.center.y); // 圆心
    CGContextAddArc(context, self.center.x, self.center.y, self.radius, (self.clockwise?self.angle:0) * M_PI / 180, (self.clockwise?(self.angle - 1):1) * M_PI / 180, self.clockwise);  // 半径为 self.radius
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);  // 绘制
    
    const CGFloat *startColorComponents = CGColorGetComponents(self.startColor.CGColor);    //开始颜色的 RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(self.endColor.CGColor);    //结束颜色的 RGB components
    
    CGFloat R, G, B, A;
    for (int i = 0; i <= self.angle; i++)
    {
        CGFloat ratio = (self.clockwise?(self.angle - i):i)/self.angle;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0]) * ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1]) * ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2]) * ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3]) * ratio;
        
        UIColor *startColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
        
        CGContextSetFillColorWithColor(context, startColor.CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextMoveToPoint(context, self.center.x, self.center.y);
        CGContextAddArc(context, self.center.x, self.center.y, self.radius, i * M_PI / 180, (i + (self.clockwise?-1:1)) * M_PI / 180, self.clockwise);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
}

#pragma mark - Actions
- (void)startScan
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    BOOL indicatorClockwise = INDICATOR_CLOCKWISE;
    rotationAnimation.toValue = [NSNumber numberWithFloat:(indicatorClockwise?1:-1) * M_PI * 2.0];
    rotationAnimation.duration = 360.f / RADAR_ROTATE_SPEED;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [self.layer addAnimation:rotationAnimation forKey:rotationAnimationKey];
}

- (void)stopScan
{
    [self.layer removeAnimationForKey:rotationAnimationKey];
}

@end
