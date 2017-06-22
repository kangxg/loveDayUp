//
//  ETTLoginViewController.h
//  ettAiXuePaiNextGen
//
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
//  Created by zhaiyingwei on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTKit.h"
#import "ExternMacros.pch"
#import "ETTSideNavigationViewController.h"
#import "ETTLoginBackgroundView.h"
#import "ETTSelectIdentityViewController.h"
#import "ETTRedisBasisManager.h"
#import "ETTSideNavigationViewController.h"

typedef NS_ENUM(NSInteger,ETTLoginType) {
    ETTLoginFirstInstall = 0,
    ETTLoginAfterUsing
};

@interface ETTLoginViewController : ETTViewController

/**
 添加欢迎页只需要安装的时候出现,使用后不再出现

 @param type 第一次安装初始化还是使用后再进行初始化

 @return
 */
-(instancetype)initWithType:(ETTLoginType)type;
@end
