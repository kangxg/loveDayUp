//
//  ETTWhiteBoardView.m
//  whiteboardDemo
//
//  Created by DeveloperLx on 16/7/11.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "ETTWhiteBoardView.h"
#import "UIView+UIImage.h"
#import "ETTImageManager.h"
#import "ETTImagePickerManager/ETTImagePickerManager.h"
#import "ETTPaintbrushManager/ETTPaintbrushManager.h"
#import "ETTWhiteCanvasTextViewManager.h"
#import "ETTManagerView.h"
#import "AXPSpecialGraphManager/AXPPolygonManager.h"
#import "AXPSpecialGraphManager/AXPPolygonCalculateManager.h"
#import "AXPPolygonView.h"
#import "UIColor+RGBColor.h"
#import "AXPWhiteboardToolbarManager.h"
#import "AXPShowtextView.h"

#define kAddImageViewXDefault 100
#define kAddImageViewYDefault 100
#define kApexColor [UIColor colorWithRed:74.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:203.0/255.0]

@interface ETTWhiteBoardView ()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic ,strong) NSMutableArray *points;

// 白板中的图片数组 -- 记录添加到白板中的图片
@property(nonatomic ,strong) NSMutableArray *images;

// 白板中的文字数组 -- 记录添加到白板中的文字
@property(nonatomic ,strong) NSMutableArray *textFileds;

// 多边形数组
@property(nonatomic ,strong) NSMutableArray *polygonElements;

// 保存上一步下一步的临时数组
@property(nonatomic ,strong) NSMutableArray *LPaths;

// 给选中的图片添加八个方向拖动拉伸的控制管理者
@property(nonatomic ,strong) ETTImageManager *manager;

@property(nonatomic ,assign) CGPoint startPoint;

// 选中的特殊图形
@property(nonatomic ,strong) NSMutableArray *selectedPolygonArray;

@property(nonatomic ,strong) NSMutableDictionary *selectedPolygonDict;

// 选中的textView 字典
@property(nonatomic ,strong) NSDictionary *textDict;

// 删除按钮
@property(nonatomic ,strong) UIButton *deleteButton;

@property(nonatomic ,strong) NSMutableArray *showtextViews;

@end

@implementation ETTWhiteBoardView

// 清空白板
-(void)clearWhiteboard
{
    // 清空图片
    [self.images enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView removeFromSuperview];
    }];
    
    // 清空文字
    [self.showtextViews enumerateObjectsUsingBlock:^(AXPShowtextView *showtextView, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        [showtextView removeFromSuperview];
    }];
    ////////////////////////////////////////////////////////
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    // 将图片元素也删除
     self.layer.contents = nil;
    ////////////////////////////////////////////////////////

  
   
    [self.paths removeAllObjects];
    [self.images removeAllObjects];
    [self.photoImages removeAllObjects];
    [self.LPaths removeAllObjects];

    [self.textFileds removeAllObjects];
    [self.showtextViews removeAllObjects];
    [self.polygonElements removeAllObjects];

    [AXPPolygonManager sharedManager].currentIndex = 0;
    [[AXPPolygonManager sharedManager].points removeAllObjects];
    [[AXPPolygonManager sharedManager].linePaths removeAllObjects];
    [[AXPPolygonManager sharedManager].polygonSymbols removeAllObjects];
    
    // 清空未完成的特殊图形
    [self removeNotCompletedPolygon];
    // 清空手绘/橡皮擦
    [self.brushView clearAllBezierPaths];
    // 清空特殊图形
    [self.polygonContantView drawPolygonWithPolygonElements:self.polygonElements];
}

// 上一步
-(BOOL)forward
{
    id forwardPath = self.paths.lastObject;
    
    if (!forwardPath) {
        return NO;
    }
    
    [self.LPaths addObject:forwardPath];
    [self.paths removeLastObject];
    
    // 未完成绘制的多边形
    if ([forwardPath isKindOfClass:[UIBezierPath class]])
    {
        [self.LPaths removeLastObject];
        [self removeNotCompletedPolygon];
        [self.polygonContantView setNeedsDisplay];
        
        return YES;
    }
    // 文字/多边形
    if ([forwardPath isKindOfClass:[NSDictionary class]])
    {
        // 两种字典: 文字字典/多边形字典
        NSDictionary *dict = forwardPath;
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
//            // 文字字典
//            if ([key isKindOfClass:[NSDictionary class]]) {
//                
//                [self.textFileds removeObject:dict];
//                [self.textContantView drawTextWithTextFields:self.textFileds];
//            }
//
//            else
            // 手绘字典
            if([key isKindOfClass:[UIBezierPath class]])
            {
                [self.brushView.paths removeLastObject];
                [self.brushView setNeedsDisplay];
            }
            // 多边形字典
            else
            {
                [self.polygonElements removeObject:dict];
                [self.polygonContantView drawPolygonWithPolygonElements:self.polygonElements];
            }
        }];
        
        return YES;
    }
    // 文字
    if ([forwardPath isKindOfClass:[AXPShowtextView class]])
    {
        AXPShowtextView *showtextView = forwardPath;
        [self.showtextViews removeObject:showtextView];
        [showtextView removeFromSuperview];
        
        return YES;
    }
    // 手绘
    if ([forwardPath isKindOfClass:[CAShapeLayer class]])
    {
        CAShapeLayer *layer = forwardPath;
        [layer removeFromSuperlayer];
        
        return YES;
    }
    // 图片
    if ([forwardPath isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = forwardPath;
        [self.images removeObject:imageView];
        [imageView removeFromSuperview];
        
        return YES;
    }
    
    return YES;
}

// 下一步
-(BOOL)next
{
    id nextPath = self.LPaths.lastObject;
    
    if (!nextPath) {
        return NO;
    }
    
    [self.paths addObject:nextPath];
    [self.LPaths removeLastObject];
    
    // 文字/多边形
    if ([nextPath isKindOfClass:[NSDictionary class]])
    {
        // 两种字典: 文字字典/多边形字典
        NSDictionary *dict = nextPath;
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            // 手绘字典
            if([key isKindOfClass:[UIBezierPath class]])
            {
                [self.brushView.paths addObject:dict];
                [self.brushView setNeedsDisplay];
            }
            // 多边形字典
            else
            {
                [self.polygonElements addObject:dict];
                [self.polygonContantView drawPolygonWithPolygonElements:self.polygonElements];
            }
        }];
        
        return YES;
    }
    
    // 文字
    if ([nextPath isKindOfClass:[AXPShowtextView class]])
    {
        AXPShowtextView *showtextView = nextPath;
        [self.showtextViews addObject:showtextView];
        [self.textContantView addSubview:showtextView];
        return YES;
    }
    // 手绘
    if ([nextPath isKindOfClass:[CAShapeLayer class]])
    {
        CAShapeLayer *layer = nextPath;
        [self.brushView.layer addSublayer:layer];
        
        return YES;
    }
    // 图片
    if ([nextPath isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = nextPath;
        [self.images addObject:imageView];
        [self insertSubview:imageView belowSubview:self.polygonContantView];
        return YES;
    }

    return YES;
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self removeNotCompletedPolygon];
    
    NSLog(@"%ld",(long)self.currentSymbolIndex);
}

-(void)textViewDidDone
{
    if (self.isAddText) {
        return;
    }
    
    self.isAddText = YES;
    
    [[ETTWhiteCanvasTextViewManager sharedManager] textViewDidDone:self.currentTextView];
    
    AXPShowtextView *showtextView = [[AXPShowtextView alloc] initWithTextDict:self.textFileds.lastObject];
    
    [self.showtextViews addObject:showtextView];
    [self.textContantView addSubview:showtextView];
    [self.paths addObject:showtextView];
    
    [self.currentTextView resignFirstResponder];
    [self.currentTextView removeFromSuperview];
    self.currentTextView = nil;
}

-(void)changeTextViewLayer
{
    [ETTWhiteCanvasTextViewManager sharedManager].textView.layer.borderColor = [UIColor clearColor].CGColor;
    [[ETTWhiteCanvasTextViewManager sharedManager].textView resignFirstResponder];
}

-(void)removeNotCompletedPolygon
{
    self.currentSymbolIndex = [AXPPolygonManager sharedManager].currentIndex;
    [self.points removeAllObjects];
    
    self.polygonContantView.linePath = nil;
    self.polygonContantView.completionDashPath = nil;
    self.polygonContantView.symbolDict = nil;
    [self.polygonContantView setNeedsDisplay];

    
    [[AXPPolygonManager sharedManager].points removeAllObjects];
    [[AXPPolygonManager sharedManager].linePaths removeAllObjects];
    [[AXPPolygonManager sharedManager].polygonSymbols removeAllObjects];
    [[AXPPolygonManager sharedManager].symbols removeAllObjects];
    [[AXPPolygonManager sharedManager].finishedButton removeFromSuperview];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(instancetype)init
{
    self = [super init];
    
    [self addSubview:self.polygonContantView];
    [self addSubview:self.textContantView];
    [self addSubview:self.brushView];
    
    self.clipsToBounds = YES;

    self.isAddText = YES;
    
    self.whiteboardConfig = [AXPWhiteboardConfiguration sharedConfiguration];
    
    [AXPPolygonManager sharedManager].currentIndex = 0;
    
    AXPWhiteboardManager manager = [AXPWhiteboardToolbarManager sharedManager].whiteboardManager;
    
    if (manager >= AXPWhiteboardLine && manager <= AXPWhiteboardCircle) {
        
        [self addTapGesture];
    }
    
    if (manager == AXPWhiteboardMove) {
        
        [self addPinchAndRotationGestureRecognizer];
    }
    
    return self;
}

// 添加图片
- (void)addImage:(UIImage *)image from:(AXPImageSource)source
{

    if (source == AXPPushImage) {
        
        //取绝对值
        if (fabs(image.size.width - self.frame.size.width) < 10 && fabs(image.size.height - self.frame.size.height)< 10) {
            ////////////////////////////////////////////////////////
            /*
               Epic-KXG-AIXUEPAIOS-1141
             */
            // 如果是推送过来的图片,则设为背景色.
            //self.backgroundColor = [UIColor colorWithPatternImage:image];
            self.layer.contents = (id)image.CGImage;
            ////////////////////////////////////////////////////////
            
            //新创建一个imageView 用来显示推送的图片 这种方式不行
            //UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
            //imageView.image = image;
            //[self addSubview:imageView];
            
        }else
        {
        
           UIImage *wbImage = [ETTImageManager getSuitableImageFromOriginImage:image];
           

            // 如果是推送过来的图片,则设为背景色.
            self.backgroundColor = [UIColor colorWithPatternImage:wbImage];
            
            //UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
            //imageView.image = wbImage;
            //[self addSubview:imageView];
        }
    }else
    {
        CGSize size = [ETTImageManager getSelectedImageSize:image];
        
        UIImage *smallImage = [self drawSmallImageWithOriginImage:image imageSize:CGSizeMake(size.width*3, size.height*3)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:smallImage];
        
        CGRect frame = CGRectMake(kAddImageViewXDefault, kAddImageViewYDefault, size.width, size.height);
        imageView.frame = frame;

        [self insertSubview:imageView belowSubview:self.polygonContantView];
        [self.images addObject:imageView];
        [self.paths addObject:imageView];
        
        if (source == AXPPhotoImage) {
            
            [self.photoImages addObject:imageView];
        }
    }
}

// 绘制一张不是很大的图片
-(UIImage *)drawSmallImageWithOriginImage:(UIImage *)originImage imageSize:(CGSize)size
{
    CGSize smallImageSize = CGSizeMake(size.width, size.height);
    
    UIGraphicsBeginImageContext(smallImageSize);
    
    [originImage drawInRect:CGRectMake(0, 0, smallImageSize.width, smallImageSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    
    UIImage *smallImage = [UIImage imageWithData:data];
    
    return smallImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AXPWhiteboardToolbarManager *toolbarManager = [AXPWhiteboardToolbarManager sharedManager];
    
    // 关闭悬浮按钮
    [toolbarManager.suspendNimbleView hiddenNimbleToolbarCompletion:nil];
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    
    ETTWhiteCanvasTextViewManager *textManager = [ETTWhiteCanvasTextViewManager sharedManager];
    
    AXPWhiteboardManager manager = toolbarManager.whiteboardManager;
    
    switch (manager) {
            
        case AXPWhiteboardText:
            
            textManager.fontSize = self.whiteboardConfig.textFontSize;
            textManager.textColor = self.whiteboardConfig.textColor;
            
            [self beganAddTextWithPoint:startPoint];
            
            break;
            
        default:
            break;
    }
}

// 添加点击手势
-(void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewWithTap:)];
    
    [self addGestureRecognizer:tap];
}

// 添加拖拽和旋转手势
-(void)addPinchAndRotationGestureRecognizer
{
    // 添加点击手势
    [self addTapGesture];

    // 添加缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchViewWithPinch:)];
    
    [self addGestureRecognizer:pinch];
    
    // 添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didMovedImageWithPan:)];
    
    [self addGestureRecognizer:pan];
    
    // 添加旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationViewWithRotation:)];
    
    rotation.delegate = self;
    
    [self addGestureRecognizer:rotation];
    
//     添加长按手势
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithPress:)];
    
    [self addGestureRecognizer:press];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void)clickViewWithTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    NSInteger integer = [AXPWhiteboardToolbarManager sharedManager].whiteboardManager;
    
    if (integer == AXPWhiteboardMove) {
    
        [self selectedMovedImageWithPoint:point];
        
    }else if (integer >= AXPWhiteboardLine && integer <= AXPWhiteboardCircle)
    {
        [self.points addObject:NSStringFromCGPoint(point)];
        
        if (self.selectedPolygonArray.count == 4) {
            [self.selectedPolygonArray removeLastObject];
        }
        
        [self drawSpecialGraphPathsWithPolygonStyle:integer];
    }
}

-(void)beganAddTextWithPoint:(CGPoint)startPoint
{
    __block UITextView *startTextView;
    __weak typeof(self)wself = self;
    
    if (!self.isAddText) {
        self.isAddText = YES;
        
        NSDictionary *dict = self.textFileds.lastObject;
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UITextView *textView, BOOL * _Nonnull stop) {
            //
            startTextView = textView;
        }];
        
        if (startTextView.text.length) {
            
            AXPShowtextView *showtextView = [[AXPShowtextView alloc] initWithTextDict:dict];
            
            [self.showtextViews addObject:showtextView];
            [self.textContantView addSubview:showtextView];
            [self.paths addObject:showtextView];
        }
        
        [startTextView resignFirstResponder];
        [startTextView removeFromSuperview];
        
        return;
    }
    
    [[ETTWhiteCanvasTextViewManager sharedManager] createTextViewWithPoint:startPoint superView:self.textContantView didCreated:^(UITextView *textView ,NSDictionary *textAttributes) {
        
        wself.currentTextView = textView;
        wself.isAddText = NO;
        NSDictionary *dict = @{textAttributes:textView};
        
        [wself.textFileds addObject:dict];
//        [wself.paths addObject:dict];
        
    } keyboardDidReturn:^{
        
        self.isAddText = YES;
        
        AXPShowtextView *showtextView = [[AXPShowtextView alloc] initWithTextDict:wself.textFileds.lastObject];
        [self.showtextViews addObject:showtextView];
        [self.textContantView addSubview:showtextView];
        [wself.paths addObject:showtextView];
    }];
}

// 更新选中的特殊图形顶点数组
-(void)updateSelectedPolygonWithChangeX:(CGFloat)changeX andChangeY:(CGFloat)changeY
{
    __block NSString *polygonName;
    
    [self.selectedPolygonDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        polygonName = key;
    }];
    
    
    NSMutableArray *polygon = [NSMutableArray array];
    [self.selectedPolygonArray.firstObject enumerateObjectsUsingBlock:^(NSString *pointStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = CGPointFromString(pointStr);
        
        point.x += changeX;
        point.y += changeY;
        
        [polygon addObject:NSStringFromCGPoint(point)];
    }];
    
    self.selectedView.frame = [AXPPolygonCalculateManager getPolygonMinRectWithPolygon:polygon explan:polygonName];
    
    [self updateSelectedPolygonArrayWithPolygon:polygon];
}

-(void)updateSelectedPolygonArrayWithPolygon:(NSArray *)polygon
{
    NSMutableDictionary *dict = self.selectedPolygonArray[2];
    NSArray *symbols = dict.allKeys;
    
    NSMutableDictionary *polygonDict = [NSMutableDictionary dictionary];
    [[AXPPolygonManager sharedManager] addPolygonSymbolWithPolygonApex:polygon andSymbol:symbols toDicts:polygonDict];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (polygon.count == 2 && polygonDict.count == 1) {
        // 画圆
        CGPoint circleCenter = CGPointFromString(polygon.firstObject);
        CGPoint currentPoint = CGPointFromString(polygon.lastObject);
        
        CGFloat lo = sqrt((circleCenter.x - currentPoint.x)*(circleCenter.x - currentPoint.x) + (circleCenter.y - currentPoint.y)*(circleCenter.y - currentPoint.y));
        
        [path addArcWithCenter:circleCenter radius:lo startAngle:0 endAngle:2*M_PI clockwise:YES];
        
    }else
    {
        [polygon enumerateObjectsUsingBlock:^(NSString *pointStr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGPoint point = CGPointFromString(pointStr);
            if (idx == 0) {
                [path moveToPoint:point];
            }else if (idx == polygon.count-1)
            {
                [path addLineToPoint:point];
                [path closePath];
            }else
            {
                [path addLineToPoint:point];
            }
        }];
    }
    
    UIColor *color;
    if (self.selectedPolygonArray.count == 4) {
        color = self.selectedPolygonArray.lastObject;
    }
    [self.selectedPolygonArray removeAllObjects];
    
    [AXPPolygonManager addRigthAngleMarkAndIsoscelesMarkWithTriangleApexs:polygon andPath:path];
    
    [self.selectedPolygonArray addObject:polygon];
    [self.selectedPolygonArray addObject:path];
    [self.selectedPolygonArray addObject:polygonDict];
    
    if (color) {
        [self.selectedPolygonArray addObject:color];
    }
}

-(void)didMovedImageWithPan:(UIPanGestureRecognizer *)pan
{
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardManager != AXPWhiteboardMove) {
        return;
    }
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        CGPoint startPoint = [pan locationInView:self];
        
        [self selectedMovedImageWithPoint:startPoint];
        
        if (!self.selectedView) {
            return;
        }
    }
    
    CGPoint movePoint = [pan locationInView:self];

    CGFloat increaseX = movePoint.x - self.startPoint.x;
    CGFloat increaseY = movePoint.y - self.startPoint.y;
    
    CGPoint center;
    
    center = CGPointMake(self.selectedView.center.x + increaseX, self.selectedView.center.y + increaseY);
    
    if ([self.selectedView isKindOfClass:[AXPPolygonView class]]) {
        
        [self updateSelectedPolygonWithChangeX:increaseX andChangeY:increaseY];
        
        [self.polygonContantView setNeedsDisplay];
        
    }else
    {
        self.selectedView.center = center;
    }
    
    self.startPoint = movePoint;
}

// 判断图片是否移动到边界外
-(void)judgementOverborderWithCenter:(CGPoint)center increaseX:(CGFloat)increaseX increaseY:(CGFloat)increaseY
{
    BOOL overstepLeft = center.x - self.selectedView.frame.size.width/2 < 1;
    
    if (overstepLeft) {
        
        center.x = self.selectedView.frame.size.width/2;
        
        increaseX = 0;
    }
    
    BOOL overstepRight = center.x + self.selectedView.frame.size.width/2 > self.frame.size.width - 1;
    
    if (overstepRight) {
        
        center.x = self.frame.size.width - self.selectedView.frame.size.width/2;
        
        increaseX = 0;
    }
    
    BOOL overstepTop = center.y - self.selectedView.frame.size.height/2 < 1;
    
    if (overstepTop) {
        
        center.y = self.selectedView.frame.size.height/2;
        
        increaseY = 0;
    }
    
    BOOL overstepBottom = center.y + self.selectedView.frame.size.height/2 > self.frame.size.height;
    
    if (overstepBottom) {
        
        center.y = self.frame.size.height - self.selectedView.frame.size.height/2;
        
        increaseY = 0;
    }
}

-(void)selectedMovedImageWithPoint:(CGPoint)startPoint
{
    if (self.selectedView) {
        self.selectedView.layer.borderWidth = 0;
    }
    self.selectedView = nil;
    if (self.selectedPolygonArray.count == 4) {
        [self.selectedPolygonArray removeLastObject];
        [self.polygonContantView setNeedsDisplay];
    }
    
    
//    if (self.textDict) {
//    
//        [self.textContantView selectedTextWithTextDict:nil];
//        self.textDict = nil;
//    }
    
    // 遍历文字输入框数组,查看触摸点是否位于文字框内.
//    [self.textFileds enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *textDict, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UITextView *textView, BOOL * _Nonnull dictStop) {
//            //
//            BOOL is_hasSelectedView = [UIView isPoint:startPoint InView:textView];
//            
//            if (is_hasSelectedView) {
//                
//                self.startPoint = startPoint;
//                self.selectedView = textView;
//                self.textDict = textDict;
//                
//                [self.textFileds insertObject:textDict atIndex:self.textFileds.count];
//                [self.textContantView selectedTextWithTextDict:self.textDict];
//                
//                *stop = YES;
//            }
//        }];
//    }];
    
    [self.showtextViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AXPShowtextView *showtextView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL is_hasSelectedView = [UIView isPoint:startPoint InView:showtextView];
        
        if (is_hasSelectedView) {
            
            self.startPoint = startPoint;
            self.selectedView = showtextView;
            
            showtextView.layer.borderColor = kAXPLINECOLORl4.CGColor;
            showtextView.layer.borderWidth = 1;
            
            [self.showtextViews insertObject:showtextView atIndex:self.showtextViews.count];
            
            [self.textContantView bringSubviewToFront:showtextView];
            
            *stop = YES;
        }

    }];
    
    if (self.selectedView) return;
    
    // 遍历特殊图形数组,查看触摸点位于哪一个特殊图形之内.
    [self.polygonElements enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSMutableDictionary *polygonDict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [polygonDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *polygonArray, BOOL * _Nonnull dictStop) {
            
            NSArray *polygon = polygonArray.firstObject;
            
            BOOL is_hasSelectedView = [AXPPolygonCalculateManager touchPoint:startPoint InPolygon:polygon explan:key];
            
            if (is_hasSelectedView) {
                
                self.selectedPolygonArray = polygonArray;
                self.startPoint = startPoint;
                self.selectedPolygonDict = polygonDict;
                
                CGRect rect = [AXPPolygonCalculateManager getPolygonMinRectWithPolygon:polygon explan:key];
                AXPPolygonView *view = [[AXPPolygonView alloc] initWithFrame:rect];
                
                self.selectedView = view;
                [polygonArray addObject:kApexColor];
                
                [self.polygonElements insertObject:polygonDict atIndex:self.polygonElements.count];
                
                [self.polygonContantView drawPolygonWithPolygonElements:self.polygonElements];
                
                *stop = YES;
            }
        }];
    }];
    
    if (self.selectedView) return;
    
    [self.images enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        BOOL is_hasSelectedView = [UIView isPoint:startPoint InView:imageView];
        
        if (is_hasSelectedView) {
            
            self.startPoint = startPoint;
            self.selectedView = imageView;
            
            imageView.layer.borderColor = kAXPLINECOLORl4.CGColor;
            imageView.layer.borderWidth = 2;
            
            [self insertSubview:imageView belowSubview:self.polygonContantView];
            [self.images insertObject:imageView atIndex:self.images.count];
            
            *stop = YES;
        }
    }];
}

-(void)showMenuControllerWithSelectedView:(UIView *)selectedView
{
    CGRect rect = selectedView.frame;
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteSelectedView)];
    menu.menuItems = @[delete];
    
    if (rect.origin.y < 40) {
        menu.arrowDirection = UIMenuControllerArrowUp;
        rect.origin.y += 16;
    }else
    {
        menu.arrowDirection = UIMenuControllerArrowDown;
        rect.origin.y -= 16;
    }
    [menu setTargetRect:rect inView:self];
    [menu setMenuVisible:YES];
}

-(void)longPressWithPress:(UILongPressGestureRecognizer *)press
{
    CGPoint startPoint = [press locationInView:self];
    
    [self selectedMovedImageWithPoint:startPoint];
    
    if (press.state == UIGestureRecognizerStateBegan) {
    
        if (self.selectedView) {
        
            [self showMenuControllerWithSelectedView:self.selectedView];
            
        }else
        {
            [[UIMenuController sharedMenuController] setMenuVisible:NO];
        }
    }
}

// 删除选中的View
-(void)deleteSelectedView
{
    if ([self.selectedView isKindOfClass:[UIImageView class]]) {
        
        [self.images removeObject:self.selectedView];
        [self.selectedView removeFromSuperview];
        [self.paths removeObject:self.selectedView];
        
        if ([self.photoImages indexOfObject:self.selectedView] != NSNotFound) {
            
            [self.photoImages removeObject:self.selectedView];
        }
        
        return;
    }
    
    if ([self.selectedView isKindOfClass:[AXPPolygonView class]]) {
        
        [self.polygonElements removeObject:self.selectedPolygonDict];
        [self.paths removeObject:self.selectedPolygonDict];
        
        [self.polygonContantView drawPolygonWithPolygonElements:self.polygonElements];
        
        return;
    }
    
    if([self.selectedView isKindOfClass:[AXPShowtextView class]])
    {
        [self.paths removeObject:self.selectedView];
        [self.showtextViews removeObject:self.selectedView];
        [self.selectedView removeFromSuperview];
        
        return;
    }
}

-(void)rotationViewWithRotation:(UIRotationGestureRecognizer *)rotation
{
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardManager != AXPWhiteboardMove) {
        return;
    }
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    if ([self.selectedView isKindOfClass:[UIImageView class]]) {
        
        if (rotation.state == UIGestureRecognizerStateBegan || rotation.state == UIGestureRecognizerStateChanged) {
            
            self.selectedView.transform = CGAffineTransformRotate(self.selectedView.transform, rotation.rotation);
            
            [rotation setRotation:0];
        }
    }
}

-(void)pinchViewWithPinch:(UIPinchGestureRecognizer *)pinch
{
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardManager != AXPWhiteboardMove) {
        return;
    }
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        
        self.selectedView.transform = CGAffineTransformScale(self.selectedView.transform, pinch.scale, pinch.scale);
        
        NSLog(@"缩放比例:%f",pinch.scale);
        
        if ([self.selectedView isKindOfClass:[AXPPolygonView class]]) {
            
            NSMutableArray *selectedPolygon = self.selectedPolygonArray.firstObject;
            
            NSMutableDictionary *dict = self.selectedPolygonArray[2];
            NSArray *symbols = dict.allKeys;
            
            NSMutableDictionary *polygonDict = [NSMutableDictionary dictionary];
            [[AXPPolygonManager sharedManager] addPolygonSymbolWithPolygonApex:selectedPolygon andSymbol:symbols toDicts:polygonDict];
            
            NSMutableArray *polygon;
            
            if (selectedPolygon.count == 2 && polygonDict.count == 1) {
                // 圆
                CGPoint point = CGPointFromString(selectedPolygon.lastObject);
                
                NSLog(@"缩放前:%@",NSStringFromCGPoint(point));
                
                point.x = point.x*pinch.scale;
                point.y = point.y*pinch.scale;
                
                NSLog(@"缩放后:%@",NSStringFromCGPoint(point));

                polygon = [AXPPolygonCalculateManager getCirclePinchPointWithCircle:selectedPolygon pinchedFrame:self.selectedView.frame].mutableCopy;
                
            }else
            {
                polygon = [AXPPolygonCalculateManager getPinchPolygonWithOriginalPolygon:selectedPolygon andPinchedFrame:self.selectedView.frame].mutableCopy;
            }
            
            [self updateSelectedPolygonArrayWithPolygon:polygon];
            
            [self.polygonContantView setNeedsDisplay];
        }
        
        pinch.scale = 1;
    }
}

-(void)drawSpecialGraphPathsWithPolygonStyle:(AXPWhiteboardManager)polygonStyle
{
    __weak typeof(self) wself = self;
    
    drawPathBlock drawPath = ^(UIBezierPath *linePath, NSMutableDictionary *polygonSymbols){
        
        if ([wself.paths indexOfObject:linePath] == NSNotFound) {
        
            if (linePath) {
                [wself.paths addObject:linePath];
            }
        }

        [wself.polygonContantView drawPolygonlinePath:linePath symbolDict:polygonSymbols points:self.points];
    };
    
    completionBlock completion = ^(NSMutableDictionary *polygonDict){
    
        [wself.points removeAllObjects];
        
        [wself.paths addObject:polygonDict];
        [wself.polygonElements addObject:polygonDict];
        
        [wself.polygonContantView drawPolygonWithPolygonElements:wself.polygonElements];
    };
    
    completionDashBlock dashPath = ^(UIBezierPath *dashPath){
        
        wself.polygonContantView.completionDashPath = dashPath;
    };
    
    switch (polygonStyle) {
    
        case AXPWhiteboardLine:
        
            [self addLineWithDrawPath:drawPath Completion:completion];
        
            break;
            
        case AXPWhiteboardTriangle:
        
            [self addTriangleWithDrawPath:drawPath Completion:completion];
            
            break;
            
        case AXPWhiteboardQuadrangle:
            
            [self addQuadrangleWithDrawPath:drawPath completionDashPath:dashPath Completion:completion];
            
            break;
            
        case AXPWhiteboardCircle:
            
            [self addCircleWithDrawPath:drawPath Completion:completion];
            
            break;
            
        default:
            break;
    }
}

-(void)addCircleWithDrawPath:(drawPathBlock)drawPath Completion:(completionBlock)completion
{
    switch (self.whiteboardConfig.selectedCircle) {
            
        case AXPPolygonAddCircle:
            
            [[AXPPolygonManager sharedManager] addArcWithDiameterPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        default:
            break;
    }
}

-(void)addQuadrangleWithDrawPath:(drawPathBlock)drawPath completionDashPath:(completionDashBlock)dashPath Completion:(completionBlock)completion
{
    switch (self.whiteboardConfig.selectedQuadrangle) {
            
        case AXPPolygonAddSquare:
            
            [[AXPPolygonManager sharedManager] addSquareWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddRectangle:
            
            [[AXPPolygonManager sharedManager] addRectangleWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddRegularParallelogram:
            
            [[AXPPolygonManager sharedManager] addParallelogramWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddRegularQuadrilateral:
            
            [[AXPPolygonManager sharedManager] addPolygonPoints:self.points drawRectView:self drawPath:drawPath completionDashPath:dashPath completion:completion];
            
            break;
            
        default:
            break;
    }
}

-(void)addTriangleWithDrawPath:(drawPathBlock)drawPath Completion:(completionBlock)completion
{
    switch (self.whiteboardConfig.selectedTriangle) {
            
        case AXPPolygonAddTriangle:
            
            [[AXPPolygonManager sharedManager] addTriangleAndSymbolmarkWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddRightTriangle:
            
            [[AXPPolygonManager sharedManager] addRightAngleTriangleWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddIsocelesTriangle:
            
            [[AXPPolygonManager sharedManager] addIsoscelesTriangleWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        case AXPPolygonAddRegularTriangle:
            
            [[AXPPolygonManager sharedManager] addEquilateralTriangleWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        default:
            break;
    }
}

-(void)addLineWithDrawPath:(drawPathBlock)drawPath Completion:(completionBlock)completion
{
    switch (self.whiteboardConfig.selectedLine) {
            
        case AXPPolygonAddLine:
            
            [[AXPPolygonManager sharedManager] addLineAndSymbolmarkWithPoints:self.points drawPath:drawPath completion:completion];
            
            break;
            
        default:
            break;
    }
}

// 上一步下一步的临时数组
-(NSMutableArray *)LPaths
{
    if (!_LPaths) {
        _LPaths = [NSMutableArray array];
    }
    return _LPaths;
}

// 绘制路径路径
-(NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

// 图片
-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(NSMutableArray *)textFileds
{
    if (!_textFileds) {
        _textFileds = [NSMutableArray array];
    }
    return _textFileds;
}

-(NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

-(NSMutableArray *)polygonElements
{
    if (!_polygonElements) {
        _polygonElements = [NSMutableArray array];
    }
    return _polygonElements;
}

-(NSMutableArray *)photoImages
{
    if (!_photoImages) {
        _photoImages = [NSMutableArray array];
    }
    return _photoImages;
}

-(AXPBrushView *)brushView
{
    if (!_brushView) {
        _brushView = [[AXPBrushView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _brushView;
}

-(AXPTextContantView *)textContantView
{
    if (!_textContantView) {
        _textContantView = [[AXPTextContantView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _textContantView;
}

-(AXPPolygonContantView *)polygonContantView
{
    if (!_polygonContantView) {
        _polygonContantView = [[AXPPolygonContantView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _polygonContantView;
}

-(NSMutableArray *)showtextViews
{
    if (!_showtextViews) {
        _showtextViews = [NSMutableArray array];
    }
    return _showtextViews;
}

@end
