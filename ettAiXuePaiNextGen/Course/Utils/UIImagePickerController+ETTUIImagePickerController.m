//
//  UIImagePickerController+ETTUIImagePickerController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "UIImagePickerController+ETTUIImagePickerController.h"

@implementation UIImagePickerController (ETTUIImagePickerController)
- (NSInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
