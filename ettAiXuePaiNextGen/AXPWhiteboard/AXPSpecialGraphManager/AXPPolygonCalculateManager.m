//
//  AXPPolygonCalculateManager.m
//  特殊图形
//
//  Created by Li Kaining on 16/8/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define MIN_VALUE 1e-2
#define kLineMark 10

#import "AXPPolygonCalculateManager.h"

@implementation AXPPolygonCalculateManager


// 获取等边三角形顶点数组
+(NSArray <NSString *>*)getEquilateralTriangleWithPoints:(NSArray <NSString *>*)points
{
    CGPoint A = CGPointFromString(points.firstObject);
    CGPoint B = CGPointFromString(points.lastObject);
    CGPoint C ;
    
    // 边长/半径长
    CGFloat AB = sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
    // AB 中点
    CGPoint centerAB = CGPointMake(A.x + (B.x - A.x)/2, A.y + (B.y - A.y)/2);
    // 过 AB 中点的垂线的长度:
    CGFloat lCD = sqrt(3)*AB/2;
    
    if (A.x == B.x) {
        
        C = CGPointMake(centerAB.x + lCD, centerAB.y);
//        NSLog(@"AB竖直");
        
    }else if (A.y == B.y){
        
        C = CGPointMake(centerAB.x, centerAB.y + lCD);
//        NSLog(@"AB水平");

    }else
    {
        // 直线 AB 的斜率
        CGFloat kAB = (B.y-A.y)/(B.x-A.x);
        
        // AB 垂线的斜率
        CGFloat k = -1/kAB;
        CGFloat b = centerAB.y - k*centerAB.x;
        
//        NSLog(@"kAB:%f k:%f %f ,AB:%f CD:%f",kAB,k,kAB*k,AB,lCD);
        
        CGFloat changeX = sqrt(lCD*lCD/(1+k*k));
        
        CGFloat Xo = centerAB.x + changeX;
        CGFloat Yo = k*Xo + b;
        
//        NSLog(@"changeX:%f b:%f Xo:%f Yo:%f",changeX,b,Xo,Yo);
        
        C = CGPointMake(Xo, Yo);
    }
    
//    CGFloat AC = sqrt((A.x - C.x)*(A.x - C.x) + (A.y - C.y)*(A.y - C.y));
//    CGFloat BC = sqrt((C.x - B.x)*(C.x - B.x) + (C.y - B.y)*(C.y - B.y));
//    
//    NSLog(@"AB:%F AC:%f BC:%f",AB,AC,BC);
    
    NSArray *equilateral = @[NSStringFromCGPoint(A),NSStringFromCGPoint(B),NSStringFromCGPoint(C)];
    
    return equilateral;

}

// 获取直角三角形顶点数组
+(NSArray <NSString *>*)getRightAngleTriangleWithPoints:(NSArray <NSString *>*)points
{
    CGPoint A = CGPointFromString(points.firstObject);
    CGPoint B = CGPointFromString(points[1]);
    CGPoint C = CGPointFromString(points.lastObject);
    
    // 边长/半径长
    CGFloat AB = sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
    // AB 中点
    CGPoint centerAB = CGPointMake(A.x + (B.x - A.x)/2, A.y + (B.y - A.y)/2);

    CGFloat AC = sqrt((A.x - C.x)*(A.x - C.x) + (A.y - C.y)*(A.y - C.y));
    CGFloat BC = sqrt((C.x - B.x)*(C.x - B.x) + (C.y - B.y)*(C.y - B.y));
    
    NSArray *array = [self getRectangleWithThreePoints:points];
    
    if (AC - BC > AB/3)
    {
        return [NSArray arrayWithObjects:array[0],array[1],array[2], nil];
        
    }else if(BC - AC > AB/3)
    {
        return [NSArray arrayWithObjects:array[0],array[1],array[3], nil];
        
    }else
    {
        CGFloat lCD = AB/2;
        
        if (A.x == B.x) {
        
            // Xo 在左边
            if (C.x < A.x) {
                
                lCD = -fabs(lCD);
            }
            
            C = CGPointMake(centerAB.x + lCD, centerAB.y);
            
//            NSLog(@"AB竖直");
            
        }else if (A.y == B.y){
            
            // Yo 在上面
            if (C.y < A.y) {
                
                lCD = -fabs(lCD);
            }
            
            C = CGPointMake(centerAB.x, centerAB.y + lCD);
//            NSLog(@"AB水平");
            
        }else
        {
            // 直线 AB 的斜率
            CGFloat kAB = (B.y-A.y)/(B.x-A.x);
            CGFloat c = A.y - kAB*A.x;
            
            // AB 垂线的斜率
            CGFloat k = -1/kAB;
            CGFloat b = centerAB.y - k*centerAB.x;
            
            CGFloat changeX = sqrt(lCD*lCD/(1+k*k));
            
            CGFloat Xo = centerAB.x + changeX;
            CGFloat Yo = k*Xo + b;
            
            CGFloat Xi = centerAB.x -changeX;
            CGFloat Yi = k*Xi + b;
            
            CGFloat y = kAB*C.x + c;
            
            if (y > C.y) {
                
                if (Yi < Yo) {
                    C = CGPointMake(Xi, Yi);
                    
                }else
                {
                    C = CGPointMake(Xo, Yo);
                }
                
            }else
            {
                if (Yi < Yo) {
                   C = CGPointMake(Xo, Yo);
                    
                }else
                {
                    C = CGPointMake(Xi, Yi);
                }
            }
        }
        
        return [NSArray arrayWithObjects:array[0],array[1],NSStringFromCGPoint(C), nil];
    }
}

// 添加直角三角形的直角标识
+(UIBezierPath *)addRightAngleMarkWithTrianglePoints:(NSArray <NSString *>*)triangleApex
{
    // 按顺序取出三个点的坐标
    CGPoint A = CGPointFromString(triangleApex.firstObject);
    CGPoint B = CGPointFromString(triangleApex[1]);
    CGPoint C = CGPointFromString(triangleApex.lastObject);
    
    // 求出直线的斜率
    CGFloat kAB = (B.y-A.y)/(B.x-A.x);
    CGFloat kAC = (C.y-A.y)/(C.x-A.x);
    CGFloat kBC = (C.y-B.y)/(C.x-B.x);
    
    NSArray *rightAngleTriangle;
    NSInteger rightAngleApexIndex;
    
//    NSLog(@"%f",MIN_VALUE);
    
    // 找出直角
    if (fabs(kAB*kAC+1) < MIN_VALUE) {
    
        rightAngleApexIndex = 0;
        rightAngleTriangle = [NSArray arrayWithObjects:triangleApex.lastObject,triangleApex.firstObject,triangleApex[1], nil];
        
    }else if (fabs(kAB*kBC+1) < MIN_VALUE)
    {
        rightAngleApexIndex = 1;
        rightAngleTriangle = triangleApex;
        
    }else if (fabs(kAC*kBC+1) < MIN_VALUE)
    {
        rightAngleApexIndex = 2;
        rightAngleTriangle = [NSArray arrayWithObjects:triangleApex.firstObject,triangleApex.lastObject,triangleApex[1], nil];
        
    }else
    {
//        NSLog(@"这个三角形不是直角三角形");
        
        return nil;
    }
    
    // 1.求出直角角平分线上的一个直角标识点
    CGPoint symbolPoint = [self getTriangleApexSymbolPointWithTriangleApex:rightAngleTriangle];
    
    CGPoint rightAngleApex = CGPointFromString(triangleApex[rightAngleApexIndex]);
    CGFloat changeX = symbolPoint.x-rightAngleApex.x;
    CGFloat changeY = symbolPoint.y-rightAngleApex.y;
    
    CGPoint rightAnglePoint = CGPointMake(rightAngleApex.x-changeX, rightAngleApex.y-changeY);
    
    // 2. 求出垂直于两条直角边的标记点
    CGPoint leftPoint = [self getVerticalIntersectPointWithlinePointA:rightAngleApex linePointB:CGPointFromString(rightAngleTriangle.firstObject) andArbitraryPoint:rightAnglePoint];
    
    CGPoint rightPoint = [self getVerticalIntersectPointWithlinePointA:rightAngleApex linePointB:CGPointFromString(rightAngleTriangle.lastObject) andArbitraryPoint:rightAnglePoint];
    
    UIBezierPath *rightAngleMarkPath = [UIBezierPath bezierPath];
    
    [rightAngleMarkPath moveToPoint:leftPoint];
    [rightAngleMarkPath addLineToPoint:rightAnglePoint];
    [rightAngleMarkPath addLineToPoint:rightPoint];
    
    return rightAngleMarkPath;
}


// 获取等腰三角形顶点数组
+(NSArray <NSString *>*)getIsoscelesTriangleWithPoints:(NSArray <NSString *>*)triangleApex
{
    // 1. 先判断哪条边是底边,哪两条边是腰
    
    // 按顺序取出三个点的坐标
    CGPoint A = CGPointFromString(triangleApex.firstObject);
    CGPoint B = CGPointFromString(triangleApex[1]);
    CGPoint C = CGPointFromString(triangleApex.lastObject);
    
    // 求出三条边的长度
    CGFloat AB = sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
    CGFloat AC = sqrt((A.x - C.x)*(A.x - C.x) + (A.y - C.y)*(A.y - C.y));
    CGFloat BC = sqrt((C.x - B.x)*(C.x - B.x) + (C.y - B.y)*(C.y - B.y));
    
    // 计算三条边的差值
    CGFloat a = fabs(AB-AC);
    CGFloat b = fabs(BC-AB);
    CGFloat c = fabs(AC-BC);
    
    if (a < MIN_VALUE || b < MIN_VALUE || c < MIN_VALUE) {
        
        // 添加等腰标识
//        NSLog(@"添加等腰标识");
        return triangleApex;
    }
    
    // 三条边的差值排序,找到差值最小的两条边作为等腰三角形的腰
    
    // 2. 根据顶点和腰,计算第三个点的坐标.
    
    // AB 中点
    CGPoint centerAB = CGPointMake(A.x + (B.x - A.x)/2, A.y + (B.y - A.y)/2);
    CGFloat kAB = (B.y-A.y)/(B.x-A.x);
    CGFloat kCD = -1/kAB;
    CGFloat cd = centerAB.y - kCD*centerAB.x;
    
    CGFloat kAC = (C.y-A.y)/(C.x-A.x);
    CGFloat ac = A.y - kAC*A.x;
    
    CGFloat kBC = (B.y-C.y)/(B.x-C.x);
    CGFloat bc = B.y - kBC*B.x;
    
    
    CGFloat apex ,changeX ,Xc ,Yc;
    
    if (a <= b && a <= c) {
    
        apex = 0;
        
        if (A.x == C.x) { // AC 竖直
            
            if (A.y < C.y) { // C点在下面
                
                Xc = A.x;
                Yc = A.y + AB;
                
            }else // C点在上面
            {
                Xc = A.x;
                Yc = A.y - AB;
            }
            
        }else if (A.y == C.y) // AC水平
        {
            if (A.x < C.x) { // C 点在右边
            
                Xc = A.x + AB;
                Yc = A.y;
                
            }else // C 点在左边
            {
                Xc = A.x - AB;
                Yc = A.y;
            }
            
        }else if (C.x < A.x) {
        
            changeX = sqrt(AB*AB/(1+kAC*kAC));
            changeX = -changeX;
            
            Xc = A.x + changeX;
            Yc = kAC*Xc + ac;
        }else
        {
            changeX = sqrt(AB*AB/(1+kAC*kAC));
            
            Xc = A.x + changeX;
            Yc = kAC*Xc + ac;
        }
    }
    else if (b <= a && b <= c)
    {
        apex = 0;
        
        if (B.x == C.x) { // AC 竖直
            
            if (B.y < C.y) { // C点在下面
                
                Xc = B.x;
                Yc = B.y + AB;
                
            }else // C点在上面
            {
                Xc = B.x;
                Yc = B.y - AB;
            }
            
        }else if (B.y == C.y) // AC水平
        {
            if (B.x < C.x) { // C 点在右边
                
                Xc = B.x + AB;
                Yc = B.y;
                
            }else // C 点在左边
            {
                Xc = B.x - AB;
                Yc = B.y;
            }
            
        }else if (C.x < B.x) {
            
            changeX = sqrt(AB*AB/(1+kBC*kBC));
            changeX = -changeX;
            
            Xc = B.x + changeX;
            Yc = kBC*Xc + bc;
            
        }else
        {
            changeX = sqrt(AB*AB/(1+kBC*kBC));
            
            Xc = B.x + changeX;
            Yc = kBC*Xc + bc;
        }
        
    }else if (c <= a && c <= b)
    {
        apex = 2;
        
        if (A.x == B.x) {
            
            Xc = C.x;
            Yc = centerAB.y;
            
        }else if (A.y == B.y)
        {
            Xc = C.x;
            Yc = C.y;
        }else
        {
            CGFloat temX = centerAB.x +1;
            CGFloat temY = kCD*temX + cd;
            
            CGPoint point = CGPointMake(temX, temY);
            
            CGPoint vertical = [self getVerticalIntersectPointWithlinePointA:centerAB linePointB:point andArbitraryPoint:C];
            
//            NSLog(@"vertical:%@",NSStringFromCGPoint(vertical));
            
            Xc = vertical.x;
            Yc = vertical.y;
        }
    }
    
    C = CGPointMake(Xc, Yc);
    
    NSArray *isoscelesTriangle = @[NSStringFromCGPoint(A),NSStringFromCGPoint(B),NSStringFromCGPoint(C)];
    
    return isoscelesTriangle;
}

// 添加等腰三角形的腰标识
+(NSArray <UIBezierPath *>*)addIsoscelesTriangleMarkWithPoints:(NSArray <NSString *>*)triangleApex
{
    NSMutableArray *array = [NSMutableArray array];
    
    // 判断给定的三角形是否是等腰(等边)三角形
    
    // 按顺序取出三个点的坐标
    CGPoint A = CGPointFromString(triangleApex.firstObject);
    CGPoint B = CGPointFromString(triangleApex[1]);
    CGPoint C = CGPointFromString(triangleApex.lastObject);
    
    // 求出三条边的长度
    CGFloat AB = sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
    CGFloat AC = sqrt((A.x - C.x)*(A.x - C.x) + (A.y - C.y)*(A.y - C.y));
    CGFloat BC = sqrt((C.x - B.x)*(C.x - B.x) + (C.y - B.y)*(C.y - B.y));
    
    // 计算三条边的差值
    CGFloat a = fabs(AB-AC);
    CGFloat b = fabs(BC-AB);
    CGFloat c = fabs(AC-BC);
    
//    NSLog(@"a:%f b:%f c:%f",a,b,c);
    
    if (a < MIN_VALUE) { // 以 A 为顶点的等腰三角形
        
        UIBezierPath *pathAB = [self addLineMarkWithLinePointA:A linePointB:B];
        UIBezierPath *pathAC = [self addLineMarkWithLinePointA:A linePointB:C];
        
        [array addObject:pathAB];
        [array addObject:pathAC];
        
    }else if (b < MIN_VALUE) // 以 B 为顶点的等腰三角形
    {
        UIBezierPath *pathAB = [self addLineMarkWithLinePointA:A linePointB:B];
        UIBezierPath *pathBC = [self addLineMarkWithLinePointA:B linePointB:C];
        
        [array addObject:pathAB];
        [array addObject:pathBC];
        
    }else if (c < MIN_VALUE) // 以 C 为顶点的等腰三角形
    {
        UIBezierPath *pathAC = [self addLineMarkWithLinePointA:A linePointB:C];
        UIBezierPath *pathBC = [self addLineMarkWithLinePointA:B linePointB:C];
        
        [array addObject:pathAC];
        [array addObject:pathBC];
        
    }else if (a < MIN_VALUE && b < MIN_VALUE && c < MIN_VALUE ) // 等边三角形
    {
        UIBezierPath *pathAB = [self addLineMarkWithLinePointA:A linePointB:B];
        UIBezierPath *pathAC = [self addLineMarkWithLinePointA:A linePointB:C];
        UIBezierPath *pathBC = [self addLineMarkWithLinePointA:B linePointB:C];
        
        [array addObject:pathAB];
        [array addObject:pathAC];
        [array addObject:pathBC];
        
    }else
    {
//        NSLog(@"这个三角形不是等腰(边)三角形!");
    }
    
    return array;
}

+(UIBezierPath *)addLineMarkWithLinePointA:(CGPoint)pointA linePointB:(CGPoint)pointB
{
    CGPoint startPoint , endPoint;
    
    CGPoint centerAB = CGPointMake(pointA.x + (pointB.x - pointA.x)/2, pointA.y + (pointB.y - pointA.y)/2);
    
    if (pointA.x == pointB.x) {
    
        startPoint = CGPointMake(centerAB.x - kLineMark/2, centerAB.y);
        endPoint = CGPointMake(centerAB.x + kLineMark/2, centerAB.y);
        
    }else if (pointA.y == pointB.y)
    {
        startPoint = CGPointMake(centerAB.x, centerAB.y - kLineMark/2);
        endPoint = CGPointMake(centerAB.x, centerAB.y+kLineMark/2);
        
    }else
    {
        CGFloat kAB = (pointB.y-pointA.y)/(pointB.x-pointA.x);
        CGFloat k = -1/kAB;
        CGFloat b = centerAB.y - k*centerAB.x;
        
        CGFloat changeX = sqrt(kLineMark*kLineMark/(1+k*k));
        
        CGFloat Xo = centerAB.x-changeX/2;
        CGFloat Yo = k*Xo + b;
        
        CGFloat Xi = centerAB.x+changeX/2;
        CGFloat Yi = k*Xi + b;
        
        startPoint = CGPointMake(Xo, Yo);
        endPoint = CGPointMake(Xi, Yi);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    return path;
}

// 获取正方形
+(NSArray <NSString *>*)getSquareWithPoints:(NSArray <NSString *>*)points
{
    CGPoint A = CGPointFromString(points.firstObject);
    CGPoint B = CGPointFromString(points.lastObject);
    
    CGFloat lAB = (A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y);
    CGFloat kAB = (B.y-A.y)/(B.x-A.x);
    CGFloat k = -1.0/kAB;
    
    CGFloat changeX = sqrt(lAB/(1+k*k));
    CGFloat changeY = k*changeX;
    
    CGPoint C = CGPointMake(B.x + changeX, B.y+changeY);
    CGPoint D = CGPointMake(A.x + changeX, A.y+changeY);
    
    NSArray *array = @[NSStringFromCGPoint(A),NSStringFromCGPoint(B),NSStringFromCGPoint(C),NSStringFromCGPoint(D)];
    
    return array;
}

// 获取平行四边形
+(NSArray <NSString *>*)getParallelogramWithPoints:(NSArray <NSString *>*)points
{
    CGPoint A = CGPointFromString(points.firstObject);
    CGPoint B = CGPointFromString(points[1]);
    CGPoint C = CGPointFromString(points.lastObject);
    
    CGFloat changeX = C.x-B.x;
    CGFloat changeY = C.y-B.y;
    
    CGPoint D = CGPointMake(A.x+changeX, A.y+changeY);
    
    NSArray *array = @[NSStringFromCGPoint(A),NSStringFromCGPoint(B),NSStringFromCGPoint(C),NSStringFromCGPoint(D)];
    
    return array;
}

// 获取长方形
+(NSArray <NSString *>*)getRectangleWithThreePoints:(NSArray <NSString *>*)points
{
    NSArray *parallelogram = [self getParallelogramWithPoints:points];
    
    CGPoint A = CGPointFromString(parallelogram.firstObject);
    CGPoint B = CGPointFromString(parallelogram[1]);
    
    CGPoint E = CGPointFromString(parallelogram[2]);
    CGPoint F = CGPointFromString(parallelogram.lastObject);
    
    CGPoint C , D;
    
    if (A.x == B.x) { //第一条直线竖直
        
        C = CGPointMake(E.x, B.y);
        D = CGPointMake(F.x, A.y);
    }
    else if (A.y == B.y) { //第一条直线水平
        
        C = CGPointMake(B.x, E.y);
        D = CGPointMake(A.x, F.y);
    }
    else
    {
        
        C = [self getVerticalIntersectPointWithlinePointA:E linePointB:F andArbitraryPoint:B];
        
        CGFloat changeX = C.x - B.x;
        CGFloat changeY = C.y - B.y;
        
        D = CGPointMake(A.x+changeX, A.y+changeY);

    }
    
    NSArray *rectangle = @[NSStringFromCGPoint(A),NSStringFromCGPoint(B),NSStringFromCGPoint(C),NSStringFromCGPoint(D)];
    
    return rectangle;
}

// 任意点到已知直线垂线和直线的交点(垂足)坐标
+(CGPoint)getVerticalIntersectPointWithlinePointA:(CGPoint)pointA linePointB:(CGPoint)pointB andArbitraryPoint:(CGPoint)pointC
{
    CGFloat kAB = (pointB.y-pointA.y)/(pointB.x-pointA.x);
    CGFloat b = pointB.y - kAB*pointB.x;
    
    CGFloat kCD = -1.0/kAB;
    CGFloat c = pointC.y - kCD*pointC.x;
    
    CGFloat X = (c-b)/(kAB-kCD);
    CGFloat Y = kAB*X + b;
    
    CGPoint verticalIntersectPoint = CGPointMake(X, Y);
    
    return verticalIntersectPoint;
}

+(NSArray <NSString *>*)getPolygonSymbolWithPolygon:(NSArray <NSString *>*)polygon
{
    NSMutableArray *symbolArray = [NSMutableArray array];
    
    // 分割数组(分割成三角形数组)
    for (int i = 0 ; i < polygon.count; i++) {
    
        if (i == 0) {// 第一个点
        
            NSArray *array = [NSArray arrayWithObjects:polygon[polygon.count-1],polygon[i],polygon[i+1], nil];
            
            CGPoint startPoint = [self getTriangleApexSymbolPointWithTriangleApex:array];
            
            [symbolArray addObject:NSStringFromCGPoint(startPoint)];
            
        }else if(i == polygon.count -1)// 最后一个点
        {
            NSArray *array = [NSArray arrayWithObjects:polygon[i-1],polygon[i],polygon[0], nil];
            
            CGPoint endPoint = [self getTriangleApexSymbolPointWithTriangleApex:array];
            
            [symbolArray addObject:NSStringFromCGPoint(endPoint)];
            
        }else
        {
            NSArray *array = [NSArray arrayWithObjects:polygon[i-1],polygon[i],polygon[i+1], nil];
            
            CGPoint midPoint = [self getTriangleApexSymbolPointWithTriangleApex:array];
            
            [symbolArray addObject:NSStringFromCGPoint(midPoint)];
        }
    }
    
    return symbolArray;
}

+(CGPoint)getTriangleApexSymbolPointWithTriangleApex:(NSArray <NSString *>*)triangleApex
{
    NSArray *array = [self getTriangleSymbolPointWithTriangleApex:triangleApex];
    
    NSString *symbolPointStr = array[1];

    return CGPointFromString(symbolPointStr);
}


+(NSArray <NSString *>*)getLineSymbolPointWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    // 1.求出直线的斜率
    CGFloat k = (endPoint.y-startPoint.y)/(startPoint.x-endPoint.x);
//    NSLog(@"------------k:%f",k);
    
    // 计算偏移量
    CGFloat changeX = sqrt((kSymbolMargin*kSymbolMargin)/(1+k*k));
    CGFloat changeY = k*changeX;
    
//    NSLog(@"changeX:%f changeY:%f",changeX,changeY);
    
    CGPoint startSymbolPoint,endSymbolPoint;
    
    // 垂直
    if (startPoint.x == endPoint.x) {
        
        if (startPoint.y > endPoint.y) {
            
            startSymbolPoint = CGPointMake(startPoint.x,startPoint.y + kSymbolMargin);
            
            endSymbolPoint = CGPointMake(endPoint.x, endPoint.y - kSymbolMargin);
            
        }else
        {
            startSymbolPoint = CGPointMake(startPoint.x, startPoint.y - kSymbolMargin);
            
            endSymbolPoint = CGPointMake(endPoint.x, endPoint.y + kSymbolMargin);
        }
    // 起始点在左边
    }else if (startPoint.x < endPoint.x) {
    
        startSymbolPoint = CGPointMake(startPoint.x - changeX, startPoint.y + changeY);
        
        endSymbolPoint = CGPointMake(endPoint.x + changeX, endPoint.y -changeY);
    // 起始点在右边
    }else
    {
        startSymbolPoint = CGPointMake(startPoint.x + changeX, startPoint.y - changeY);
        
        endSymbolPoint = CGPointMake(endPoint.x - changeX, endPoint.y + changeY);
    }
    
    NSArray *array = [NSArray arrayWithObjects:NSStringFromCGPoint(startSymbolPoint),NSStringFromCGPoint(endSymbolPoint), nil];
    
    return array;
}

+(NSArray <NSString *>*)getTriangleSymbolPointWithTriangleApex:(NSArray <NSString *>*)triangleApex
{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *intersectionPoints = [self getTriangleIntersectionPointWithTriangleApex:triangleApex];
    
    for (int i = 0; i < triangleApex.count; i++) {
        
        CGPoint apexPoint = CGPointFromString(triangleApex[i]);
        CGPoint interPoint = CGPointFromString(intersectionPoints[i]);
        
        CGPoint symbolPoint = [self getSymbolPointWithAngleApex:apexPoint andIntersectionPoint:interPoint];
        
        NSString *symbolStr = NSStringFromCGPoint(symbolPoint);
        
        [array addObject:symbolStr];
    }
    
    return array;
}


+(NSArray <NSString *>*)getTriangleIntersectionPointWithTriangleApex:(NSArray <NSString *>*)triangleApex
{
    // 保证三个角是逆时针排列
    
    // 按顺序取出三个点的坐标
    CGPoint A = CGPointFromString(triangleApex.firstObject);
    CGPoint B = CGPointFromString(triangleApex[1]);
    CGPoint C = CGPointFromString(triangleApex.lastObject);
    
    // 求出三角形各个边的长度:
    CGFloat AB = sqrt((A.x - B.x)*(A.x - B.x) + (A.y - B.y)*(A.y - B.y));
    CGFloat AC = sqrt((A.x - C.x)*(A.x - C.x) + (A.y - C.y)*(A.y - C.y));
    CGFloat BC = sqrt((C.x - B.x)*(C.x - B.x) + (C.y - B.y)*(C.y - B.y));
    
    // 求过 顶点A 的角平分线与对边的交点坐标
    CGFloat changeX1 = (B.x - C.x)/(1 + AB/AC);
    CGFloat changeY1 = (B.y - C.y)/(1 + AB/AC);
    
    CGPoint D = CGPointMake(C.x+changeX1, C.y+changeY1);
    
    // 求过 顶点B 的角平分线与对边的交点坐标
    CGFloat changeX2 = (A.x - C.x)/(1 + AB/BC);
    CGFloat changeY2 = (A.y - C.y)/(1 + AB/BC);
    
    CGPoint E = CGPointMake(C.x+changeX2, C.y+changeY2);
    
    // 求过 顶点C 的角平分线与对边的交点坐标
    CGFloat changeX3 = (B.x - A.x)/(1 + BC/AC);
    CGFloat changeY3 = (B.y - A.y)/(1 + BC/AC);
    
    CGPoint F = CGPointMake(A.x+changeX3, A.y+changeY3);
    
    NSString *strD = NSStringFromCGPoint(D);
    NSString *strE = NSStringFromCGPoint(E);
    NSString *strF = NSStringFromCGPoint(F);

    NSArray *array = [NSArray arrayWithObjects:strD,strE,strF, nil];
    
    return array;
}

+(CGPoint)getSymbolPointWithAngleApex:(CGPoint)angleApex andIntersectionPoint:(CGPoint)focusPoint
{
    if (angleApex.x == focusPoint.x) {
    
        CGPoint symbolPoint;
    
        if (angleApex.y < focusPoint.y) {
        
            symbolPoint = CGPointMake(angleApex.x, angleApex.y-kSymbolMargin);
            
        }else
        {
            symbolPoint = CGPointMake(angleApex.x, angleApex.y+kSymbolMargin);
        }

        return symbolPoint;
    }

    // 获取角平分线的 k 值
    CGFloat k = (angleApex.y-focusPoint.y)/(focusPoint.x-angleApex.x);
    
    // 计算偏移量
    CGFloat changeX = sqrt((kSymbolMargin*kSymbolMargin)/(1+k*k));
    CGFloat changeY = k*changeX;
    
    // 确定往角平分线的哪个方向做延长线
    if (angleApex.y > focusPoint.y) {
        
        if (k > 0) {
            changeX = -changeX;
        }else
        {
            changeY = -changeY;
        }
    }else
    {
        if (k < 0) {
            changeX = -changeX;
        }else
        {
            changeY = -changeY;
        }
    }
    
    CGPoint symbolPoint = CGPointMake(angleApex.x+changeX, angleApex.y+changeY);
    
    return symbolPoint;
}

+(BOOL)touchPoint:(CGPoint)touchPoint inLine:(NSArray <NSString *>*)line
{
    CGPoint A = CGPointFromString(line.firstObject);
    CGPoint B = CGPointFromString(line.lastObject);
    
    CGFloat k = (A.y - B.y)/(A.x - B.x);
    
    CGFloat b = A.y - k*A.x;
    
    CGFloat c = k*touchPoint.x + b;
    
//    NSLog(@"c1:%f c2:%f 绝对值:%f",c,touchPoint.y,fabs(c - touchPoint.y));
    
    if (fabs(c - touchPoint.y) <= 15) {
        return YES;
        
    }else{
        return NO;
    }
}

+(BOOL)touchPoint:(CGPoint)touchPoint inCircle:(NSArray <NSString *>*)circle
{
    CGPoint circleCenter = CGPointFromString(circle.firstObject);
    
    CGPoint pointR = CGPointFromString(circle.lastObject);
    
    CGFloat r = sqrt((circleCenter.x - pointR.x)*(circleCenter.x - pointR.x) + (circleCenter.y - pointR.y)*(circleCenter.y - pointR.y));
    
    CGFloat l = sqrt((circleCenter.x - touchPoint.x)*(circleCenter.x - touchPoint.x) + (circleCenter.y - touchPoint.y)*(circleCenter.y - touchPoint.y));
    
    return r >= l ? YES :NO;
}

+(BOOL)touchPoint:(CGPoint)touchPoint InPolygon:(NSArray <NSString *>*)polygon explan:(NSString *)explanStr
{
    if ([explanStr hasPrefix:@"直线"]) {
        
//        NSLog(@"这是直线");
        return [self touchPoint:touchPoint inLine:polygon];
        
    }else if(polygon.count == 2)
    {
//        NSLog(@"这是圆");
        return [self touchPoint:touchPoint inCircle:polygon];
        
    }else
    {
        // 第一次判断
        BOOL is_YES = [self firstCaculateWithPoint:touchPoint andArray:polygon];
        
        if (!is_YES) return NO ;
        
        // 接下来,需要判断经过击点的直线与多边形边的交点: 奇数个:在多边形内; 偶数个:不在多边形内.
        
        int count = 0;
        
        // 取出多边形中的直线
        for (int i = 0; i < polygon.count; i++) {
            
            if (i < polygon.count -1) {
                
                CGPoint point1 = CGPointFromString(polygon[i]);
                CGPoint point2 = CGPointFromString(polygon[i+1]);
                
                // 将 touchPont 的 X 轴延长判断是否相交
                if ([self isHasIntersectionPointWithTouchPoint:touchPoint andLinePoint1:point1 linePoint2:point2]) {
                    
                    count ++;
                }
                
            }else
            {
                // 最后一条直线
                CGPoint firstPoint = CGPointFromString(polygon[0]);
                CGPoint endPoint = CGPointFromString(polygon[i]);
                
                // 将 touchPont 的 X 轴延长判断是否相交
                if ([self isHasIntersectionPointWithTouchPoint:touchPoint andLinePoint1:firstPoint linePoint2:endPoint]) {
                    
                    count ++;
                }
            }
        }
        
        if (count%2 == 1) {
            
//            NSLog(@"点击点:%@ 在这个多边形内!",NSStringFromCGPoint(touchPoint));
            
            return YES;
            
        }else
        {
//            NSLog(@"点击点:%@ 不在这个多边形内!",NSStringFromCGPoint(touchPoint));
            return NO;
        }
    }
}

+(BOOL)isHasIntersectionPointWithTouchPoint:(CGPoint)touchPoint andLinePoint1:(CGPoint)point1 linePoint2:(CGPoint)point2
{
    // 将 touchPont 的 X 轴延长判断是否相交
    CGFloat x = (touchPoint.y - point1.y)*(point2.x - point1.x)/(point2.y - point1.y) + point1.x;
    
    CGFloat maxX,maxY,minX,minY;
    
    if (point1.x > point2.x) {
    
        maxX = point1.x;
        minX = point2.x;
        
    }else
    {
        maxX = point2.x;
        minX = point1.x;
    }
    
    if (point1.y > point2.y) {
        
        maxY = point1.y;
        minY = point2.y;
        
    }else
    {
        maxY = point2.y;
        minY = point1.y;
    }
    
    if (x <= touchPoint.x && touchPoint.y >= minY && touchPoint.y <= maxY) {
    
        return YES;
        
    }else
    {
        return NO;
    }
    
}


+(BOOL)firstCaculateWithPoint:(CGPoint)touchPoint andArray:(NSArray <NSString *>*)array
{
    // 1. 取出数组中多边形的点;求出最大和最小的x,y值.
    CGFloat maxX = 0.0 ,maxY = 0.0 ,minX = 0.0 ,minY = 0.0;
    
    CGRect rect = [self getPolygonMinRectWithPolygon:array];
    
    minX = rect.origin.x;
    minY = rect.origin.y;
    maxX = rect.origin.x + rect.size.width;
    maxY = rect.origin.y + rect.size.height;
    
    // 初步判断 触摸点 是否在多边形内.
    BOOL is_YES = (touchPoint.x > minX && touchPoint.x < maxX) && (touchPoint.y > minY && touchPoint.y < maxY) ? YES : NO;
    
//    NSLog(@"is_YES:%zd",is_YES);
    
    if (!is_YES) {
//        NSLog(@"差距太大了,不在图形内!");
    }
    
    // 如果第一次判断通过,再进行第二次判断,否则直接返回.
    return is_YES;
}

+(CGRect)getPolygonMinRectWithPolygon:(NSArray *)polygon explan:(NSString *)explanStr
{
    if ([explanStr hasPrefix:@"直线"]) {
        
        return [self getPolygonMinRectWithPolygon:polygon];
        
    }else if(polygon.count == 2)
    {
        //NSLog(@"这是圆");
        CGPoint circleCenter = CGPointFromString(polygon.firstObject);
        CGPoint radiusPoint = CGPointFromString(polygon.lastObject);
        
        CGPoint point;
        point.x = 2*circleCenter.x - radiusPoint.x;
        point.y = 2*circleCenter.y - radiusPoint.y;
        
        NSArray *array = @[polygon.firstObject,polygon.lastObject,NSStringFromCGPoint(point)];
        
        return [self getPolygonMinRectWithPolygon:array];
        
    }else
    {
        return [self getPolygonMinRectWithPolygon:polygon];
    }
}


+(CGRect)getPolygonMinRectWithPolygon:(NSArray *)polygon
{
    // 1. 取出数组中多边形的点;求出最大和最小的x,y值.
    CGFloat maxX = 0.0 ,maxY = 0.0 ,minX = 0.0 ,minY = 0.0;
    
    // 获取最大/最小的X值
    NSArray *arrayX = [polygon sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //
        NSString *pointStr1 = obj1;
        NSString *pointStr2 = obj2;
        
        CGPoint point1 = CGPointFromString(pointStr1);
        CGPoint point2 = CGPointFromString(pointStr2);
        
        if (point1.x < point2.x) {
            
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
    }];
    
    maxX = CGPointFromString(arrayX.firstObject).x;
    minX = CGPointFromString(arrayX.lastObject).x;
    
    // 获取最大和最小的Y值
    NSArray *arrayY = [polygon sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //
        NSString *pointStr1 = obj1;
        NSString *pointStr2 = obj2;
        
        CGPoint point1 = CGPointFromString(pointStr1);
        CGPoint point2 = CGPointFromString(pointStr2);
        
        if (point1.y < point2.y) {
            
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
    }];
    
    maxY = CGPointFromString(arrayY.firstObject).y;
    minY = CGPointFromString(arrayY.lastObject).y;
    
    CGRect rect = CGRectMake(minX, minY, maxX-minX, maxY-minY);
    
    return rect;
}

+(NSArray *)getPinchPolygonWithOriginalPolygon:(NSArray *)polygon andPinchedFrame:(CGRect)frame
{
    // 获得特殊图形的最小 frame.
    CGRect originalFrame = [self getPolygonMinRectWithPolygon:polygon];
    
    CGFloat originX = originalFrame.origin.x;
    CGFloat originY = originalFrame.origin.y;
    CGFloat originW = originalFrame.size.width;
    CGFloat originH = originalFrame.size.height;
    
    // 计算原始特殊图形的点相对于原始frame的位置.
    NSMutableArray *kArray = [NSMutableArray array];
    [polygon enumerateObjectsUsingBlock:^(NSString *pointStr, NSUInteger idx, BOOL * _Nonnull stop) {

        CGPoint point = CGPointFromString(pointStr);
        
        point.x -= originX;
        point.y -= originY;
        
        CGFloat kx = point.x/originW;
        CGFloat ky = point.y/originH;
        
        CGPoint kPoint = CGPointMake(kx, ky);
        [kArray addObject:NSStringFromCGPoint(kPoint)];
    }];
    
    CGFloat presentX = frame.origin.x;
    CGFloat presentY = frame.origin.y;
    CGFloat presentW = frame.size.width;
    CGFloat presentH = frame.size.height;
    
    NSMutableArray *presentPolygon = [NSMutableArray array];
    
    [kArray enumerateObjectsUsingBlock:^(NSString *kpointStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint kPoint = CGPointFromString(kpointStr);
        
        CGFloat X = kPoint.x *presentW + presentX;
        CGFloat Y = kPoint.y *presentH + presentY;
        
        CGPoint presentPoint = CGPointMake(X, Y);
        
        [presentPolygon addObject:NSStringFromCGPoint(presentPoint)];
    }];
    
    return presentPolygon;
}

+(NSArray *)getCirclePinchPointWithCircle:(NSArray *)circle pinchedFrame:(CGRect)frame;
{
    CGPoint circleCenter = CGPointFromString(circle.firstObject);
    CGPoint radiusPoint = CGPointFromString(circle.lastObject);
    
    CGPoint point;
    
    point.x = 2*circleCenter.x - radiusPoint.x;
    point.y = 2*circleCenter.y - radiusPoint.y;
    
    NSArray *polygon = @[circle.firstObject,circle.lastObject,NSStringFromCGPoint(point)];
    
    NSArray *array = [self getPinchPolygonWithOriginalPolygon:polygon andPinchedFrame:frame];
    
    NSArray *circleArray = @[array.firstObject,array[1]];
    
    return circleArray;
}

@end
