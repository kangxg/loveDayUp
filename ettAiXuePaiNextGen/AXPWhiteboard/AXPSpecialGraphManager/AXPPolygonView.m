//
//  AXPPolygonView.m
//  AXPBasic
//
//  Created by Li Kaining on 16/9/6.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define kApexColor [UIColor colorWithRed:74.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:203.0/255.0]

#define kApexWH 4.5

#import "AXPPolygonView.h"
#import "AXPWhiteboardConfiguration.h"

@implementation AXPPolygonView

-(instancetype)initWithModel:(AXPPolygonImageModel *)model
{
    self = [super init];
    
    if (self) {
    
//        self.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.3];
        
        self.backgroundColor     = [UIColor clearColor];

        self.polygonModel        = model;
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path          = model.bezierPath.CGPath;
        shapeLayer.lineWidth     = 1;;
        shapeLayer.strokeColor   = [UIColor blueColor].CGColor;
        shapeLayer.fillColor     = nil;
        shapeLayer.lineJoin      = kCALineJoinRound ;
        shapeLayer.lineCap       = kCALineCapRound;
        [self.layer addSublayer:shapeLayer];
        
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect
{
    [self addPoints:self.polygonModel.apexPointsArray withColor:self.polygonModel.color];
    
    [self drawSymbols:self.polygonModel.polygonSymbolDict];
}

// 添加点
-(void)addPoints:(NSArray *)points withColor:(UIColor *)color
{
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =obj;
        CGPoint point = CGPointFromString(str);
        
        [self addPoint:point withColor:color];
    }];
}

-(void)addPoint:(CGPoint)point withColor:(UIColor *)color
{
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    
    if ([color isKindOfClass:[UIColor class]]) {
        
        [color setFill];
        
    }else
    {
        [[UIColor blackColor] setFill];
    }
    
    if ([[AXPWhiteboardConfiguration sharedConfiguration].apexStyle isEqualToString:@"circleApexBlack"]) {
        
        CGContextAddArc(ctx, point.x, point.y, kApexWH, 0, 2*M_PI, 1);
        
    }else if([[AXPWhiteboardConfiguration sharedConfiguration].apexStyle isEqualToString:@"squareApexBlack"])
    {
        CGRect rect = CGRectMake(point.x - kApexWH, point.y - kApexWH, kApexWH*2, kApexWH*2);
        
        CGContextAddRect(ctx, rect);
    }
    
    CGContextFillPath(ctx);
}

// 绘制过程(贝塞尔曲线和标注点)
-(void)drawSymbols:(NSDictionary *)symbols
{
    // 绘制标记点
    [symbols enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *symbolStr = key;
        NSString *symbolPointStr = obj;
        
        [self addSymbolmarkWithPoint:CGPointFromString(symbolPointStr) andStr:symbolStr];
    }];
}
// 绘制标记
-(void)addSymbolmarkWithPoint:(CGPoint)point andStr:(NSString *)str
{
    if (![AXPWhiteboardConfiguration sharedConfiguration].showSymbol) {
        return;
    }
    
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}.mutableCopy;
    
    CGSize size = [str sizeWithAttributes:textAttributes];
    
    CGRect rect = CGRectMake(point.x - size.width/2, point.y - size.height/2, size.width , size.height);
    
    [str drawInRect:rect withAttributes:textAttributes];
}

@end
