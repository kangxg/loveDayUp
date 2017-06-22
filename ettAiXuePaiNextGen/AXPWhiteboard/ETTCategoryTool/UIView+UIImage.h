//
//  UIView+UIImage.h
//  whiteboardDemo
//
//  Created by DeveloperLx on 16/7/12.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIImage)

/**
 *  @author DeveloperLx, 16-07-19 15:07:47
 *
 *  @brief 截屏
 *
 *  @param view 需要截屏的View
 *
 *  @return 截屏之后的图片
 *
 *  @since 0.0
 */
+(UIImage *)snapshot:(UIView *)view;
/**
 *  @author DeveloperLx, 16-07-13 10:07:33
 *
 *  @brief 判断点 point 是否在 view 上
 *
 *  @param point 需要判断的点
 *  @param view  需要判断的view
 *
 *  @return 是否在某个点上
 *
 *  @since 0.0
 */
+(BOOL)isPoint:(CGPoint)point InView:(UIView *)view;

+(BOOL)isPoint:(CGPoint)point inFrame:(CGRect)frame;

@end
