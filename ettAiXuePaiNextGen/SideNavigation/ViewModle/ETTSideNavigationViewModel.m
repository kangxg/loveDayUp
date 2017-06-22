//
//  ETTSideNavigationViewModel.m
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

#import "ETTSideNavigationViewModel.h"

@implementation ETTSideNavigationViewModel

+(NSString *)getConfigPlistPath
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ETTSideNavigationConfig" ofType:@"plist"];
    return path;
}

+(NSArray *)getArrayForPath:(NSString *)path withIdentity:(ETTSideNavigationViewIdentity)identity
{
    if (!path) {
        path = [self getConfigPlistPath];
    }
    
    NSString *identityStr;
    switch (identity) {
        case ETTSideNavigationViewIdentityStudent:
            identityStr = @"Student";
            break;
        case ETTSideNavigationViewIdentityTeacher:
            identityStr = @"Teacher";
            break;
        case ETTSideNavigationViewIdentityObserveStudents:
            identityStr = @"ObserveStudents";
            break;
        default:
            break;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *arr;
    for (id obj in dic) {
        if ([identityStr isEqualToString:obj]) {
            arr = [dic objectForKey:obj];
            break;
        }
    }
    return arr;
}

+(void)teacherPublishMessage:(NSString *)channelNameStr messag:(NSDictionary *)messageDic intervalTime:(NSTimeInterval)time respondHandler:(RespondHandler)respondHandler
{
    ETTUserIDForLoginModel *userModel = [ETTUSERDefaultManager getUserTypeModelWithType:ETTUSERDefaultTypeTeacher];
    NSString *schoolId = userModel.schoolId;
    NSString *channelName;
    if (!channelNameStr||[channelNameStr isEqualToString:@""]) {
        channelName = [NSString stringWithFormat:@"%@%@",kPCI_SCHOOLCHANNEL,schoolId];
    }else{
        channelName = channelNameStr;
    }
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    [redisManager channelPublishMessage:channelName message:messageDic intervalTime:kREDIS_CHANNEL_DEFAULT_INTERVAL respondHandler:^(id value, id error) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:messageDic];
        if (!error) {
            
        }else{
            NSLog(@"%@ 消息推送失败!",dic[@"mid"]);
        }
    }];

}

-(void)receivingSubcribtionChannel:(NSArray *)channelArray
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    [redisManager receivingSubcribtionDataWithObserver:nil channelNameArray:channelArray respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"%@订阅成功!~~~~~",value);
        }else{
            NSLog(@"%@订阅失败!",channelArray);
        }
    } subscribeMessage:^(NSString *message) {
    }];
}

@end
