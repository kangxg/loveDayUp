//
//  UIViewController+RootViewController.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/3/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

/**
 *  @author LiuChuanan, 17-03-10 13:55:57
 *  
 *  @brief 增加一个类别,扩展一个方法,判断sideNav有没有初始化
 *
 *  @since 
 */


#import <UIKit/UIKit.h>

@interface UIViewController (RootViewController)

/**
 *  @author LiuChuanan, 17-03-10 13:55:57
 *  
 *  @brief 判断sideNav有没有初始化
 *
 *  @since 
 */
- (BOOL)haveInitView;

@end
