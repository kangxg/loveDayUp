//
//  UIView+UIImage.m
//  whiteboardDemo
//
//  Created by DeveloperLx on 16/7/12.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "UIView+UIImage.h"
#import "NSString+ETTDeviceType.h"

@implementation UIView (UIImage)

+(UIImage *)snapshot:(UIView *)view
{
    UIImage *theImage  = nil;
    
    //老师把作答题目推给学生,学生展示在白板上,老师点击结束作答,截取白板.由于白板处于后台,视图无法渲染了.
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        theImage = [UIImage imageNamed:@"image_small_fail"];
    }
    else
    {
        // 1.开启绘图上下文
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1);
        
        // 2.将 view 绘制到当前上下文
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        
        // 3.从当前图形上下文中获取绘制之后的图片
        theImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 4. 关闭绘图上下文
        UIGraphicsEndImageContext();
    }
  
    return theImage;
}

+(BOOL)isPoint:(CGPoint)point inFrame:(CGRect)frame
{
    // 取出 view 的范围
    CGFloat minX = frame.origin.x;
    
    CGFloat minY = frame.origin.y;
    
    CGFloat maxX = frame.size.width + minX;
    
    CGFloat maxY = frame.size.height + minY;
    
    // 判断点是否在view上
    
    BOOL isX = minX <= point.x && maxX >= point.x ? YES : NO ;
    
    BOOL isY = minY <= point.y &&maxY >= point.y ? YES :NO;
    
    return isX && isY ? YES :NO;
}


+(BOOL)isPoint:(CGPoint)point InView:(UIView *)view
{
    // 取出 view 的范围
    CGFloat minX = view.frame.origin.x;
    
    CGFloat minY = view.frame.origin.y;
    
    CGFloat maxX = view.frame.size.width + minX;
    
    CGFloat maxY = view.frame.size.height + minY;
    
    // 判断点是否在view上
    
    BOOL isX = minX <= point.x && maxX >= point.x ? YES : NO ;
    
    BOOL isY = minY <= point.y &&maxY >= point.y ? YES :NO;
    
    return isX && isY ? YES :NO;
}

@end
