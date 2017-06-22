//
//  AXPSetPopViewController.h
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPSetPopViewController : UINavigationController

@property(nonatomic ) BOOL doneBtnClick;

@property(nonatomic ) BOOL isPop;

+(instancetype)creatPopViewControllerWithSelectedView:(UIView *)selectedView sourceArray:(NSArray *)sourceArray title:(NSString *)title;

// 恢复白板设置
-(void)resumeAxpWhiteboardSetStatus;

@end
