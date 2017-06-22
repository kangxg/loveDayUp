//
//  ETTDockView.h
//  ettAiXuePaiNextGen
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTKit.h"
#import "ETTTabBar.h"
#import "ETTBottomMenu.h"
#import "ETTTabBarItem.h"
#import "ETTIconButton.h"
#import "ExternMacros.pch"
#import "SidNavigationConst.h"
#import "ETTTopMenu.h"
#import "ETTSideNavigationViewControllerDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ETTStudentSelectTeacherModel.h"

typedef NS_ENUM(NSInteger,ETTDockViewType)
{
    /**
     *  伸出
     */
    ETTDockViewTypeExtend,
    /**
     *  缩进
     */
    ETTDockViewTypeShrink
};

@protocol ETTDockDelegate <NSObject>


@end


@interface ETTDockView :ETTView

@property (nonatomic,weak) ETTStudentSelectTeacherModel *model;

@property (nonatomic,weak,readonly) ETTBottomMenu *bottomMenu;

@property (nonatomic,weak,readonly) ETTTabBar     *tabBar;

@property (nonatomic,weak,readonly) ETTIconButton *iconButton;

@property (nonatomic,weak,readonly) ETTTopMenu *topMenu;

-(instancetype)initWithIdentity:(ETTSideNavigationViewIdentity)identity;

-(instancetype)initWithModel:(ETTStudentSelectTeacherModel *)model ForIdentity:(ETTSideNavigationViewIdentity)identity;

-(void)rotateToLandscape:(BOOL)isLandscape;

@end
