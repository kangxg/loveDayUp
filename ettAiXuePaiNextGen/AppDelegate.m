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
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTReachability.h"
#import "ETTRedisTestViewController.h"
#import "ETTSignalHandler.h"
#import "AXPSetPopViewController.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTClearCache.h"


#import "ETTCoreLeadership.h"

#import <UMMobClick/MobClick.h>

typedef void (^RespondHandler) (id value,id error);

@interface AppDelegate ()

@property (nonatomic,weak)      NSString        *channelNameForSchool;
@property (nonatomic,weak)      NSString        *redisIp;
@property (nonatomic,assign)    int             redisPort;
@property (nonatomic,strong)    NSArray         *channelsArray;

@property (nonatomic,strong)    NSMutableArray *teacherClassroomArray;
@property (nonatomic,assign)    BOOL isInArray;

@property (nonatomic,strong)    UIApplication   *mApplicaiton;

/** 全局网络状态 */
@property (nonatomic,strong)    ETTReachability *reachability;
@property (nonatomic,assign)    NetworkStatus   lastNetworkStatus;
@property (nonatomic,strong)    UILabel         *showNetworkStatusLabel;

@property (nonatomic)           BOOL            show;// 是否显示绿色的重建课堂界面



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    
    /*
     new      : ADD
     time     : 2017.3.30  11:57
     modifier : 徐梅娜
     branch   ：origin/bugfix/AIXUEPAIOS-1298
     describe : 友盟收集信息 只在release状态下进行统计
     */

    UMConfigInstance.appKey = kUMCountAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    [[ETTCoreLeadership fastCoreLeadership]establishmentNational:application];
    
    ////////////////////////////////////////////////////////
    /*
     new      : ADD
     time     : 2017.3.30  11:57
     modifier : 康晓光
     version  ：bugfix/Epic-0322-AIXUEPAIOS-1124
     branch   ：bugfix/Epic-0322-AIXUEPAIOS-1124／AIXUEPAIOS-0322-984
     describe : 注册系统常用的崩溃信号量
     */
    [ETTSignalHandler Instance];
    /////////////////////////////////////////////////////
    if ([self isFirstLoad]) {// 第一次打开或者更新
        [ETTUSERDefaultManager setAppInstallState:YES];
    }else{
        [ETTUSERDefaultManager setAppInstallState:NO];
    }
    ///启动APP后，设备常亮.
    application.idleTimerDisabled = YES;
    
    NSString *appId = [ETTUSERDefaultManager getAppId];
    if (!appId) {
        [ETTUSERDefaultManager setAppId];
    }
    
    _mApplicaiton = application;
    [ETTRedisBasisManager sharedRedisManager].mDataSource = self;
    [self createUSERNotification];
    
    [self createNotification];
    
    /**
     网络状态判断
     @param checkUpNetStatus: 网络状态
     @return
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkUpNetStatus:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [ETTReachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
    
    
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  10:53
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1188
     describe : 老师端中途退出再登陆后出现登陆界面
     */

    
    NSMutableDictionary *lastClassroomStateDic = [ETTUserInformationProcessingUtils getLastClassroomState];
    
    if (lastClassroomStateDic) {
        if ([lastClassroomStateDic[@"identity"]isEqualToString:@"teacher"]) {
            NSString *startState = [ETTUSERDefaultManager getStartPageState];
            NSLog(@"startState===%@",startState);
            [self beginApp];
            if (!startState)
            {
                self.show = NO;
            }else{
                self.show = YES;
            }
        }else{
            [self startApp:_mApplicaiton];
        }
        
    }
    else
    {   
        /**
         *  @author LiuChuanan, 17-04-11 17:58:57
         *  
         *  @brief 程序已启动起来白屏问题
         *
         *  branch origin/bugfix/AIXUEPAIOS-1203
         *   
         *  Epic   origin/bugfix/Epic-0407-AIXUEPAIOS-1175
         * 
         *  @since 
         */
        [self startApp:_mApplicaiton];

    }

    
    /////////////////////////////////////////////////////
    
    /**
     *  @author LiuChuanan, 17-04-01 15:42:57
     *  
     *  @brief 程序已启动的时候判断缓存大小,然后清除缓存
     *
     *  branch origin/bugfix/AIXUEPAIOS-1166
     *   
     *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
     * 
     *  @since 
     */
    [self clearCache];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 是否第一次打开或者更新完之后第一次打开
- (BOOL)isFirstLoad{
    
    NSDictionary *currentDic = [[NSBundle mainBundle] infoDictionary];
    // 当前使用的版本
    NSString *currentVersion = [currentDic objectForKey:@"CFBundleShortVersionString"];
    // 上一次打开的版本
    NSString *lastRunVersion = [ETTUSERDefaultManager getVersionId];
    // 如果上一次版本不存在,说明是第一次打开
    if (!lastRunVersion) {
        [ETTUSERDefaultManager setVersionId:currentVersion];
        return YES;
    }
    // 如果上一次版本存在且不与当前版本相同,说明程序已更新
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [ETTUSERDefaultManager setVersionId:currentVersion];
        return YES;
    }
    return NO;
}

/**
 *  @author LiuChuanan, 17-04-01 15:42:57
 *  
 *  @brief 程序已启动的时候判断缓存大小,然后清除缓存
 *
 *  branch origin/bugfix/AIXUEPAIOS-1166
 *   
 *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
 * 
 *  @since 
 */
- (void)clearCache
{
    ETTClearCache *clearCahce = [[ETTClearCache alloc]init];
    
    //获取缓存路径
    NSString *folder = [clearCahce getCachePath:@"ETTDownloadCache"];
    
    //计算目录缓存文件大小
    float cache = [clearCahce folderSizeAtPath:folder];
    
    NSLog(@"cache大小 %.2f",cache);
    
    if (cache >= 100.0) 
    {
        [clearCahce clearCacheAtPath:folder];
    }
}

-(void)beginApp
{
    ETTStartupPageupViewController *startPageVC = [[ETTStartupPageupViewController alloc]init];
    [self.window setRootViewController:startPageVC];
    startPageVC.MDelegate = self;

}

// 动画启动页后自动调用直接进入课堂 在ETTStartupPageupViewController中调用
-(void)didTheEndOfTheAnimationPlaybackWithConfics:(BOOL)reconnet
{
    
    if (!reconnet||!self.show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startApp:_mApplicaiton];
        });
    }else{
    NSMutableDictionary *lastClassroomStateDic = [ETTUserInformationProcessingUtils getLastClassroomState];
    if (lastClassroomStateDic) {
        if ([lastClassroomStateDic[@"identity"]isEqualToString:@"teacher"]) {
            ETTReconnectionViewController * vctr = [[ETTReconnectionViewController alloc]init];
            self.window.rootViewController = vctr;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.window.rootViewController isKindOfClass:[ETTReconnectionViewController class]]) {
                    [self startApp:_mApplicaiton];
                }
            });
        }
    }
    }
}

-(void)startApp:(UIApplication *)application
{
    self.isInArray = NO;

    
//    [self createNotification];

    NSMutableDictionary *lastClassroomStateDic = [ETTUserInformationProcessingUtils getLastClassroomState];
    if (lastClassroomStateDic) {
        if ([lastClassroomStateDic[@"type"]isEqualToString:@"CLOSE"]) {
            [self createApp:application];
        }else{
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
}

-(void)startStudentApp:(UIApplication *)application
{
    NSMutableDictionary *lastClassroomStateDic = [ETTUserInformationProcessingUtils getLastClassroomState];
    if (lastClassroomStateDic)
    {
        if ([lastClassroomStateDic[@"type"]isEqualToString:@"CLOSE"]) {
            [self createApp:application];
        }else
        {
          [[[ETTAppDelegateUtil alloc]init]studentRestartAPP:application lastClassroomMessageDic:lastClassroomStateDic];
        }

    }
    else
    {
        [self createApp:application];
    }
    [self.window makeKeyAndVisible];
}
/**
 网络状态判断notify
 
 @param noti
 */
- (void)checkUpNetStatus:(NSNotification *)noti {
    
    ETTReachability *reach = [noti object];
    
    if (self.lastNetworkStatus == [reach currentReachabilityStatus]) {
        ETTLog(@"上次缓存网络状态与这次相同");
    } else {
        
        if (self.lastNetworkStatus != NotReachable) {
            ETTLog(@"当前无网络");
            [ETTCoursewarePresentViewControllerManager sharedManager].isCanReachNetwork = NO;
            self.lastNetworkStatus = [reach currentReachabilityStatus];
            _showNetworkStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
            _showNetworkStatusLabel.text = @"当前没有网络";
            _showNetworkStatusLabel.layer.cornerRadius = 5.0;
            _showNetworkStatusLabel.clipsToBounds = YES;
            _showNetworkStatusLabel.textColor = [UIColor whiteColor];
            _showNetworkStatusLabel.textAlignment = NSTextAlignmentCenter;
            _showNetworkStatusLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _showNetworkStatusLabel.center = self.window.center;
            [self.window addSubview:_showNetworkStatusLabel];
            
        } else {
            ETTLog(@"当前有网络");
            [ETTCoursewarePresentViewControllerManager sharedManager].isCanReachNetwork = YES;
            self.lastNetworkStatus = [reach currentReachabilityStatus];
            [self.showNetworkStatusLabel removeFromSuperview];
        }
    }
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
    if ([ETTUSERDefaultManager getAppInstallState]) {
        self.window.rootViewController = [[ETTLoginViewController alloc]initWithType:ETTLoginFirstInstall];
    }else{
        self.window.rootViewController = [[ETTLoginViewController alloc]initWithType:ETTLoginAfterUsing];
    }
    
}

#pragma mark - redis操作方法
-(instancetype)createNotification
{
    ///监听创建学校监听频道的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRedisMonitorSchoolNotificationHandler:) name:kREDIS_MONITOR_SCHOOL_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReloadAppHandler:) name:@"ReloadApp" object:nil];
    return self;
}

// ReloadApp的接收通知方法
-(void)onReloadAppHandler:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self startApp:_mApplicaiton];
    });
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
    ETTRedisBasisManager * redisManager = [ETTRedisBasisManager sharedRedisManager];
    [redisManager initWithServerHost:_redisIp port:_redisPort];
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
                for (int i=0; i<[oldArr count]; i++)
                {
                    NSDictionary *oldDic = [NSDictionary dictionaryWithDictionary:[oldArr objectAtIndex:i]];
                    if ([[oldDic objectForKey:@"mid"]isEqualToString:[dic objectForKey:@"mid"]])
                    {
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
            if (([nowTime integerValue]-oldTime)>kREDIS_CONNECT_DEFAULT_INTERVAL*kREDIS_CONNECT_SCALE) {
                [oldArr removeObjectAtIndex:i];
            }
        }
        
        WS(weakSelf);
        dispatch_group_async(group, dispatch_get_main_queue(), ^{
            __strong id strongSelf = weakSelf;
            [strongSelf postStudentChooseTeacherDataSource:oldArr];
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
    //NSLog(@"appdelegate 收到消息 %@",message);
    NSDictionary *dic = [ETTRedisBasisManager getDictionaryWithJSON:message];
    NSString *currentTypeStr = [ETTUSERDefaultManager getCurrentIdentity];
    NSString *typeStr = [NSString stringWithFormat:@"%@",@([[dic objectForKey:@"type"] intValue])];
    if ([typeStr isEqualToString:@"1"]) {
        [self onStudentChooseClassroomDataJudgmentHandler:dic];
    }else{
        if ([currentTypeStr isEqualToString:@"teacher"]) {
            [ETTUserInformationProcessingUtils teacherProcessChannelInformation:message];
        }else{
            if (![dic[@"type"] isEqualToString:@"CP_01"]) {
                AXPSetPopViewController *pop = (AXPSetPopViewController *)[[AXPWhiteboardToolbarManager sharedManager].vc presentedViewController];
                if ([pop isKindOfClass:[AXPSetPopViewController class]]||[pop isKindOfClass:[UIImagePickerController class]]) {
                    [pop dismissViewControllerAnimated:YES completion:nil];
                }
            }
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    application.idleTimerDisabled = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.idleTimerDisabled = YES;
}


/**
 *  @author LiuChuanan, 17-04-12 17:42:57
 *  
 *  @brief 应用进入后台后,更改学生课堂恢复的状态
 *
 *  branch origin/bugfix/AIXUEPAIOS-1201
 *   
 *  Epic   origin/bugfix/Epic-0411-AIXUEPAIOS-1176
 * 
 *  @since 
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [ETTBackToPageManager sharedManager].isHavenRecovery = NO;
}



@end
