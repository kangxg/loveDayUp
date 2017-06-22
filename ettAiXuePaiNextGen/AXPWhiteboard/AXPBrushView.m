//
//  AXPBrushView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPBrushView.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTPaintbrushManager.h"
#import "AXPWhiteboardConfiguration.h"
#import "ETTWhiteBoardView.h"
#import "AXPWhiteboardViewController.h"

@interface AXPBrushView ()

@property(nonatomic ,strong) NSMutableArray *brushPaths;
@property(nonatomic ,strong) NSMutableArray *eraserPaths;

@end

@implementation AXPBrushView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.frame = CGRectMake(0, 0, kWIDTH-kAXPWhiteboardManagerWidth, kHEIGHT-64);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    return self;
}

-(void)clearAllBezierPaths
{
//    [self.paths enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [layer removeFromSuperlayer];
//    }];
//    
//    [self.paths removeAllObjects];
    
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

// 开始点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    AXPWhiteboardToolbarManager *toolbarManager = [AXPWhiteboardToolbarManager sharedManager];
    
    AXPWhiteboardViewController *vc = (AXPWhiteboardViewController *)toolbarManager.vc;
    
    if ([vc respondsToSelector:NSSelectorFromString(@"hiddenRewardManagerView")]) {
    SEL selector = NSSelectorFromString(@"hiddenRewardManagerView");
    IMP imp = [vc methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(vc, selector);
    }

    AXPWhiteboardManager manager = toolbarManager.whiteboardManager;

    
    if (manager != AXPWhiteboardMove && !(manager >= AXPWhiteboardLine && manager <= AXPWhiteboardCircle)) {
        [self.superview.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.superview removeGestureRecognizer:obj];
        }];
    }
    
    // 关闭悬浮按钮
    [toolbarManager.suspendNimbleView hiddenNimbleToolbarCompletion:nil];
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    
    ETTPaintbrushManager *brushManager = [ETTPaintbrushManager sharedManager];
    
    switch (manager) {
            
        case AXPWhiteboardBrush:
            
            brushManager.paintbrushColorAlpha = 0;
            
            brushManager.paintbrushColor =  [AXPWhiteboardConfiguration sharedConfiguration].brushColor;
            brushManager.paintbrushWidth = [AXPWhiteboardConfiguration sharedConfiguration].brushSize;
            brushManager.paintbrushColorAlpha = [AXPWhiteboardConfiguration sharedConfiguration].brushAlpha;
            
            [self beganDrawBezierPathWithPoint:startPoint];
            
            break;
            
        case AXPWhiteboardEraser:
            
            brushManager.paintbrushColorAlpha = 0;
            
            brushManager.paintbrushColor = [UIColor clearColor];

            brushManager.paintbrushWidth = [AXPWhiteboardConfiguration sharedConfiguration].eraserSize;
            [self beganDrawBezierPathWithPoint:startPoint];
            
            break;
            
        case AXPWhiteboardText:
            
            [self.superview touchesBegan:touches withEvent:event];
            
            break;
            
        default:
            break;
    }
}

// 移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    AXPWhiteboardToolbarManager *toolbarManager = [AXPWhiteboardToolbarManager sharedManager];
    
    AXPWhiteboardManager manager = toolbarManager.whiteboardManager;
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    
    switch (manager) {
            
        case AXPWhiteboardBrush:
            
            [self addPointToBezierPathWithPoint:movePoint];
            
            break;
            
        case AXPWhiteboardEraser:
            
            [self addPointToBezierPathWithPoint:movePoint];
            
            break;
            
        default:
            break;
    }
}

// 点击结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

// 开始绘制 UIBezierPath // 开始手绘
-(void)beganDrawBezierPathWithPoint:(CGPoint)startPoint
{
    [[ETTPaintbrushManager sharedManager] createBezierPathWithStartPoint:startPoint completionHandle:^(NSDictionary<UIBezierPath *,UIColor *> *bezierDict) {
        
        [self bezierPathTestWithDict:bezierDict];
        
//        [self shapelayerTestWithDict:bezierDict];
    }];
}

-(void)shapelayerTestWithDict:(NSDictionary *)bezierDict
{
    [bezierDict enumerateKeysAndObjectsUsingBlock:^(UIBezierPath * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        //
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.frame;
        shapeLayer.path = key.CGPath;
        shapeLayer.lineWidth = key.lineWidth;
        shapeLayer.strokeColor = obj.CGColor;
        shapeLayer.fillColor = nil;
        shapeLayer.lineJoin = kCALineJoinRound ;
        shapeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:shapeLayer];
        
        [self.paths addObject:shapeLayer];
        
        ETTWhiteBoardView *whiteboardView = (ETTWhiteBoardView *)self.superview;
        
        [whiteboardView.paths addObject:shapeLayer];
    }];
}

-(void)bezierPathTestWithDict:(NSDictionary *)bezierDict
{
    AXPWhiteboardToolbarManager *toolbarManager = [AXPWhiteboardToolbarManager sharedManager];
    AXPWhiteboardManager manager = toolbarManager.whiteboardManager;
    
    switch (manager) {

        case AXPWhiteboardBrush:

            [self.brushPaths addObject:bezierDict];

            break;

        case AXPWhiteboardEraser:

            [self.eraserPaths addObject:bezierDict];

            break;

        default:
            break;
    }

    // 将路径添加到数组中
    [self.paths addObject:bezierDict];
    
    ETTWhiteBoardView *whiteboardView = (ETTWhiteBoardView *)self.superview;
    [whiteboardView.paths addObject:bezierDict];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}


// 往 UIBezierPath 中添加路径 // 手绘的过程
-(void)addPointToBezierPathWithPoint:(CGPoint)movePoint
{
//    [[ETTPaintbrushManager sharedManager] addPointToBezierPath:movePoint completionHandle:^(NSDictionary<UIBezierPath *,UIColor *> *bezierDict) {
//        
//        [bezierDict enumerateKeysAndObjectsUsingBlock:^(UIBezierPath * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
//            //
//            CAShapeLayer *shapeLayer =(CAShapeLayer *)self.layer.sublayers.lastObject;
//            shapeLayer.path = key.CGPath;
//        }];
//    }];
    
    [[ETTPaintbrushManager sharedManager] addPointToBezierPath:movePoint completionHandle:^(NSDictionary<UIBezierPath *,UIColor *> *bezierDict) {
        
        [self setNeedsDisplay];
    }];
    
}

-(void)drawRect:(CGRect)rect
{
    [self.paths enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if ([self.eraserPaths indexOfObject:dict] != NSNotFound) {
            
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                UIBezierPath *path = key;
                path.lineCapStyle = kCGLineCapRound;
                path.lineJoinStyle = kCGLineJoinRound;
                
                UIColor *color = obj;
                [color set];
                [path strokeWithBlendMode:kCGBlendModeClear alpha:1];
                [path stroke];
            }];
            
        }else
        {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                // 有三种类型的字典: 手绘字典 / 文字字典
                UIBezierPath *path = key;
                path.lineCapStyle = kCGLineCapRound;
                path.lineJoinStyle = kCGLineJoinRound;
                
                UIColor *color = obj;
                [color set];
                [path stroke];
            }];
        }
    }];
}


-(NSMutableArray *)brushPaths
{
    if (!_brushPaths) {
        _brushPaths = [NSMutableArray array];
    }
    return _brushPaths;
}

-(NSMutableArray *)eraserPaths
{
    if (!_eraserPaths) {
        _eraserPaths = [NSMutableArray array];
    }
    return _eraserPaths;
}

-(NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}


@end
