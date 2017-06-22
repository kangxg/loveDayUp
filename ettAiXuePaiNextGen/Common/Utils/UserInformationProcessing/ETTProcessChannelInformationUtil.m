//
//  ETTProcessChannelInformationUtil.m
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
//  Created by zhaiyingwei on 2016/11/22.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
//  根据channel的type类型做出相应的操作

#import "ETTProcessChannelInformationUtil.h"
#import "ETTRemindManager.h"
#import "ETTLocalMessageNotificationBasics.h"
#import "iToast.h"
#import "ETTScenePorter.h"
#import "ETTCoursewareStackManager.h"
#import "ETTCoursewareStackManager.h"
#import "AppDelegate.h"

@implementation ETTProcessChannelInformationUtil


/**
 学生处理老师发送过来的redis信息
 */
+(void)studentProcessChannelInformationWithMessageDictionary:(NSDictionary *)messageDic;
{
    NSString *type = [messageDic objectForKey:@"type"];
    static NSString *midCopy = @"";
    if ([type isEqualToString:@"CO_01"]) {
        
        //同步进课
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"老师发来新任务，快去看看吧!"];
        }
        //        [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_01 withObject:messageDic];
        if (!(ETTCOURSELOADMODE_HAVINGCLASS == [[ETTCoursewareStackManager new]judgingVideoPlaying])) {
            [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_01 withObject:messageDic];
        }
        
    }else if ([type isEqualToString:@"CO_02"]){
        
        //推课件相关
        NSString *mid = messageDic[@"mid"];
        if (![midCopy isEqualToString:mid]) {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"老师发来新任务，快去看看吧!"];
            }
            [[ETTRemindManager shareRemindManager] deblockingRemindView];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.userInteractionEnabled = NO;
            
            [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_02 withObject:messageDic];
            midCopy = [NSString stringWithFormat:@"%@",mid];
        }
        
    }else if ([type isEqualToString:@"CO_03"]){
        
        //同步音视频
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"老师发来新任务，快去看看吧!"];
        }
        [[ETTRemindManager shareRemindManager] deblockingRemindView];
        [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_03 withObject:messageDic];
    }else if ([type isEqualToString:@"CO_04"]){
        
        //推试卷相关
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"老师发来新任务，快去看看吧!"];
        }
        [[ETTRemindManager shareRemindManager] deblockingRemindView];
        [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_04 withObject:messageDic];
    }else if ([type isEqualToString:@"CO_05"]){
        
        //课程同步刷新
        [self postNotifictionName:kREDIS_COMMAND_TYPE_CO_05 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_01"]){
        
        //白板推送相关
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"老师发来新任务，快去看看吧!"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
        
        [[ETTRemindManager shareRemindManager] deblockingRemindView];
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_01 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_02"])
    {   /**
         白板推送相关WB_02-WB_06没有用到
         */
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_02 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_03"])
    {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_03 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_04"])
    {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_04 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_05"])
    {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_05 withObject:messageDic];
    }else if ([type isEqualToString:@"WB_06"])
    {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_WB_06 withObject:messageDic];
    }else if ([type isEqualToString:@"MA_02"])
    {
        [[ETTRemindManager shareRemindManager]createRemindView:ETTREWARDSVIEW withCount:1];
        
    }else if ([type isEqualToString:@"MA_03"])
    {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [self tellTeacherHeNotInClass];
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"被发现了，快回课堂吧!"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ETTRemindManager shareRemindManager] createRemindView:ETTREMINDVIEW];
            });
        }
    }else if ([type isEqualToString:@"MA_04"])
    {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"提醒" message:@"被发现了，快回课堂吧!"];
            [self tellTeacherHeNotInClass];
        }else{
            [self postNotifictionName:kREDIS_COMMAND_TYPE_MA_04 withObject:messageDic];
        }
    }else if ([type isEqualToString:@"MA_05"])
    {
        [[ETTRemindManager shareRemindManager] createRemindView:ETTLOCKSCREEViEW];
        [[NSNotificationCenter defaultCenter]postNotificationName:kLOCK_SCREEN_PAUSE_VIDEO object:nil userInfo:nil];
        
    }else if([type isEqualToString:@"MA_05_END"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ETTRemindManager shareRemindManager] deblockingRemindView];
        });
    }else if ([type isEqualToString:@"MA_06"])
    {
        [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"点名" message:@"你被点到名字啦!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /**
             *  @author LiuChuanan, 17-04-06 16:42:57
             *  
             *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
             *
             *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
             *   
             *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
             * 
             *  @since 
             */
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.userInteractionEnabled = YES;

            [[ETTRemindManager shareRemindManager] createRemindView:ETTROLLCALLVIEW];
        });
    }else if ([type isEqualToString:@"MA_06_End"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ETTRemindManager shareRemindManager] removeRollCallRemindView];
        });
    }
    else if ([type isEqualToString:@"MA_07_BEGIN"])
    {   
        /**
         *  @author LiuChuanan, 17-04-06 19:42:57
         *  
         *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
         *
         *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
         *   
         *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
         * 
         *  @since 
         */
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.userInteractionEnabled = YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kANSWER_PAUSER_VIDEO object:nil userInfo:nil];
        [[ETTLocalMessageNotificationBasics sharedLocalNotification]presentLocalNotification:@"抢答" message:@"抢答进行中,加快速度返回课堂!"];
        if ([[ETTRemindManager shareRemindManager] getRemindView].YVType != ETTRESPONDERVIEW) {
            NSString *mid = messageDic[@"mid"];
            [ETTUSERDefaultManager setCurrendMA07Mid:mid];
            [[ETTRemindManager shareRemindManager] createRemindView:ETTRESPONDERVIEW];
        }
    }else if ([type isEqualToString:@"MA_07_END"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ETTRemindManager shareRemindManager] removeResponderRemindView];
        });
    }else if ([type isEqualToString:@"CP_01"])
    {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_CP_01 withObject:messageDic];
    }else if ([type isEqualToString:@"CLOSE"]){
        ///学生处理课堂已关闭信息。
        if ([[ETTCoursewareStackManager new]studentProcessTeacherExit]) {
            [[iToast makeText:@"教师已离开课堂!"]show];
        }
        
    }else if ([type isEqualToString:@"PLAY_EACH_OTHER"]){
        NSString *appId = [NSString stringWithFormat:@"%@",messageDic[@"appID"]];
        if ([appId isEqualToString:[ETTUSERDefaultManager getAppId]]) {
            NSLog(@"是自己发的，忽视！");
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:kEXIT object:nil];
        }
    }
}

+(void)teacherProcessChannelInformationWithMessageDictionary:(NSDictionary *)messageDic
{
    NSString *type = [messageDic objectForKey:@"type"];
    if ([type isEqualToString:@"SCO_01"]) {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_SCO_01 withObject:messageDic];
    } else if ([type isEqualToString:@"SWB_02"]) {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_SWB_02 withObject:messageDic];
    }else if ([type isEqualToString:@"SWB_03"]) {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_SWB_03 withObject:messageDic];
    }else if ([type isEqualToString:@"SWB_04"]) {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_SWB_04 withObject:messageDic];
    }else if ([type isEqualToString:@"SMA_07"]) {
        [self postNotifictionName:kREDIS_COMMAND_TYPE_SMA_07 withObject:messageDic[@"userInfo"]];
    }else if ([type isEqualToString:@"SMA_04"]) {
        [self processCommandSMA04:messageDic[@"userInfo"]];
    }else if ([type isEqualToString:@"SMA_OUTSIDE"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertStudentOutSide]; 
        });
    }
}

+(void)tellTeacherHeNotInClass
{
    NSString *classroomChannel = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messageDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                                 @"time":[ETTRedisBasisManager getTime],
                                 @"from":[AXPUserInformation sharedInformation].jid,
                                 @"to":@"XMAN",
                                 @"type":@"SMA_OUTSIDE"};
    NSString *messJSON = [ETTRedisBasisManager getJSONWithDictionary:messageDic];
    NSLog(@"查看功能--开始通知老师!");
    [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:classroomChannel message:messJSON respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"学生查看信息发送成功!");
        }else{
            NSLog(@"学生查看息发送失败!");
        }
    }];
}

+(void)alertStudentOutSide
{
    NSLog(@"该学生游离于课堂之外!");
    [[iToast makeText:@"该学生不在应用内！"]show];
}

#pragma mark - 教师显示学生的当前状态


///PHP缓存图片的处理方法
+(void)processCommandSMA04:(NSDictionary *)dict
{
    NSString *cacheAddressUrl = [NSString stringWithFormat:@"%@",dict[@"CacheAddressUrl"]];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@",[AXPUserInformation sharedInformation].redisIp,cacheAddressUrl];
    NSURL *cacheUrl = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:cacheUrl];
    if (imageData) {
        NSLog(@"查看功能教师获取图片成功！");
        UIImage *im = [UIImage imageWithData:imageData];
        [[ETTScenePorter shareScenePorter].EDViewRecordManager viewRecord:NSStringFromClass([ETTShowUserCurrentOperationView class]) view:nil];
        ETTShowUserCurrentOperationView * lookview = [[ETTShowUserCurrentOperationView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-kIMAGE_WIDTH_VIEW_STUDENT)/2.0, (kSCREEN_HEIGHT-kIMAGE_HEIGHT_VIEW_STUDENT)/2.0, kIMAGE_WIDTH_VIEW_STUDENT, kIMAGE_HEIGHT_VIEW_STUDENT) withImag:im];
        [lookview showView];
    }else{
        NSLog(@"加载图片出错:%s --> %d",__FILE__,__LINE__);
    }
}

+(void)postNotifictionName:(NSString *)notificationName withObject:(id)object
{
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:object];
}

@end
