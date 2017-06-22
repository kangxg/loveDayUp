//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "ETTSideNavigationViewController.h"
#import "ETTLoginViewController.h"
#import "ETTSelectIdentityViewController.h" //选择用户测试页面，暂时使用
#import "ETTUserIDForLoginModel.h"
#import "ETTUSERDefaultManager.h"
#import "ETTRemindTestVCTR.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTStudentClassPerformanceVCTR.h"
#import "ETTAppDelegateUtil.h"
#import "ETTRedisTestViewController.h"
#import "ETTLocalMessageNotificationBasics.h"
//#import <UserNotifications/UserNotifications.h>

typedef void (^RespondHandler) (id value,id error);

@interface AppDelegate ()

@property (nonatomic,weak)  NSString        *channelNameForSchool;
@property (nonatomic,weak)  NSString        *redisIp;
@property (nonatomic,assign)int             redisPort;
@property (nonatomic,strong)NSArray         *channelsArray;

@property (nonatomic,strong) NSMutableArray *teacherClassroomArray;
@property (nonatomic,assign) BOOL isInArray;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    self.isInArray = NO;
    [ETTRedisBasisManager sharedRedisManager].mDataSource = self;
    
//    ETTRedisTestViewController *testVC = [[ETTRedisTestViewController alloc]init];
//    self.window.rootViewController = testVC;
    
    [self createUSERNotification];
    
    [self createNotification];
    NSMutableDictionary *lastClassroomStateDic = [ETTUserInformationProcessingUtils getLastClassroomState];
    if (lastClassroomStateDic) {
        if ([lastClassroomStateDic[@"type"]isEqualToString:@"CLOSE"]) {
            [self createApp:application];
        }else{
            ///显示重连默认提示页
            ETTReconnectionViewController *recVC = [[ETTReconnectionViewController alloc]init];
            self.window.rootViewController = recVC;
            ///判断重连者身份
            if ([lastClassroomStateDic[@"identity"]isEqualToString:@"teacher"]) {
                [[[ETTAppDelegateUtil alloc]init]teacherRestartAPP:application lastClassroomMessageDic:lastClassroomStateDic];
            }else{
                [[[ETTAppDelegateUtil alloc]init]studentRestartAPP:application lastClassroomMessageDic:lastClassroomStateDic];
            }
        }
    }else{
        [self createApp:application];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)createUSERNotification
{
    [[ETTLocalMessageNotificationBasics sharedLocalNotification]registerUSERNotification];
}

/**
 创建新的课堂登录功能
 */
-(void)createApp:(UIApplication *)application
{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    //  self.window.rootViewController = [[ETTRemindTestVCTR alloc]init];
    self.window.rootViewController = [[ETTLoginViewController alloc]init];
    //    self.window.rootViewController = [[ETTSideNavigationViewController alloc]init];
    //    self.window.rootViewController = [[ETTSelectIdentityViewController alloc]init];
    //        self.window.rootViewController = [[ETTRedisNewTestViewController alloc]init];
    
    //    ETTNavigationController  * nav = [[ETTNavigationController  alloc]initWithRootViewController:[[ETTStudentClassPerformanceVCTR alloc]init]];
    //    self.window.rootViewController =  nav;;
}

#pragma mark - redis操作方法
-(instancetype)createNotification
{
    ///监听创建学校监听频道的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRedisMonitorSchoolNotificationHandler:) name:kREDIS_MONITOR_SCHOOL_NOTIFICATION object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    return self;
}

-(void)onRedisMonitorSchoolNotificationHandler:(NSNotification *)notification
{
    _teacherClassroomArray = [NSMutableArray array];
    ETTUserIDForLoginModel *userModel = [ETTUserInformationProcessingUtils getUserIDForLoginModel];
    _redisIp = userModel.redisIp;
    _redisPort = userModel.redisPort.intValue;
    NSString *schoolId = userModel.schoolId;
    _channelNameForSchool = [NSString stringWithFormat:@"%@%@",kPCI_SCHOOLCHANNEL,schoolId];
    _channelsArray = @[_channelNameForSchool];
    ETTRedisBasisManager *redisManager = [[ETTRedisBasisManager sharedRedisManager]initWithServerHost:_redisIp port:_redisPort];
    [redisManager allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
        if (error) {
            NSLog(@"appdelegate 链接redis失败!");
        }else{
            NSLog(@"appdelegate 链接redis成功!");
            [redisManager receivingSubcribtionDataWithObserver:nil channelNameArray:_channelsArray respondHandler:^(id value, id error) {
                if(!error){
                    NSLog(@"%@ 订阅成功！",value);
                }else{
                    NSLog(@"%@ 订阅失败！",_channelsArray);
                }
            } subscribeMessage:^(NSString *message) {
                
            }];
        }
    }];
}

#pragma mark - 学生选择课堂数据源有效判断
-(void)onStudentChooseClassroomDataJudgmentHandler:(NSDictionary *)dic
{
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"student"]) {
    
        _teacherClassroomArray = [self processingArray:_teacherClassroomArray withDictionary:dic type:1];
    }
}

///对数据源进行按时间、种类进行筛选，在最后一个更新以后，要再过制定时间检查数据的有效性。
-(NSMutableArray *)processingArray:(NSMutableArray *)oldArr withDictionary:(NSDictionary *)dic type:(int)typeInt
{
    _isInArray = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_CONCURRENT);
    @synchronized (self) {
        if (dic) {
            if ([oldArr count]==0) {
                [oldArr addObject:dic];
            }else{
                for (int i=0; i<[oldArr count]; i++) {
                    NSDictionary *oldDic = [NSDictionary dictionaryWithDictionary:[oldArr objectAtIndex:i]];
                    if ([[oldDic objectForKey:@"mid"]isEqualToString:[dic objectForKey:@"mid"]]) {
                        [oldArr replaceObjectAtIndex:i withObject:dic];
                        _isInArray = YES;
                    }
                }
                
                if (_isInArray == NO) {
                    [oldArr addObject:dic];
                }
            }
        }
        
        NSString *nowTime = [ETTRedisBasisManager getTime];
        for (int i=0; i<[oldArr count]; i++) {
            NSDictionary *nowDic = [NSDictionary dictionaryWithDictionary:[oldArr objectAtIndex:i]];
            NSInteger oldTime = [[nowDic objectForKey:@"time"]integerValue];
            if (([nowTime integerValue]-oldTime)>kREDIS_CONNECT_DEFAULT_INTERVAL) {
                [oldArr removeObjectAtIndex:i];
            }
        }

        WS(weakSelf);
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            [weakSelf postStudentChooseTeacherDataSource:oldArr];
        });
    
    }
    
    dispatch_group_notify(group, queue, ^{
        if (typeInt) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (kREDIS_CONNECT_DEFAULT_INTERVAL+1) * NSEC_PER_SEC);
            dispatch_queue_t tQueue = dispatch_queue_create("ett", DISPATCH_QUEUE_SERIAL);
            WS(weakSelf);
            dispatch_after(time, tQueue, ^{
                [weakSelf processingArray:oldArr withDictionary:nil type:0];
            });
        }
    });
    return oldArr;
}

#pragma mark - 更新选择课程的数据源
-(void)postStudentChooseTeacherDataSource:(NSArray *)dataArr
{
    if (dataArr)
    {

        [[NSNotificationCenter defaultCenter]postNotificationName:kREDIS_CREATE_CLASSROOM_DATASOURCES object:dataArr];
        

    }
}

#pragma mark ----- ETTRedisBasisDelegate ------
-(void)processChannelMessage:(NSString *)message
{

    NSDictionary *dic = [ETTRedisBasisManager getDictionaryWithJSON:message];
    NSString *currentTypeStr = [ETTUSERDefaultManager getCurrentIdentity];
    NSString *typeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    if ([typeStr isEqualToString:@"1"]) {
        [self onStudentChooseClassroomDataJudgmentHandler:dic];
    }else{
        NSLog(@"AppDelegate processChannelMessage %@",message);
        
        if ([currentTypeStr isEqualToString:@"teacher"]) {
            [ETTUserInformationProcessingUtils teacherProcessChannelInformation:message];
        }else{
            [ETTUserInformationProcessingUtils studnetProcessChannelInformation:message];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(void)appBecomeActive
{
    NSLog(@"返回前台!");
    [[ETTRedisBasisManager sharedRedisManager]allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
        if (error) {
            
        }else{
            
        }
    }];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    
}

@end
