//
//  ETTImageManager.m
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/15.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTImageManager.h"
#import "ETTManagerView.h"

#define kManagerViewWidth 15
#define kManagerViewHeight 15


typedef enum : NSUInteger {
    
    ETTLeftTopView = 0,
    ETTTopCenterView = 1,
    ETTRightTopView = 2,
    ETTRightCenterView = 3,
    ETTRightBottomView = 4,
    ETTBottomCenterView = 5,
    ETTLeftBottomView = 6,
    ETTLeftCenterView = 7,
    
} ETTManagerSelected;

@interface ETTImageManager ()

@property(nonatomic ,assign) CGSize originSize;

@end

@implementation ETTImageManager

static id _instance;

+(instancetype)sharedImageManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

-(void)removeAllManagerView
{
    [self.managerViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ETTManagerView *view = obj;
        
        [view removeFromSuperview];
    }];
    
    [self.managerViews removeAllObjects];
    
}


+(instancetype)createWithSelectedImageView:(UIView *)selectedImageView superView:(UIView *)whiteBoardView
{
    ETTImageManager *manager = [ETTImageManager sharedImageManager];
    
    manager.selectedImageView = selectedImageView;
    manager.superView = whiteBoardView;
    
    if ([selectedImageView isKindOfClass:[UIImageView class]]) {
        // 图片原始大小,用来做默认最大最小值的判断
        UIImageView *imageView = (UIImageView *)selectedImageView;
        manager.originSize = [self getSelectedImageSize:imageView.image];
    }else
    {
        manager.originSize = selectedImageView.frame.size;
    }

    [manager removeAllManagerView];
    [manager setUpManagerViewRect];
    
    return manager;
}

/**
 *  @author DeveloperLx, 16-07-19 10:07:50
 *
 *  @brief 获得原始图片的大小,确定图片的最小宽高.
 *
 *  @param imageView 图片
 *
 *  @return 原始图片的大小
 *
 *  @since 1.00
 */
+(CGSize)getSelectedImageSize:(UIImage *)image
{
    CGFloat defaultW = (kWIDTH-kAXPWhiteboardManagerWidth)*0.6;
    CGFloat defaultH = (kHEIGHT-64)*0.6;
    
   return [self getImageSizeWithImage:image maxSize:CGSizeMake(defaultW, defaultH)];
}

+(CGSize)getImageSizeWithImage:(UIImage *)image maxSize:(CGSize)maxSize
{
    CGSize size = image.size;
    
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    
    CGFloat defaultW = maxSize.width;
    CGFloat defaultH = maxSize.height;
    
    // 原图 宽/高 <= 默认值,直接返回原图大小.
    if (imageH <= defaultH && imageW <= defaultW) {
        return  CGSizeMake(imageW, imageH);
    }
    
    // 原图高 > 于默认值, 宽 <= 默认值;
    if (imageH > defaultH && imageW <= defaultW) {
        
        // 高等于默认值,宽按比例缩小
        CGFloat k = imageH/defaultH;
        
        imageH = defaultH;
        
        imageW = imageW/k;
        
        return  CGSizeMake(imageW, imageH);
    }
    
    // 原图宽 > 于默认值, 高 <= 默认值;
    if (imageW >= defaultW && imageH <= defaultH) {
        
        // 宽等于默认值,高按比例缩小
        CGFloat k = imageW/defaultW;
        
        imageW = defaultW;
        
        imageH = imageH/k;
        
        return  CGSizeMake(imageW, imageH);
    }
    
    // 原图宽/高 > 默认值
    if (imageH >= defaultH && imageW >= defaultW) {
        
        CGFloat k1 = imageW/defaultW;
        CGFloat k2 = imageH/defaultH;
        
        if (fabs(k1-k2) < 0.01) {
            
            imageW = defaultW;
            imageH = defaultH;
            
            return  CGSizeMake(imageW, imageH);
        }
        
        if (k1 < k2) {
            
            imageH = defaultH;
            
            imageW = imageW/k2;
            
            return  CGSizeMake(imageW, imageH);
        }
        
        if (k1 > k2) {
            
            imageW = defaultW;
            
            imageH = imageH/k2;
            
            return  CGSizeMake(imageW, imageH);
        }
    }
    
    return CGSizeMake(imageW, imageH);
}

-(void)originAlgorithm:(CGFloat)defaultW :(CGFloat)defaultH :(CGFloat)imageW :(CGFloat)imageH
{
    CGFloat k1 = defaultH/defaultW;
    CGFloat k2 = imageH/imageW;
    
    if (fabs(k1-k2) < 0.01) {
        
        imageW = defaultW;
        imageH = defaultH;
        
    }
    
    if (k1 < k2) {
        
        imageH = defaultW;
        
        imageW = defaultW/k2;
        
    }
    
    if (k1 > k2) {
        
        imageH = defaultH*k2;
        
        imageW = defaultW;
    }
}


+(UIImage *)getSuitableImageFromOriginImage:(UIImage *)originImage
{
    CGSize whiteboardSize = CGSizeMake(kWIDTH - kAXPWhiteboardManagerWidth, kHEIGHT - 64);
    
    CGSize size = [self getImageSizeWithImage:originImage maxSize:whiteboardSize];
    
    CGFloat X = (whiteboardSize.width - size.width)/2;
    CGFloat Y = (whiteboardSize.height - size.height)/2;
    
    UIGraphicsBeginImageContext(whiteboardSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, whiteboardSize.width, whiteboardSize.height));
    
    [originImage drawInRect:CGRectMake(X, Y, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)drawSmallImageWithOriginImage:(UIImage *)originImage maxSize:(CGSize)maxSize
{
    CGSize size = [self getImageSizeWithImage:originImage maxSize:maxSize];
    
    CGSize smallImageSize = CGSizeMake(size.width, size.height);
    
    UIGraphicsBeginImageContext(smallImageSize);
    
    [originImage drawInRect:CGRectMake(0, 0, smallImageSize.width, smallImageSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    
    UIImage *smallImage = [UIImage imageWithData:data];
    
    return smallImage;
}


// 计算需要绘制的边框位置
-(void)setUpManagerViewRect
{
    CGAffineTransform transform = self.selectedImageView.transform;
    
    if (transform.b || transform.c) {
        
        return;
    }
    
    [self addManagerViewToManagers];
    
    [self.managerViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ETTManagerView *view = obj;
        
        view.backgroundColor = [UIColor greenColor];
        
        [self.superView addSubview:view];
        
    }];
}

-(void)addManagerViewToManagers
{
    CGRect SelectedRect = self.selectedImageView.frame;
    
    CGFloat imageW = SelectedRect.size.width;
    CGFloat imageH = SelectedRect.size.height;
    
    CGFloat leftX = SelectedRect.origin.x;
    CGFloat rightX = leftX + imageW;
    CGFloat topY = SelectedRect.origin.y;
    CGFloat bottomY = topY + imageH;
    // 水平中心
    CGFloat horizontalCenterY = bottomY - imageH/2;
    // 垂直中心
    CGFloat verticalCenterX = leftX + imageW/2;
    
    
    CGPoint leftTop = CGPointMake(leftX, topY);
    CGPoint topCenter = CGPointMake(verticalCenterX, topY);
    CGPoint rightTop = CGPointMake(rightX, topY);
    CGPoint rightCenter = CGPointMake(rightX, horizontalCenterY);
    CGPoint rightBottom = CGPointMake(rightX, bottomY);
    CGPoint bottomCenter = CGPointMake(verticalCenterX, bottomY);
    CGPoint leftBottom = CGPointMake(leftX, bottomY);
    CGPoint leftCenter = CGPointMake(leftX, horizontalCenterY);
    
    // 按顺时针按顺序添加点:
    [self getRectWithPoint:leftTop];
    [self getRectWithPoint:topCenter];
    [self getRectWithPoint:rightTop];
    [self getRectWithPoint:rightCenter];
    [self getRectWithPoint:rightBottom];
    [self getRectWithPoint:bottomCenter];
    [self getRectWithPoint:leftBottom];
    [self getRectWithPoint:leftCenter];
}

// 根据 中心点point 求出边长为 10 的矩形
-(void)getRectWithPoint:(CGPoint)point
{
    CGFloat imageW = kManagerViewWidth;
    CGFloat imageH = kManagerViewHeight;
    CGFloat imageX = point.x-imageW/2;
    CGFloat imageY = point.y-imageH/2;
    
    CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
    [self createManagerViewWithRect:rect];
}

// 创建控制小View /添加手势.
-(void)createManagerViewWithRect:(CGRect)rect
{
    ETTManagerView *managerView = [[ETTManagerView alloc] initWithFrame:rect];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(manageViewWithPan:)];
    
    [managerView addGestureRecognizer:pan];
    
    [self.managerViews addObject:managerView];
}


-(void)manageViewWithPan:(UIPanGestureRecognizer *)pan
{
    CGPoint endPoint = [pan locationInView:self.superView];
    CGPoint startPoint = pan.view.center;
    
    // 左上角
    if (pan.view == self.managerViews[ETTLeftTopView]) {
        
        [self leftTopMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 上中
    }else if (pan.view == self.managerViews[ETTTopCenterView]) {
        
        [self topCenterMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 右上角
    }else if (pan.view == self.managerViews[ETTRightTopView]) {
        
        [self rightTopMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 右中
    }else if (pan.view == self.managerViews[ETTRightCenterView]) {
        
        [self rightCenterMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 右下角
    }else if (pan.view == self.managerViews[ETTRightBottomView]) {
        
        [self rightBottomMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 下中
    }else if (pan.view == self.managerViews[ETTBottomCenterView]) {
        
        [self bottomCenterMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 左下角
    }else if (pan.view == self.managerViews[ETTLeftBottomView]) {
        
        [self leftBottomMoved:pan.view startPoint:startPoint endPoint:endPoint];
    // 左中
    }else if (pan.view == self.managerViews[ETTLeftCenterView]) {
        
        [self leftCenterMoved:pan.view startPoint:startPoint endPoint:endPoint];
    }
    
    [self.superView setNeedsDisplay];
}

/**
 *  @author DeveloperLx, 16-07-18 15:07:30
 *
 *  @brief 左上角移动
 *
 *  @param leftTop    左上角View
 *  @param rect       选中图片的原始位置
 *  @param startPoint 开始移动的时候点的位置
 *  @param endPoint   移动结束的时候点的位置
 *
 *  @since 1.00
 */
-(void)leftTopMoved:(UIView *)leftTop startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *rightBottom = self.managerViews[ETTRightBottomView];

    CGFloat topY = endPoint.y;
    CGFloat bottomY = rightBottom.center.y;
    CGFloat leftX = endPoint.x;
    CGFloat rightX = rightBottom.center.x;

    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}


/**
 *  @author DeveloperLx, 16-07-18 15:07:30
 *
 *  @brief 上中角移动
 *
 *  @param leftTop    上中角View
 *  @param rect       选中图片的原始位置
 *  @param startPoint 开始移动的时候点的位置
 *  @param endPoint   移动结束的时候点的位置
 *
 *  @since 1.00
 */
-(void)topCenterMoved:(UIView *)topCenter startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *rightTop = self.managerViews[ETTRightTopView];
    ETTManagerView *leftBottom = self.managerViews[ETTLeftBottomView];
    
    CGFloat topY = endPoint.y;
    CGFloat bottomY = leftBottom.center.y;
    CGFloat leftX = leftBottom.center.x;
    CGFloat rightX = rightTop.center.x;
    
    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)rightTopMoved:(UIView *)rightTop startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *leftBottom = self.managerViews[ETTLeftBottomView];
    
    CGFloat topY = endPoint.y;
    CGFloat bottomY = leftBottom.center.y;
    CGFloat leftX = leftBottom.center.x;
    CGFloat rightX = endPoint.x;
    
    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)rightCenterMoved:(UIView *)rightCenter startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *leftBottom = self.managerViews[ETTLeftBottomView];
    ETTManagerView *leftTop = self.managerViews[ETTLeftTopView];
    
    CGFloat topY = leftTop.center.y;
    CGFloat bottomY = leftBottom.center.y;
    CGFloat leftX = leftBottom.center.x;
    CGFloat rightX = endPoint.x;
    
    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)rightBottomMoved:(UIView *)rightBottom startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *leftTop = self.managerViews[ETTLeftTopView];
    
    CGFloat topY = leftTop.center.y;
    CGFloat bottomY = endPoint.y;
    CGFloat leftX = leftTop.center.x;
    CGFloat rightX = endPoint.x;
    
    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)bottomCenterMoved:(UIView *)bottomCenter startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *leftTop = self.managerViews[ETTLeftTopView];
    ETTManagerView *rightTop = self.managerViews[ETTRightTopView];
    
    CGFloat topY = leftTop.center.y;
    CGFloat bottomY = endPoint.y;
    CGFloat leftX = leftTop.center.x;
    CGFloat rightX = rightTop.center.x;
    
    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)leftBottomMoved:(UIView *)leftBottom startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *rightTop = self.managerViews[ETTRightTopView];
    
    CGFloat topY = rightTop.center.y;
    CGFloat bottomY = endPoint.y;
    CGFloat leftX = endPoint.x;
    CGFloat rightX = rightTop.center.x;

    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

-(void)leftCenterMoved:(UIView *)leftCenter startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ETTManagerView *rightTop = self.managerViews[ETTRightTopView];
    ETTManagerView *rightBottom = self.managerViews[ETTRightBottomView];
    
    CGFloat topY = rightTop.center.y;
    CGFloat bottomY = rightBottom.center.y;
    CGFloat leftX = endPoint.x;
    CGFloat rightX = rightTop.center.x;

    [self setUpManagerViewRectWithleftX:leftX rightX:rightX topY:topY bottomY:bottomY];
}

// 确定八个控制点的位置
-(void)setUpManagerViewRectWithleftX:(CGFloat)leftX rightX:(CGFloat)rightX topY:(CGFloat)topY bottomY:(CGFloat)bottomY
{
    CGFloat imageW = rightX -leftX;
    CGFloat imageH = bottomY - topY;
    
    // 判断不能缩小至图片原始大小的一半.
    imageH = imageH <= self.originSize.height/2 ? self.originSize.height/2 :imageH;
    
    topY = imageH <= self.originSize.height/2 ? bottomY - self.originSize.height/2 :topY;
    
    imageW = imageW <= self.originSize.width/2 ? self.originSize.width/2 :imageW;
    
    leftX = imageW <= self.originSize.width/2 ? rightX - self.originSize.width/2 :leftX;
    
    // 水平中心
    CGFloat horizontalCenterY = bottomY - imageH/2;
    // 垂直中心
    CGFloat verticalCenterX = leftX + imageW/2;
    
    ETTManagerView *leftTop = self.managerViews[ETTLeftTopView];
    ETTManagerView *topCenter = self.managerViews[ETTTopCenterView];
    ETTManagerView *rightTop = self.managerViews[ETTRightTopView];
    ETTManagerView *rightCenter = self.managerViews[ETTRightCenterView];
    ETTManagerView *rightBottom = self.managerViews[ETTRightBottomView];
    ETTManagerView *bottomCenter = self.managerViews[ETTBottomCenterView];
    ETTManagerView *leftBottom = self.managerViews[ETTLeftBottomView];
    ETTManagerView *leftCenter = self.managerViews[ETTLeftCenterView];
    
    leftTop.center = CGPointMake(leftX, topY);
    topCenter.center = CGPointMake(verticalCenterX, topY);
    rightTop.center = CGPointMake(rightX, topY);
    rightCenter.center = CGPointMake(rightX, horizontalCenterY);
    rightBottom.center = CGPointMake(rightX, bottomY);
    bottomCenter.center = CGPointMake(verticalCenterX, bottomY);
    leftBottom.center = CGPointMake(leftX, bottomY);
    leftCenter.center = CGPointMake(leftX, horizontalCenterY);
    
    self.selectedImageView.frame = CGRectMake(leftX, topY, imageW, imageH);

}

-(NSMutableArray *)managerViews
{
    if (!_managerViews) {
        _managerViews = [NSMutableArray array];
    }
    return _managerViews;
}

@end
