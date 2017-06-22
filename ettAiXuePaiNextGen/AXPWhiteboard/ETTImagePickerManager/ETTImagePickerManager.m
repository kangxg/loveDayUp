//
//  ETTImagePickerManager.m
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "ETTImagePickerManager.h"
#import "ETTAlertController.h"
#import "AXPWhiteboardConfiguration.h"
#import "AXPGetRootVcTool.h"
#import "NSString+ETTDeviceType.h"

@interface ETTImagePickerManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic ,weak) UIViewController *vc;

@property(nonatomic ,copy) pickerImageBlock pickerImage;

@property(nonatomic ,strong) UIPopoverController *pop;

@end


@implementation ETTImagePickerManager

static id _instance;

+(instancetype)createManagerButton:(UIButton *)button sourceType:(UIImagePickerControllerSourceType)sourceType completionHandle:(pickerImageBlock)completionHandle
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        return nil;
    }
    
    ETTImagePickerManager *manager = [[ETTImagePickerManager alloc] init];
    
    // 访问相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = manager;
    imagePicker.sourceType = sourceType;
    
    if (completionHandle) {
        
        manager.pickerImage = completionHandle;
    }
    
    UIPopoverController *pop=[[UIPopoverController alloc]initWithContentViewController:imagePicker];
    
    manager.pop = pop;
    
    UIPopoverArrowDirection arrowDirection;
    
    if ([[AXPWhiteboardConfiguration sharedConfiguration].toolbar isEqual: @"左侧"]) {
        
        arrowDirection = UIPopoverArrowDirectionLeft;
    }else
    {
        arrowDirection = UIPopoverArrowDirectionRight;
    }
    
    [pop presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:arrowDirection animated:YES];
    
    return manager;
}


+(instancetype)createManagerWithVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completionHandle:(pickerImageBlock)completionHandle
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        return nil;
    }
    
    ETTImagePickerManager *manager = [[ETTImagePickerManager alloc] init];
    
    // 访问相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    
    imagePicker.delegate = manager;
    
    imagePicker.sourceType = sourceType;
    
    manager.vc = vc;
    
    if (completionHandle) {
        
        manager.pickerImage = completionHandle;
    }
    
    [manager.vc presentViewController:imagePicker animated:YES completion:^{
        
        if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        }
    }];

    return manager;
}


+(void)saveImageToPhotosAlbum:(UIImage *)image
{
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
}

// 监听图片保存过程 :后续分享给学生
+(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        
        NSString *message = @"图片保存成功!";
        
        [self creatAlertViewWithMessage:message];

        return;
    }
    
    if (error.code == -3310) {

//        NSString *message = [NSString stringWithFormat:@"请在 \"设置->隐私->%@\" 中允许访问相机",@"相机"];
//        
//        ETTAlertController *ac = [ETTAlertController createAlertControllerWithTitle:@"提示" Message:message YesHandle:nil NoHandle:nil];
//        [imagePicker presentViewController:ac animated:YES completion:nil];

        
        NSString *message = @"请在 \"设置->隐私->相册\" 中选择允许访问相册!";
        
        [self creatAlertViewWithMessage:message];
        
        return;
    }
    
    NSString *message = @"存储空间不足,请清空空间之后再次保存!";
    
    [self creatAlertViewWithMessage:message];
    
}


+(void)creatAlertViewWithMessage:(NSString *)message
{
    ETTAlertController *vc = [ETTAlertController createAlertControllerWithTitle:@"提示" Message:message YesHandle:nil NoHandle:nil];
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [rootVc presentViewController:vc animated:YES completion:^{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [vc dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 选择使用原图还是修改之后的图片;
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if (self.pickerImage) {
        
        /**
         *  @author LiuChuanan, 17-05-09 17:17:57
         *  
         *  @brief  mini1 拍照和取照片质量压缩比例调为0.4 ,非mini1按照0.78压缩
         *
         *  branch  origin/bugfix/AIXUEPAIOS-1319
         *   
         *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
         * 
         *  @since 
         */
        NSString *deviceType = [NSString getDeviceType];
        
        NSData *data;
        
        if ([deviceType isEqualToString:iPadMini1]) 
        {
            data = UIImageJPEGRepresentation(originalImage, 0.4);
            NSLog(@"mini1白板里面压缩后图片大小 %.2fKB",data.length / 1024.0);
        } else
        {
            data = UIImageJPEGRepresentation(originalImage, 0.78);
            NSLog(@"不是mini1白板里面压缩后图片大小 %.2fKB",data.length / 1024.0);
        }
        
        UIImage *compressImage = [UIImage imageWithData:data];
        
        self.pickerImage(compressImage);
    }
    
    [self.pop dismissPopoverAnimated:YES];
    
//    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.pop dismissPopoverAnimated:YES];
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

@end
