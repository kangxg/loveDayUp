//
//  ETTImagePickerManager.h
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^pickerImageBlock)(UIImage *pickerImage);

@interface ETTImagePickerManager : NSObject

+(instancetype)createManagerButton:(UIButton *)button sourceType:(UIImagePickerControllerSourceType)sourceType completionHandle:(pickerImageBlock)completionHandle;

/**
 *  @author DeveloperLx, 16-07-19 17:07:21
 *
 *  @brief 访问相册/相机拍照,获取图片
 *
 *  @param vc               从哪个控制器跳转
 *  @param sourceType       访问相册?/相机?
 *  @param completionHandle 获取到图片之后的block回调
 *
 *  @return 单例
 *
 *  @since 0.0
 */
+(instancetype)createManagerWithVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completionHandle:(pickerImageBlock)completionHandle;

/**
 *  @author DeveloperLx, 16-07-19 17:07:10
 *
 *  @brief  将图片保存到相册
 *
 *  @param image 需要保存的图片
 *
 *  @since 0.0
 */
+(void)saveImageToPhotosAlbum:(UIImage *)image;

+(void)creatAlertViewWithMessage:(NSString *)message;

@end
