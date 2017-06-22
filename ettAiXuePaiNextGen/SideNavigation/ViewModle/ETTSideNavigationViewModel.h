//
//  ETTSideNavigationViewModel.h
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
//  Created by zhaiyingwei on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTSideNavigationViewControllerDelegate.h"
#import "ETTRedisBasisManager.h"
#import "ETTUserIDForLoginModel.h"
#import "ETTUSERDefaultManager.h"
#import "ETTRedisManagerConst.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTUSERDefaultManager.h"

@protocol ETTSideNavigationRedisChannelDelegate <NSObject>

@optional

@end

@interface ETTSideNavigationViewModel : NSObject

@property (nonatomic,weak)id<ETTSideNavigationRedisChannelDelegate> MDelegate;

///获得plist文件路径。
+(NSString *)getConfigPlistPath;

///获得plist文件中的数据。
+(NSArray *)getArrayForPath:(NSString *)path withIdentity:(ETTSideNavigationViewIdentity)identity;

///教师channel推送消息
+(void)teacherPublishMessage:(NSString *)channelNameStr messag:(NSDictionary *)messageDic intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler;

-(void)receivingSubcribtionChannel:(NSArray *)channelArray;

@end
