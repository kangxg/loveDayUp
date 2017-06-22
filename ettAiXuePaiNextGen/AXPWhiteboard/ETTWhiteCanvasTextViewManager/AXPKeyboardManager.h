//
//  AXPKeyboardManager.h
//  AXPBasic
//
//  Created by Li Kaining on 16/8/10.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AXPKeyboardManager : NSObject

+(instancetype)sharedManager;

// 键盘高度
@property(nonatomic ,assign) CGFloat keyboardHeight;

// 键盘是否显示
@property(nonatomic ,assign) BOOL keyboardIsHidden;

@end
