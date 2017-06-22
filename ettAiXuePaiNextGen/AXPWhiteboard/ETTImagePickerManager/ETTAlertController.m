//
//  ETTAlertController.m
//  访问相册
//
//  Created by Li Kaining on 16/7/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "ETTAlertController.h"

@implementation ETTAlertController

+(instancetype)createAlertControllerWithTitle:(NSString *)title Message:(NSString *)message YesHandle:(void(^)())yesHandle NoHandle:(void(^)())noHandle;
{
    
    ETTAlertController *alert = [ETTAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (noHandle) {
            noHandle();
        }
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    
    if (yesHandle) {
        [alert addAction:action1];
    }
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (yesHandle) {
            yesHandle();
        }
        [alert dismissViewControllerAnimated:NO completion:^{
        }];
    }];
    
    if (noHandle) {
        [alert addAction:action2];
    }
    
    return alert;
}

@end
