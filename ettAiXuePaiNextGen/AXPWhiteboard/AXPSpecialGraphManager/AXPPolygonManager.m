//
//  AXPPolygonManager.m
//  特殊图形
//
//  Created by Li Kaining on 16/8/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#define kLineCounts 2
#define kTriangleCounts 3

#import "AXPPolygonManager.h"
#import "AXPPolygonCalculateManager.h"



typedef void(^publickBlock)(NSArray *points,NSInteger polygonSides);

@interface AXPPolygonManager ()

@property(nonatomic ,copy)completionBlock completion;
@property(nonatomic ,copy)drawPathBlock drawPath;
@property(nonatomic ,copy)completionDashBlock dashPath;

// 标注名称: A~Z /追加1:A1~Z1 /追加2:A2~Z2 /追加3:A3~Z3 ...
@property(nonatomic ,strong) NSMutableArray *symbolName;

// 文字属性
@property(nonatomic ,strong) NSMutableDictionary *textAttributes;

// 射线标注点内容/位置
@property(nonatomic ,strong) NSMutableDictionary *raySymbols;


@property(nonatomic) NSInteger currentPolygonSides;


@property(nonatomic ,strong) NSMutableArray *currentPolygonsPoints;


@property(nonatomic ,strong) NSMutableArray *polygon;

@property(nonatomic) BOOL isFinishedDone;
@property(nonatomic ,strong) UIView *drawRectView;
@property(nonatomic) NSInteger currentPolygonPointIndex;

@property(nonatomic ,copy) publickBlock publick;

@end

@implementation AXPPolygonManager

#pragma mark -- 功能方法

// 添加直线
-(void)addLineAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;

    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+2 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    [self addPoints:self.points];
    [self.symbols addObject:self.symbolName[self.currentIndex + self.points.count -1]];
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        self.polygon = self.points;
        // 添加直线标记(注意只有一个点)
        [self addLineSymbolWithLinePoints:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        self.currentIndex +=2;
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
    }
    
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];

}

// 添加射线
-(void)addRayLineAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+1 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
    
        [self.polygon addObject:self.points.lastObject];
        [self.symbols addObject:self.symbolName[self.currentIndex]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        // 添加直线标记(注意只有一个点)
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.raySymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=1;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加任意三角形
-(void)addTriangleAndSymbolmarkWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+3 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
        
        [polygonPath addLineToPoint:currentPoint];
        [polygonPath closePath];
        
        self.polygon = self.points;
        
        [self addTriangleSymbolWithTriangleApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=3;
    }
    
//    if (drawPath) {
//        drawPath(self.linePaths.firstObject,self.polygonSymbols);
//    }
    

    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加等腰三角形
-(void)addIsoscelesTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+3 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
    
        [self.linePaths addObject:polygonPath];
    
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
    
        [self addPoints:self.points];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
    
        self.polygon = [AXPPolygonCalculateManager getIsoscelesTriangleWithPoints:self.points].mutableCopy;
        
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addTriangleSymbolWithTriangleApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [AXPPolygonManager addRigthAngleMarkAndIsoscelesMarkWithTriangleApexs:self.polygon andPath:polygonPath];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=3;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加直角三角形
-(void)addRightAngleTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+3 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        [self addPoints:self.points];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
        
        self.polygon = [AXPPolygonCalculateManager getRightAngleTriangleWithPoints:self.points].mutableCopy;
        
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addTriangleSymbolWithTriangleApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [AXPPolygonManager addRigthAngleMarkAndIsoscelesMarkWithTriangleApexs:self.polygon andPath:polygonPath];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=3;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加等边三角形
-(void)addEquilateralTriangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+3 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else { // 第二个点
        
        self.polygon = [AXPPolygonCalculateManager getEquilateralTriangleWithPoints:self.points].mutableCopy;
        
        [polygonPath addLineToPoint:CGPointFromString(self.polygon[1])];
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count]];
        [self addTriangleSymbolWithTriangleApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=3;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加圆
-(void)addArcWithDiameterPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+1 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    [self.points addObject:points.lastObject];
    [self addPoints:self.points];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    if (self.points.count == 1) {
    
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        [self.linePaths addObject:polygonPath];
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        
        // 添加单点标注
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbolName[self.currentIndex] toDicts:self.polygonSymbols];
    }else
    {
        CGPoint circleCenter = CGPointFromString(self.points.firstObject);
        
        CGFloat lo = sqrt((circleCenter.x - currentPoint.x)*(circleCenter.x - currentPoint.x) + (circleCenter.y - currentPoint.y)*(circleCenter.y - currentPoint.y));
        
        // 以第一个点为圆心,两点之间的距离为半径,添加圆
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:circleCenter radius:lo startAngle:0 endAngle:2*M_PI clockwise:YES];
        [self.linePaths addObject:path];
        
        [self addLineSymbolWithLinePoints:points andSymbol:@[self.symbolName[self.currentIndex]] toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.points symbols:@[self.symbolName[self.currentIndex]]];
        
        self.currentIndex +=1;
    }
    
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加正方形
-(void)addSquareWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+4 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        self.polygon = [AXPPolygonCalculateManager getSquareWithPoints:self.points].mutableCopy;
        
        [polygonPath addLineToPoint:CGPointFromString(self.polygon[2])];
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        for (int i = 1; i < 4; i++) {
            [self.symbols addObject:self.symbolName[self.currentIndex + i]];
        }
        
        [self addPolygonSymbolWithPolygonApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        
        self.currentIndex +=4;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加长方形
-(void)addRectangleWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+4 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        [self addPoints:self.points];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
        
        self.polygon = [AXPPolygonCalculateManager getRectangleWithThreePoints:self.points].mutableCopy;
        
        [polygonPath addLineToPoint:CGPointFromString(self.polygon[2])];
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count]];
        
        [self addPolygonSymbolWithPolygonApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=4;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加平行四边形
-(void)addParallelogramWithPoints:(NSArray *)points drawPath:(drawPathBlock)drawPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    
    if (points.count == 0) {
        return;
    }
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex+4 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addPoint:currentPoint];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        [self addPoints:self.points];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
        
        self.polygon = [AXPPolygonCalculateManager getParallelogramWithPoints:self.points].mutableCopy;
        [polygonPath addLineToPoint:currentPoint];
        [polygonPath addLineToPoint:CGPointFromString(self.polygon.lastObject)];
        [polygonPath closePath];
        
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count - 1]];
        [self.symbols addObject:self.symbolName[self.currentIndex+self.points.count]];

        [self addPolygonSymbolWithPolygonApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
        self.currentIndex +=4;
    }
    // 绘制过程
    [self drawLinePaths];
//    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
//    [self drawPolygon];
}

// 添加多边形
-(void)addPolygonPoints:(NSArray *)points drawRectView:(UIView *)drawRectView drawPath:(drawPathBlock)drawPath completionDashPath:(completionDashBlock)dashPath completion:(completionBlock)completion
{
    self.completion = completion;
    self.drawPath = drawPath;
    self.dashPath = dashPath;
    
    if (points.count == 0) {
        return;
    }
    self.drawRectView = drawRectView;
    
    [self.points addObject:points.lastObject];
    CGPoint currentPoint = CGPointFromString(self.points.lastObject);
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    
    if (self.currentIndex +1 >= self.symbolName.count) {
        [self addSymbolNameWithStr:self.symbolName.lastObject];
    }
    
    [self addPoints:self.points];
    [self.symbols addObject:self.symbolName[self.currentIndex]];
    
    // 第一个点
    if (self.points.count == 1) {
        
        polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:currentPoint];
        
        [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbols.firstObject toDicts:self.polygonSymbols];
        
        [self.linePaths addObject:polygonPath];
        
    }else if (self.points.count == 2) { // 第二个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        [self addLineSymbolWithLinePoints:self.points andSymbol:self.symbols toDicts:self.polygonSymbols];
        
    }else { // 第三个点
        
        [polygonPath addLineToPoint:currentPoint];
        
        self.polygon = self.points;
        
        [self addPolygonSymbolWithPolygonApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
        
        [self addDashLineAndFinishedButton];
    }
    
    self.currentIndex +=1;
    // 绘制过程
    [self drawLinePaths];
    // [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
}

#pragma mark -- 私有方法

// 添加虚线和完成按钮
-(void)addDashLineAndFinishedButton
{
    CGPoint startPoint = CGPointFromString(self.points.firstObject);
    CGPoint endPoint = CGPointFromString(self.points.lastObject);
    
    CGFloat lengths[] = {10,10};
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    [path setLineDash:lengths count:2 phase:2];
    
    if (self.dashPath) {
        self.dashPath(path);
    }
    
    CGFloat changeX = endPoint.x - startPoint.x;
    CGFloat changeY = endPoint.y - startPoint.y;
    
    CGPoint center = CGPointMake(startPoint.x+changeX/2, startPoint.y+changeY/2);
    
    self.finishedButton.center = center;
    [self.drawRectView addSubview:self.finishedButton];
}

// 点击完成按钮之后的操作
-(void)finishedDone:(id)sender
{
    [self.finishedButton removeFromSuperview];
    
    UIBezierPath *path = self.linePaths.lastObject;
    [path closePath];
    
    [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
    
    return;
}

// 添加直角标识和等腰标识
+(void)addRigthAngleMarkAndIsoscelesMarkWithTriangleApexs:(NSArray *)points andPath:(UIBezierPath *)polygonPath
{
    if (points.count != 3) {
        return;
    }
    
    NSArray *lineMarks = [AXPPolygonCalculateManager addIsoscelesTriangleMarkWithPoints:points];
    
    [lineMarks enumerateObjectsUsingBlock:^(UIBezierPath *path, NSUInteger idx, BOOL * _Nonnull stop) {
        [polygonPath appendPath:path];
    }];
    
    UIBezierPath *path = [AXPPolygonCalculateManager addRightAngleMarkWithTrianglePoints:points];
    
    [polygonPath appendPath:path];
}

// 组合元素: 多边形 名称/顶点数组/贝塞尔曲线/标注点数组
// polygon :多边形顶点数组
// symbols :多边形顶点标注名称数组
-(void)makeUpDictWithPolygon:(NSArray *)polygon symbols:(NSArray *)symbols
{
    NSString *polygonName;
    
    if (symbols.count == 1 && polygon.count == 1) {
        
        polygonName = @"射线";
        
    }else if (symbols.count == 2)
    {
        polygonName = @"直线";
    }
    else if (symbols.count == 3)
    {
        polygonName = @"△";
    }else if (symbols.count == 4)
    {
        polygonName = @"▭";
        
    }else if (polygon.count == 2 && symbols.count == 1)
    {
        polygonName = @"◯";
    }
    else
    {
        polygonName = @"多边形";
    }
    
    NSString *key = [symbols componentsJoinedByString:@""];
    key = [polygonName stringByAppendingString:key];
    
    NSMutableArray *polygonArray = [NSMutableArray array];
    
    [polygonArray addObject:polygon.mutableCopy];
    [polygonArray addObject:self.linePaths.lastObject];
    
    if (symbols.count == 1 && polygon.count == 1) {
        
        [polygonArray addObject:self.raySymbols.mutableCopy];
        
    }else
    {
        [polygonArray addObject:self.polygonSymbols.mutableCopy];
    }
    
    NSMutableDictionary *polygonDict = [NSMutableDictionary dictionaryWithObject:polygonArray forKey:key];
    
    [self.polygonElements addObject:polygonDict];
    
    if (self.completion) {
    
        self.completion(polygonDict);
    }
    
    [self.points removeAllObjects];
    [self.linePaths removeAllObjects];
    [self.polygonSymbols removeAllObjects];
    [self.symbols removeAllObjects];
    [self.polygon removeAllObjects];
}

-(void)drawLinePaths
{
    if (self.drawPath) {
        self.drawPath(self.linePaths.firstObject,self.polygonSymbols);
    }
}

// 绘制过程(贝塞尔曲线和标注点)
-(void)drawLinePaths:(NSArray *)linePaths andSymbols:(NSDictionary *)symbols
{
    [linePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIBezierPath *path = obj;
        [path stroke];
    }];
    
    // 绘制标记点
    [symbols enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *symbolStr = key;
        NSString *symbolPointStr = obj;
        
        [self addSymbolmarkWithPoint:CGPointFromString(symbolPointStr) andStr:symbolStr];
    }];
}

// 绘制已经完成的图形.
-(void)drawPolygon
{
    [self.polygonElements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = obj;
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *polygonArray, BOOL * _Nonnull stop) {
            
            NSArray *polygonPoints = polygonArray.firstObject;
            [self addPoints:polygonPoints];
            
            UIBezierPath *polygonPath = polygonArray[1];
            [polygonPath stroke];
            
            NSDictionary *polygonSymbolDict = polygonArray.lastObject;
            [self drawLinePaths:nil andSymbols:polygonSymbolDict];
        }];
    }];
}

// 添加多边形标注字典
-(void)addPolygonSymbolWithPolygonApex:(NSArray *)polygonApex andSymbol:(NSArray *)symbols toDicts:(NSMutableDictionary *)dict
{
    NSArray *symbolArray = [AXPPolygonCalculateManager getPolygonSymbolWithPolygon:polygonApex];
    
    for (int i = 0; i < symbols.count; i++) {
        [dict setObject:symbolArray[i] forKey:symbols[i]];
    }
}

// 添加三角形标注字典
-(void)addTriangleSymbolWithTriangleApex:(NSArray *)triangleApex andSymbol:(NSArray *)symbols toDicts:(NSMutableDictionary *)dict
{
    NSArray *symbolArray = [AXPPolygonCalculateManager getTriangleSymbolPointWithTriangleApex:triangleApex];
    
    for (int i = 0; i < symbolArray.count; i++) {
        
        [dict setObject:symbolArray[i] forKey:symbols[i]];
    }
}

// 添加直线标注字典
-(void)addLineSymbolWithLinePoints:(NSArray *)linePoints andSymbol:(NSArray *)symbols toDicts:(NSMutableDictionary *)dict
{
    NSArray *symbolArray = [AXPPolygonCalculateManager getLineSymbolPointWithStartPoint:CGPointFromString(linePoints.firstObject) endPoint:CGPointFromString(linePoints.lastObject)];
    
    if ([dict isEqual:self.raySymbols]) {
        
        [dict setObject:symbolArray[0] forKey:symbols[0]];
        
    }else
    {
        for (int i = 0; i < symbols.count; i++) {
            
            [dict setObject:symbolArray[i] forKey:symbols[i]];
        }
    }
}

// 添加单点标注字典
-(void)addSinglePointSymbolWithPoint:(CGPoint)point andSymbol:(NSString *)symbol toDicts:(NSMutableDictionary *)dict
{
    CGPoint symbolPoint = CGPointMake(point.x, point.y - kSymbolMargin);
    
    [dict setObject:NSStringFromCGPoint(symbolPoint) forKey:symbol];
}

// 添加点
-(void)addPoints:(NSArray *)points
{
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =obj;
        
        CGPoint point = CGPointFromString(str);
        
        [self addPoint:point];
    }];
}

-(void)addPoint:(CGPoint)point
{
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
    CGContextAddArc(ctx, point.x, point.y, 5, 0, 2*M_PI, 1);
    
    CGContextFillPath(ctx);
}

// 追加标记字符
-(void)addSymbolNameWithStr:(NSString *)currentSymbolName
{
    // 判断当前最后一个标记点
    NSInteger symbolIndex = self.symbolName.count/26;
    int ascii = 65;
    
    for (int i = 0 ; i < 26; i++) {
        
        NSString *addName = [NSString stringWithFormat:@"%c%zd",ascii+i,symbolIndex];
        
        [self.symbolName addObject:addName];
    }
}

// 绘制标记
-(void)addSymbolmarkWithPoint:(CGPoint)point andStr:(NSString *)str
{
    CGSize size = [str sizeWithAttributes:self.textAttributes];
    
    CGRect rect = CGRectMake(point.x - size.width/2, point.y - size.height/2, size.width , size.height);
    
    [str drawInRect:rect withAttributes:self.textAttributes];
}




/***************************** 没有用到的方法 ***********************************/
// 添加多边形并且绘制顶点
-(void)addPolygonAndSymbolWithPoints:(NSArray *)points andSideCounts:(NSInteger)polygonSides isAddPoint:(BOOL)isAddPoint
{
    if (isAddPoint) {
        [self addPoints:points];
    }
    [self addPolygonWithPoints:points andSideCounts:polygonSides];
}

// 添加多边形但不绘制顶点
-(void)addPolygonWithPoints:(NSArray *)points andSideCounts:(NSInteger)polygonSides
{
    if (points.count == 0) {
        return;
    }
    
    // 更改绘制图形; 如果需要继续之前的标记:
    static NSInteger currentIndex = 0;
    static NSInteger currentSymbolPoint = 0;
    
    if (self.currentPolygonSides != polygonSides) {
    
        self.currentPolygonSides = polygonSides;
        
        currentIndex = 0;
        currentSymbolPoint = 0;
        
        [self.polygonElements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                NSArray *array = obj;
                NSArray *arr = array.firstObject;
                currentSymbolPoint += arr.count;
            }];
        }];
    }
    
    // 初始第一个点
    if (points.count % polygonSides == 1) {
        
        UIBezierPath *polygonPath = [UIBezierPath bezierPath];
        [self.linePaths addObject:polygonPath];
    }
    
    UIBezierPath *polygonPath = self.linePaths.lastObject;
    [polygonPath removeAllPoints];
    
    [self.symbols removeAllObjects];
    [self.polygon removeAllObjects];
    
    for (NSInteger i = 0 ; i+currentIndex < points.count; i++) {
        
        NSInteger currentP = currentIndex +i;
        
        NSString *pointStr = points[currentP];
        CGPoint currentPoint = CGPointFromString(pointStr);
        
        // 获取多边形数组
        [self.polygon addObject:pointStr];
        
        if (currentP >= self.symbolName.count) {
            
            [self addSymbolNameWithStr:self.symbolName.lastObject];
        }
        
        // 获取多边形标注内容数组
        [self.symbols addObject:self.symbolName[currentP+currentSymbolPoint]];
        
        
        // 第一个点,添加单点标注
        if (i%polygonSides == 0)
        {
            [polygonPath moveToPoint:currentPoint];
            
            // 添加单点标注
            [self addSinglePointSymbolWithPoint:currentPoint andSymbol:self.symbolName[currentP+currentSymbolPoint] toDicts:self.polygonSymbols];
        }
        
        // 第二个点,添加直线标注
        if(i%polygonSides == 1 )
        {
            [polygonPath addLineToPoint:currentPoint];
            
            // 添加直线标注(两个点的标注)
            [self addLineSymbolWithLinePoints:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
            
            if (polygonSides == 2) {
                [polygonPath closePath];
                currentIndex += polygonSides;
                [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
            }
        }
        
        // 第三个点, 添加三角形标注
        if(i%polygonSides == 2)
        {
            [polygonPath addLineToPoint:currentPoint];
            
            [self addTriangleSymbolWithTriangleApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
            
            if (polygonSides == 3) {
                [polygonPath closePath];
                currentIndex += polygonSides;
                [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
            }
        }
        
        // 第四个点往后,添加多边形标注
        if (i%polygonSides > 2)
        {
            [polygonPath addLineToPoint:currentPoint];
            
            [self addPolygonSymbolWithPolygonApex:self.polygon andSymbol:self.symbols toDicts:self.polygonSymbols];
            
            if (i%polygonSides == polygonSides -1) {
                [polygonPath closePath];
                currentIndex += polygonSides;
                [self makeUpDictWithPolygon:self.polygon symbols:self.symbols];
            }
        }
    }
    
    // 绘制过程
    [self drawLinePaths:self.linePaths andSymbols:self.polygonSymbols];
}

// 添加直线
-(void)addLineWithPoints:(NSArray *)points
{
    [self addPolygonAndSymbolWithPoints:points andSideCounts:2 isAddPoint:NO];
}

// 添加点并且添加标记
-(void)addPointsAndSymbolmark:(NSArray *)points
{
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str =obj;
        CGPoint point = CGPointFromString(str);
        
        [self addSinglePoint:point andSymbol:self.symbolName[idx]];
    }];
}

// 添加单点标注
-(void)addSinglePoint:(CGPoint)point andSymbol:(NSString *)str
{
    [self addPoint:point];
    // 给单个点添加标记,添加在上面
    CGPoint symbolPoint = CGPointMake(point.x, point.y - kSymbolMargin);
    [self addSymbolmarkWithPoint:symbolPoint andStr:str];
}

// 下面的方法没用
void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

/***************************** 没有用到的方法 ***********************************/



static id _instance;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.currentIndex = 0;
        self.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}.mutableCopy;
    }
    
    return self;
}

// 初始化标记字符:A~Z
-(NSMutableArray *)symbolName
{
    if (!_symbolName) {
        
        _symbolName = [NSMutableArray array];
        
        int ASCIIBasic = 65;
        
        for (int i = 0 ; i < 26; i++) {
            
            NSString *str = [NSString stringWithFormat:@"%c",ASCIIBasic+i];
            
            [_symbolName addObject:str];
        }
    }

    return _symbolName;
}

-(NSMutableArray *)linePaths
{
    if (!_linePaths) {
        _linePaths = [NSMutableArray array];
    }
    return _linePaths;
}

-(NSMutableDictionary *)raySymbols
{
    if (!_raySymbols) {
        _raySymbols = [NSMutableDictionary dictionary];
    }
    return _raySymbols;
}

-(NSMutableDictionary *)polygonSymbols
{
    if (!_polygonSymbols) {
        _polygonSymbols = [NSMutableDictionary dictionary];
    }
    return _polygonSymbols;
}

-(NSMutableArray *)polygonElements
{
    if (!_polygonElements) {
        _polygonElements = [NSMutableArray array];
    }
    return _polygonElements;
}

-(NSMutableArray *)currentPolygonsPoints
{
    if (!_currentPolygonsPoints) {
        _currentPolygonsPoints = [NSMutableArray array];
    }
    return _currentPolygonsPoints;
}

-(UIButton *)finishedButton
{
    if (!_finishedButton) {
    
        _finishedButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_finishedButton addTarget:self action:@selector(finishedDone:) forControlEvents:UIControlEventTouchUpInside];
        _finishedButton.backgroundColor = [UIColor orangeColor];
        [_finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _finishedButton;
}

-(NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

-(NSMutableArray *)symbols
{
    if (!_symbols) {
        _symbols = [NSMutableArray array];
    }
    return _symbols;
}

-(NSMutableArray *)polygon
{
    if (!_polygon) {
        _polygon = [NSMutableArray array];
    }
    return _polygon;
}


@end
