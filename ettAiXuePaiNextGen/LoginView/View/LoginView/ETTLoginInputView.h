//
//  ETTLoginInputView.h
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
#import "ETTLoginViewConst.h"
#import "ETTUSERDefaultManager.h"

typedef NS_ENUM(NSInteger,ETTLoginInputViewType)
{
    //可用(id,password都不为空)
    ETTLoginInputViewTypeAvailable,
    //不可用(id,password有nil值)
    ETTLoginInputViewTypeUnAvailable
};

@protocol ETTLoginInputViewDelegate <NSObject>

@optional
/**
 *  判断当前textField的状态，当不为空时，调用该方法。
 *
 *  @param dic @"id"账号，@"password"密码，@"status"按钮是否可用@"YES"@"NO"
 */
-(void)judgmentStatus:(NSDictionary *)dic;

-(void)stopLoginButton;

-(void)updateDefaultIcon;

-(void)updateUserIcon;

@end

@interface ETTLoginInputView : ETTView <UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong)id<ETTLoginInputViewDelegate> MDelegate;

/*
 *  获得当前用户的登录信息
 *
 *  return Dictionary @"id"：用户ID,@"password"：密码,@"selected" YES:选中记录密码，NO:没有选中记录密码。
 */
-(NSDictionary *)getUSERMessage;

-(ETTLoginInputViewType)getStatus;

@end
