//
//  ETTAlertController.h
//  访问相册
//
//  Created by Li Kaining on 16/7/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTAlertController : UIAlertController

+(instancetype)createAlertControllerWithTitle:(NSString *)title Message:(NSString *)message YesHandle:(void(^)())yesHandle NoHandle:(void(^)())noHandle;

@end
