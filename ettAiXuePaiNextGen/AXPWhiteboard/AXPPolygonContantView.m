//
//  AXPPolygonContantView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPPolygonContantView.h"
#import "AXPWhiteboardConfiguration.h"

#define kApexColor [UIColor colorWithRed:74.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:203.0/255.0]

#define kApexWH 4.5

@interface AXPPolygonContantView ()

@property(nonatomic ,strong) NSMutableArray *points;
@property(nonatomic ,strong) NSMutableArray *polygonElements;


@end


@implementation AXPPolygonContantView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.frame = CGRectMake(0, 0, kWIDTH-kAXPWhiteboardManagerWidth, kHEIGHT-64);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    return self;
}

-(void)drawPolygonlinePath:(UIBezierPath *)linePath symbolDict:(NSMutableDictionary *)symbolDict points:(NSMutableArray *)points
{
    self.points = points;
    self.symbolDict = symbolDict;
    self.linePath = linePath;
    
    [self setNeedsDisplay];
}


-(void)drawPolygonWithPolygonElements:(NSMutableArray *)polygonElements
{
    self.completionDashPath = nil;
    self.linePath = nil;
    
    self.polygonElements = polygonElements;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if (self.linePath) {
    
        [self.linePath stroke];
        [self drawSymbols:self.symbolDict];
        [self addPoints:self.points withColor:nil];
        [self.completionDashPath stroke];
    }
    
    [self.polygonElements enumerateObjectsUsingBlock:^(NSDictionary *polygonDict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawPolygonWithPolygonDict:polygonDict];
    }];
}

// 绘制已经完成绘制的图形.
-(void)drawPolygonWithPolygonDict:(NSDictionary *)polygonDict
{
    [polygonDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *polygonArray, BOOL * _Nonnull stop) {
        
        NSArray *polygonPoints = polygonArray.firstObject;
        
        UIColor *color = polygonArray.lastObject;
        
        if (![color isKindOfClass:[UIColor class]]) {
            
            color = nil;
        }
        
        UIBezierPath *polygonPath = polygonArray[1];
        
        if (color) {
            
            [color setStroke];
            
        }else
        {
            [[UIColor blackColor] setStroke];
        }
        
        [polygonPath stroke];
        
        [self addPoints:polygonPoints withColor:color];
        
        NSDictionary *polygonSymbolDict = polygonArray[2];
        [self drawSymbols:polygonSymbolDict];
    }];
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
