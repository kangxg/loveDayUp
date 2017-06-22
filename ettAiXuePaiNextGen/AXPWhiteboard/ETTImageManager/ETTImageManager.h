//
//  ETTImageManager.h
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/15.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTImageManager : NSObject

// 八个小控制View.
@property(nonatomic ,strong) NSMutableArray *managerViews;

// 需要改变的图片.
@property(nonatomic ,strong) UIView *selectedImageView;

// 八个小控制View添加到的父视图View.
@property(nonatomic ,strong) UIView *superView;

+(instancetype)sharedImageManager;

/**
 *  @author DeveloperLx, 16-07-19 15:07:42
 *
 *  @brief 实例化对象---获得的是一个单例对象
 *
 *  @param selectedImageView 选中的图片
 *  @param whiteBoardView    父视图
 *
 *  @return 单例对象
 *
 *  @since 0.0
 */
+(instancetype)createWithSelectedImageView:(UIView *)selectedImageView superView:(UIView *)whiteBoardView;

/**
 *  @author DeveloperLx, 16-07-19 15:07:32
 *
 *  @brief 根据图片计算一个初始尺寸
 *
 *  @param imageView 需要计算的图片图片
 *
 *  @return 图片的默认大小(符合长宽比的大小)
 *
 *  @since 0.0
 */
+(CGSize)getSelectedImageSize:(UIImage *)image;

/**
 *  @author DeveloperLx, 16-07-22 16:07:08
 *
 *  @brief 删除所有的控制View
 *
 *  @since 0.0
 */
-(void)removeAllManagerView;

+(CGSize)getImageSizeWithImage:(UIImage *)image maxSize:(CGSize)maxSize;

+(UIImage *)drawSmallImageWithOriginImage:(UIImage *)originImage maxSize:(CGSize)maxSize;

+(UIImage *)getSuitableImageFromOriginImage:(UIImage *)originImage;

@end
