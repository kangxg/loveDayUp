//
//  ETTSideNavigationViewController.m
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

#import "ETTSideNavigationViewController.h"
#import "AXPWhiteboardViewController.h"
#import "ReaderViewController.h"
#import "AXPRedisManager.h"
#import "ETTStudentVideoAudioViewController.h"
#import "ETTSynchronizeStatus.h"
#import "ETTStudentTestPaperDetailViewController.h"
#import "AXPUserInformation.h"
#import "ETTUSERDefaultManager.h"
#import "AppDelegate.h"
#import "ETTLoginViewController.h"
#import "ETTDownloadManager.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTStudentManageViewController.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTJudgeIdentity.h"
#import <Masonry.h>
#import "ETTCoursewarePushDataManager.h"
#import "UIViewController+RootViewController.h"
#import "ETTScenePorter.h"
#import "ETTScenePorterDelegate.h"
#import "ETTCoursewareStackManager.h"
#import "ETTAboutView.h"
#import "AXPWhiteboardToolbarManager.h"
#import "NSString+ETTDeviceType.h"
#import "ETTStudentRecoveryClass.h"
#import "ETTAnouncement.h"
#import "ETTGovernmentTask.h"

@interface ETTSideNavigationViewController ()<ETTBackPageDelegate,ReaderViewControllerDelegate,ETTScenePorterDelegate>

@property (nonatomic, strong) ETTMaskingView                          *mV;

/**
 *  @author LiuChuanan, 17-05-08 14:07:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 5
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic, strong) ETTDockView                             *dock;

/**
 *  @author LiuChuanan, 17-05-08 14:07:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 6
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic, strong) ETTView                                 *contentView;

/**
 *  @author LiuChuanan, 17-05-08 14:07:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 4
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,weak ) id<ETTSideNavigationViewControllerDelegate> MDelegate;

@property (nonatomic,assign ) ETTSideNavigationViewStates             states;

@property (nonatomic,assign ) ETTMaskStates                           maskStates;

@property (copy, nonatomic  ) NSString                                *ETTDownloadCache;
@property (nonatomic,weak   ) ETTStudentSelectTeacherModel            *studentSelectTeacherModel;

@property (copy, nonatomic  ) NSString                                *lastcoursewareName;

@property (copy, nonatomic  ) NSString                                *pushTestPaperState;//老师推试卷的状态

@property (copy, nonatomic  ) NSString                                *lastMid;

@property (copy, nonatomic  ) NSString                                *testPaperLastMid;

@property (strong, nonatomic) NSMutableDictionary                     *lastCoursewareDict;

@property (copy, nonatomic  ) NSString                                *lastCoursewareUrl;

@property (copy, nonatomic  ) NSString                                *pushedTestPaperId;//老师每次推送试卷的id,唯一值,用于筛选答案

@property (strong, nonatomic) ETTCoursewarePushDataManager            *pushDataManager;

@property (nonatomic,weak   ) ETTSideNavigationViewModel              *sideViewModel;

@property (nonatomic,weak   ) ETTViewController                       *studentManagerObj;//用于学生管理页面的引用。

@property (nonatomic,strong ) UIControl                               *maskView;// 遮盖

@property (nonatomic,strong ) ETTAboutView                            *aboutView;

@property (nonatomic,retain ) ETTScenePorter                          * MVScenePorter;
@end

@implementation ETTSideNavigationViewController


-(instancetype)initWithModel:(ETTOpenClassroomDoBackModel *)model
{
    if (self = [super init]) {
        _openClassroomModel = model;
    }
    return self;
}

#pragma mark ----- 主导航功能初始化方法 ------
/**
 正常创建、进入课堂的方法。

 @param model 初始化信息
 @param identity 用户身份
 @return self
 */
-(instancetype)initWithModel:(id)model forIdentity:(ETTSideNavigationViewIdentity)identity
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  10:54
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
     describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
     */

    //[ETTUSERDefaultManager setReconnectionClass:YES];
    /////////////////////////////////////////////////////
    /***************************************************
     教师同事教师退出。
     ***************************************************/

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appExit) name:kEXIT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(classClosedHandler) name:kCLASS_CLOSED object:nil];
    
    if (self = [super init]) {
        
        AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
        
        if ([model isKindOfClass:[ETTOpenClassroomDoBackModel class]]) {
            
            [ETTUSERDefaultManager setCurrentIdentity:@"teacher"];
            
            _openClassroomModel            = model;
            
            //获取登录信息保存到单例类中,课程中会用到这些数据
            userInformation.classroomId    = _openClassroomModel.classroomId;
            userInformation.userType       = [ETTUSERDefaultManager getCurrentIdentity];
            userInformation.gradeId        = _openClassroomModel.gradeId;
            userInformation.subjectId      = _openClassroomModel.subjectId;
            userInformation.jid            = _openClassroomModel.jid;
            userInformation.schoolId       = _openClassroomModel.schoolId;
            NSString *schoolChannelName    = [NSString stringWithFormat:@"%@%@",kPCI_SCHOOLCHANNEL,_openClassroomModel.schoolId];
            NSString *classroomChannelName = [NSString stringWithFormat:@"%@%@",_openClassroomModel.classroomId,kPCI_CLASSROOM_CHANNEL];
            NSArray *channelArray          = @[schoolChannelName,classroomChannelName];
            
            //dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
            
            dispatch_queue_t qt = dispatch_queue_create("free", DISPATCH_QUEUE_SERIAL);
            WS(weakSelf);
            dispatch_async(qt, ^{
                ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
                /***************************************************
                 此处[AXPUserInformation sharedInformation].redisIp在恢复课堂的时候
                 并没有被赋值，直接调用为nil。
                 Johnny
                 2017.03.27
                 ***************************************************/
                NSString *redisIp = [AXPUserInformation sharedInformation].redisIp;
                if (redisIp == nil)
                {
                    redisIp = [ETTUSERDefaultManager getRedisIp];
                }
                if (redisIp)
                {
                    [redisManager initWithServerHost:redisIp port:0];
                    
                    [redisManager allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
                        if (error) {
                            NSLog(@"sidenavigation 链接redis失败!");
                        }else{

                            [weakSelf createChannelMonitor:channelArray];

                            
                            /*
                              2017.5.4  14:35  KXG-AIXUEPAIOS-1141
                             */
                            [weakSelf connectTaskComplete];

                            //dispatch_semaphore_signal(semaphore);
                            [weakSelf teacherGetStudentOnlineInformationWithClassroomId:userInformation.classroomId];
                            [weakSelf postNotifictaionWithModel];

                            
                            [ETTUserInformationProcessingUtils playEachOther:userInformation.classroomId withJid:userInformation.jid];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //教师获取学生的在线信息
                            
                                
                            
                            });
                            
                        }
                        [ETTUserInformationProcessingUtils setClassroomState:@"FREE" classroomId:[NSString stringWithFormat:@"%@",_openClassroomModel.classroomId] identity:[ETTUSERDefaultManager getCurrentIdentity] withMessage:[_openClassroomModel getDictionaryWithModle]];
                    }];
                }
            });
            
    

            _MVScenePorter = [ETTScenePorter shareScenePorter];
            _MVScenePorter.EVPorterDelegate = self;
            

        }else if ([model isKindOfClass:[ETTStudentSelectTeacherModel class]])
        {
            _studentSelectTeacherModel        = model;

            userInformation.classroomId       = _studentSelectTeacherModel.classroomId;
            userInformation.userType          = [ETTUSERDefaultManager getCurrentIdentity];
            userInformation.subjectId         = _studentSelectTeacherModel.subjectId;
            userInformation.gradeId           = _studentSelectTeacherModel.gradeId;

            ETTUserIDForLoginModel *userModel = [ETTUserInformationProcessingUtils getUserIDForLoginModel];

            userInformation.jid               = userModel.jid;
            userInformation.schoolId          = userModel.schoolId;
            userInformation.redisIp           = userModel.redisIp;
            userInformation.userName          = userModel.userName;
            userInformation.userPhoto         = userModel.userPhoto;
            userInformation.paperRootUrl      = userModel.paperRootUrl;

            NSString *schoolChannelName       = [NSString stringWithFormat:@"%@%@",kPCI_SCHOOLCHANNEL,userModel.schoolId];
            NSString *classroomChannelName    = [NSString stringWithFormat:@"%@%@",userInformation.classroomId,kPCI_CLASSROOM_CHANNEL];
            NSArray *channelArray             = @[schoolChannelName,classroomChannelName];
            
            NSString *currentIdentityStr;
            switch ([ETTUserInformationProcessingUtils determineStudentIdentity:userModel.jid inClassList:_studentSelectTeacherModel.classList]) {
                case ETTSideNavigationViewIdentityStudent:
                    currentIdentityStr = @"student";
                    break;
                case ETTSideNavigationViewIdentityObserveStudents:
                    currentIdentityStr = @"ObserveStudents";
                    break;
                default:
                    break;
            }
            
            [ETTUserInformationProcessingUtils setClassroomState:@"FREE" classroomId:_studentSelectTeacherModel.classroomId identity:[ETTUSERDefaultManager getCurrentIdentity] withMessage:nil];
            
            NSDictionary *dic = @{@"jid":userModel.jid,
                                  @"userName":userModel.userName,
                                  @"classroomId":_studentSelectTeacherModel.classroomId,
                                  @"lastScoreTime":userModel.userName,
                                  @"userPhoto":userModel.userPhoto,
                                  @"identity":currentIdentityStr,
                                  @"time":[ETTRedisBasisManager getTime]};
            NSMutableDictionary *informationDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            dispatch_queue_t qt = dispatch_queue_create("free", DISPATCH_QUEUE_CONCURRENT);
            WS(weakSelf);
            dispatch_async(qt, ^{
                //学生更新自己的在线信息
                [[ETTRedisBasisManager sharedRedisManager]allObjectCreateConnectWithPassword:nil respondHandler:^(id value, id error) {
                    if (error) {
                        NSLog(@"学生再次创建链接!");
                    }else{
                        
                        [weakSelf updateStudentOnlineInformation:informationDic];
                        [weakSelf createChannelMonitor:channelArray];
                        
                        /*
                         2017.5.4  14:35  KXG-AIXUEPAIOS-1141
                         */
                        [weakSelf connectTaskComplete];
                        
                        [ETTUserInformationProcessingUtils playEachOther:userInformation.classroomId withJid:userInformation.jid];
                    }
                }];

            }) ;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onMA04Handler:) name:kREDIS_COMMAND_TYPE_MA_04 object:nil];
        }
        if (ETTSideNavigationViewIdentityTeacher == identity) {
            [self setIdentity:identity];
        }else if (ETTSideNavigationViewIdentityStudent == identity||ETTSideNavigationViewIdentityObserveStudents == identity)
        {
            [self setIdentity:identity];
            if (ETTSideNavigationViewIdentityObserveStudents == identity) {
                [ETTUSERDefaultManager setCurrentIdentity:@"ObserveStudents"];
            }
        }
    }
    
    return self;
}





#pragma mark ---------------------------
#pragma mark ----- 创建频道监听 ------
-(void)createChannelMonitor:(NSArray *)channelArray
{
    ETTSideNavigationViewModel *sideModel = [ETTSideNavigationViewModel new];
    sideModel.MDelegate = self;
    [sideModel receivingSubcribtionChannel:channelArray];
}

#pragma mark ----- 学生更新在线信息 ------
-(void)updateStudentOnlineInformation:(NSMutableDictionary *)informationDic
{
    [self processClassroomState];
    ETTUserInformationProcessingUtils *userUtils = [ETTUserInformationProcessingUtils new];
    [userUtils updateStudentOnlineInformation:informationDic];
}

#pragma mark ----- 老师获得学生的在线信息 ------
-(void)teacherGetStudentOnlineInformationWithClassroomId:(NSString *)classroomId
{
    NSString *key = [NSString stringWithFormat:@"%@%@",classroomId,kPCI_STUDENT_MANAGEMENT];
    [self processClassroomState];
    ETTUserInformationProcessingUtils *userUtils = [ETTUserInformationProcessingUtils new];
    [userUtils teacherGetStudentOnlineInformationWith:key callBackHandler:^(id value, NSError *error) {
        if (!error) {
            //NSLog(@"获得数据！---%@",value);
            [_studentManagerObj refreshClassOnlinePersonnelInformation:(NSDictionary *)value];
        }else{
            NSLog(@"获取数据失败!---%@",error);
        }
    }];
}

#pragma mark - 开始redis
-(instancetype)postNotifictaionWithModel
{
    NSNumber *time = (NSNumber *)[ETTRedisBasisManager getTime];

    ETTUserIDForLoginModel *userModel = [[ETTUSERDefaultManager getUserTypeDictionaryPro]valueForKey:@"teacher"];
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userModel.jid,@"userId",
                                 userModel.userName,@"userName",
                                 userModel.userPhoto,@"userPoto",
                                 _openClassroomModel.classIdsStr,@"classIdsStr",
                                 _openClassroomModel.classroomId,@"classroomId",
                                 _openClassroomModel.subjectId,@"subjectId",
                                 _openClassroomModel.gradeId,@"gradeId",
                                 nil];
    NSDictionary *messageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@_IOS",_openClassroomModel.classroomId],@"mid",
                                @"all",@"to",
                                @"xman",@"from",
                                @"1",@"type",
                                time,@"time",
                                userInfoDic,@"message",
                                self.openClassroomModel.classList,@"classList",nil];
    [ETTUSERDefaultManager setTeacherClassroomMessage:messageDic];
    [self teacherPublishMessage:nil messag:messageDic intervalTime:kREDIS_CHANNEL_DEFAULT_INTERVAL];
    return self;
}

///教师推送创建课堂信息
-(void)teacherPublishMessage:(NSString *)channelNameStr messag:(NSDictionary *)messageDic intervalTime:(NSTimeInterval)time
{
    [ETTSideNavigationViewModel teacherPublishMessage:channelNameStr messag:messageDic intervalTime:time respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"教师发送消息成功！");
        }else{
            NSLog(@"教师发送失败！");
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ETTCoursewarePushDataManager *pushDataManager = [[ETTCoursewarePushDataManager alloc]init];

    self.pushDataManager                          = pushDataManager;

    //返回推送页面
    ETTBackToPageManager *manager                 = [ETTBackToPageManager sharedManager];
    manager.delegate                              = self;

    self.backToPageManager                        = manager;

    //文件缓存路径
    NSString *cachePath                           = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];

    NSString *ETTDownloadCache                    = [cachePath stringByAppendingPathComponent:@"ETTDownloadCache"];

    self.ETTDownloadCache                         = ETTDownloadCache;

    self.view.backgroundColor                     = kETTRGBCOLOR(33, 136, 216);
    [self setSNMaskStates:ETTMaskStatesNO];
    
    [[[[[self setupDock:[self getSNIdentity]]setupNotifaction]setupContentView]createNavigatonForIdentity:[self getSNIdentity]].dock.tabBar selectedFirst];
    
    /**
     *  @author LiuChuanan, 17-03-15 17:02:57
     *  
     *  @brief 将代码回退,恢复到修改之前
     *
     *  @since 
     */
    if (self.identity != ETTSideNavigationViewIdentityTeacher) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherPushCoursewareInfo:) name:kREDIS_COMMAND_TYPE_CO_02 object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherSynchronizeVideoAudioInfo:) name:kREDIS_COMMAND_TYPE_CO_03 object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherPushTestPaperInfo:) name:kREDIS_COMMAND_TYPE_CO_04 object:nil];
    }
    
}


#pragma mark ----- 处理课堂当前状态 ------

/**
 学生、老师登录课堂处理当前的课堂状态
 */
-(void)processClassroomState
{
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        NSString *key             = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,_openClassroomModel.classroomId];
        NSDictionary *messageDict = @{@"type":@"FREE"};
        NSString *messageJSON     = [ETTRedisBasisManager getJSONWithDictionary:messageDict];
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
        [redisManager redisSet:key value:messageJSON respondHandler:^(id value, id error) {
            if (!error) {
                NSLog(@"教师课堂状态设置成功！");
            }else{
                NSLog(@"教师课堂状态设置失败!");
            }
        }];
    }else{
        NSString *key = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        [[ETTRedisBasisManager sharedRedisManager]redisGet:key respondHandler:^(id value, id error) {
            if (!error) {
                if (value) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *messDic = [ETTRedisBasisManager getDictionaryWithJSON:value];
                        [self stuedentProcessClassroomState:messDic];
                    });
                }
            }else{
                NSLog(@"学生获得课堂状态失败!");
            }
        }];
    }
}

-(void)stuedentProcessClassroomState:(NSDictionary *)messDic
{
    ETTLog(@"学生获得课堂状态%@",messDic);
    if (messDic) {
        NSString *type = [messDic objectForKey:@"type"];
        NSDictionary *meDic = messDic[@"theUserInfo"];
        if (meDic) {
            NSString *jsonMess = [ETTRedisBasisManager getJSONWithDictionary:meDic];
            if ([type isEqualToString:@"CO_02"]||[type isEqualToString:@"CO_04"]) {
                //推课件或者是推试卷的重连课堂状态恢复
                [self deliverLastCourseDataWithDictionary:messDic];
            } else if ([type isEqualToString:@"WB_01"]) {
                [self studentGetClassMessage:messDic];
            } else {
                [ETTUserInformationProcessingUtils studnetRestoreProcessChannelInformation:jsonMess];
            }
        }
    }
}

//学生重连课堂 推课件或者推试卷的状态恢复
- (void)deliverLastCourseDataWithDictionary:(NSDictionary *)dictionary{
    
    /**
     *  @author LiuChuanan, 17-04-12 18:42:57
     *  
     *  @brief  学生课堂恢复
     *
     *  branch  origin/bugfix/AIXUEPAIOS-1201
     *   
     *  Epic    origin/bugfix/Epic-0411-AIXUEPAIOS-1176
     * 
     *  @since 
     */
    ETTStudentRecoveryClass *studentRecoveryClass = [[ETTStudentRecoveryClass alloc]init];
    
    if (![ETTBackToPageManager sharedManager].isHavenRecovery && dictionary != nil) 
    {
        [studentRecoveryClass getLastCourseDataWithDictionary:dictionary];
    }
}

// 学生进入课堂获取到当前的课堂状态:白板相关操作
-(void)studentGetClassMessage:(NSDictionary *)dict
{
    ETTNavigationController *nv = self.childViewControllers[1];

    AXPWhiteboardViewController *whiteboardVc = (AXPWhiteboardViewController *)nv.topViewController;
    
    [whiteboardVc studentGetClassMessage:dict];
}

/**
 学生接收老师推送课件

 @param notify
 */
- (void)studentGetTeacherPushCoursewareInfo:(NSNotification *)notify {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_pushDataManager dataAnalysisWithDictionary:(NSDictionary *)notify.object];
        
        //老师推送课件,学生接收
        if ([_pushDataManager.CO_02_state isEqualToString:@"CO_02_state1"] ) {
        
            //收起左侧栏
            [self keepLeft];
            
            [ETTCoursewarePresentViewControllerManager sharedManager].isAgainPush = YES;
            if ([_pushDataManager.mid isEqualToString:[self.lastCoursewareDict objectForKey:@"mid"]]) {
            
            //本次推送的与上次推送的mid是否一样
                return;
            } else {
                /*
                 * 此处去掉，解决1171问题。
                 * Johnny 2017.04.05
                 */
                //本次推送的与上次推送的mid不一样的话,判断当前学生是否还在readerVC页面  如果还在的话
//                if ([ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware == YES && [self.lastCoursewareUrl isEqualToString:_pushDataManager.coursewareUrl])
//                {
//                    int index = 0;
//                    for (int i = 0 ;i< self.childViewControllers.count;i++)
//                    {
//                        UIViewController * vctr = self.childViewControllers[i];
//                        if ([vctr isKindOfClass:[ETTStudentCourseViewController class]])
//                        {
//                            index = i;
//                            break;
//                        }
//                    }
//                    if (index != self.index)
//                    {
//                        [self tabbar:nil fromIndex:self.index toIndex:index];
//                    }
//                    [_pushDataManager studentStillInLastReaderViewController];
//                   
//                    
//                } else {//学生点击返回了,不在上次推送的readerVC页面了,判断在哪个页面
//                    
//                    ETTNavigationController *currentVc = self.childViewControllers[self.index];
//                    
//                    UIViewController *rootVC = currentVc.topViewController;
//
//                    if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[ReaderViewController class]]) {
//                    
//                        [_pushDataManager studentIsNotInLastReaderViewController];
//                        
//                    } else
//                        if (ETTCOURSELOADMODE_EJECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:[ReaderViewController new]]) {
//                            if ([rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
//                                ETTStudentVideoAudioViewController *av = (ETTStudentVideoAudioViewController *)rootVC;
//                                [av stopPlay];
//                            }
//                            
//                            [rootVC.navigationController popViewControllerAnimated:NO];
//                        }
//                    
//                    self.lastCoursewareDict = _pushDataManager.pushPDFDict.mutableCopy;
//                    self.lastCoursewareUrl= _pushDataManager.coursewareUrl;
//                    
//                    //文件下载路径 以下是拼接文件名
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //pdf打开之前动画
//                        [self addCoursewarePushAnimationWithTitle:@"正在同步老师课件..."];
//                    });
//                    
//                    [_pushDataManager openPDFWithFileUrl:_pushDataManager.coursewareUrl andSideNavigationViewController:self];
//                }
                ETTNavigationController *currentVc = self.childViewControllers[self.index];
                
                UIViewController *rootVC = currentVc.topViewController;
                
                if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[ReaderViewController class]]) {
                    
                    [_pushDataManager studentIsNotInLastReaderViewController];
                    
                } else
                    if (ETTCOURSELOADMODE_EJECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:[ReaderViewController new]]) {
                        if ([rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                            ETTStudentVideoAudioViewController *av = (ETTStudentVideoAudioViewController *)rootVC;
                            [av stopPlay];
                            });
                        }
                        
                        [rootVC.navigationController popViewControllerAnimated:NO];
                    }
                
                self.lastCoursewareDict = _pushDataManager.pushPDFDict.mutableCopy;
                self.lastCoursewareUrl= _pushDataManager.coursewareUrl;
                
                //文件下载路径 以下是拼接文件名
                dispatch_async(dispatch_get_main_queue(), ^{
                    //pdf打开之前动画
                    [self addCoursewarePushAnimationWithTitle:@"正在同步老师课件..."];
                });
                
                [_pushDataManager openPDFWithFileUrl:_pushDataManager.coursewareUrl andSideNavigationViewController:self];
            }
        }
    });
}



/**
 学生接收到老师同步音视频

 @param notify
 */
- (void)studentGetTeacherSynchronizeVideoAudioInfo:(NSNotification *)notify {
    
    NSDictionary *dict = notify.object;
    NSString *type = [dict objectForKey:@"type"];
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    
    if ([type isEqualToString:@"CO_03"]) {
    
        //收起左侧栏
        [self keepLeft];
    
        NSString *courseIdCoursewareID = [userInfo objectForKey:@"coursewareUrl"];

        NSArray *array                 = [courseIdCoursewareID componentsSeparatedByString:@"*"];
        //音视频播放地址
        NSString *coursewareUrl        = [array firstObject];

        //音视频名称
        NSString *coursewareName       = [array lastObject];
        NSString *coursewareImg        = [userInfo objectForKey:@"coursewareImg"];
        NSString *mid                  = dict[@"mid"];

        ETTStudentVideoAudioViewController *videoAndAudioVC = [[ETTStudentVideoAudioViewController alloc]init];
        
        if ([mid isEqualToString:self.lastMid]) {
            
            return;
            
        } else {
            
            if ([[ETTSynchronizeStatus sharedManager].lastUrlString isEqualToString:coursewareUrl]&&[[ETTCoursewareStackManager new]judgePageSimilarity:videoAndAudioVC])
            {
                //上次和这次推送过来的课件地址一样,什么也不做
                ETTLog(@"与上次推送过来的音视频地址一样,不做操作");
                
                return;
                
            } else {
                //老师传过来的url和视频名称
                videoAndAudioVC.urlString                          = coursewareUrl;
                videoAndAudioVC.navigationTitle                    = coursewareName;
                videoAndAudioVC.coursewareImg                      = coursewareImg;

                [ETTSynchronizeStatus sharedManager].lastUrlString = coursewareUrl;

                self.lastcoursewareName                            = coursewareName;

                self.lastMid                                       = mid;

                ETTNavigationController *currentVc                 = self.childViewControllers[self.index];

                UIViewController *rootVC                           = currentVc.topViewController;
                

                if ([currentVc.topViewController isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
                    ETTStudentVideoAudioViewController *vaVC = (ETTStudentVideoAudioViewController *)currentVc.topViewController;
                    [vaVC.navigationController popViewControllerAnimated:NO];
                    [currentVc pushViewController:videoAndAudioVC animated:YES];
                } else if([currentVc.topViewController isKindOfClass:[ReaderViewController class]]){
                    ReaderViewController *reader = (ReaderViewController *)[ETTBackToPageManager sharedManager].pushingVc;
                    [reader dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    
                    [currentVc pushViewController:videoAndAudioVC animated:YES];
                }
                
                /////////////////////////////////////////////////////////
                /*
                 *  Johnny  2017-03-09
                 */
                else if (ETTCOURSELOADMODE_DIRECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:currentVc withPage:videoAndAudioVC]||ETTCOURSELOADMODE_EJECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:currentVc withPage:videoAndAudioVC])
                {
                    [currentVc popViewControllerAnimated:NO];
                    [currentVc pushViewController:videoAndAudioVC animated:YES];
                }else if (ETTCOURSELOADMODE_REPLACE == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:currentVc withPage:videoAndAudioVC])
                {
                    if ([ETTCoursewarePresentViewControllerManager sharedManager].presentViewController &&[[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[ReaderViewController class]])
                    {
                        
                        
                        ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
                        if (reader)
                        {
                            [reader dismissViewControllerAnimated:NO completion:^{
                                
                                [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
                                [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = NO;
                                [currentVc pushViewController:videoAndAudioVC animated:YES];
                            }];
                            
                        }
                        else
                        {
                            [currentVc pushViewController:videoAndAudioVC animated:YES];
                        }
                        
                        
                        
                    } else if ([rootVC isKindOfClass:[ETTStudentTestPaperDetailViewController class]]||[rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]])
                    {
                        [rootVC.navigationController popViewControllerAnimated:NO];
                        
                        [currentVc pushViewController:videoAndAudioVC animated:YES];
                    }else{
                        [currentVc pushViewController:videoAndAudioVC animated:YES];
                    }

                }
            }
        }
    }
}


/**
 学生接收到老师推试卷信息

 @param notify
 */
- (void)studentGetTeacherPushTestPaperInfo:(NSNotification *)notify {
    
    NSDictionary *dict     = notify.object;
    NSString *type         = [dict objectForKey:@"type"];
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    NSString *CO_04_state  = [userInfo objectForKey:@"CO_04_state"];
    NSString *mid          = [dict objectForKey:@"mid"];
    
    
    if ([type isEqualToString:@"CO_04"]) {
        //老师点击推试卷,学生接收
        
        if ([mid isEqualToString:self.testPaperLastMid]) {
            return;
        } else {
            
            if ([CO_04_state isEqualToString:@"CO_04_state1"]) {
                
                //收起左侧栏
                [self keepLeft];
                
                NSString *courseId      = userInfo[@"courseId"];
                NSString *pushId        = userInfo[@"pushId"];
                NSString *testPaperId   = userInfo[@"testPaperId"];
                NSString *itemIds       = userInfo[@"itemIds"];
                NSString *testPaperName = userInfo[@"testPaperName"];
                NSString *paperRootUrl  = userInfo[@"paperRootUrl"];
                NSString *pushedTestPaperId = userInfo[@"pushedTestPaperId"];
                
                if ([self.pushTestPaperState isEqualToString:CO_04_state] && [[ETTCoursewarePresentViewControllerManager sharedManager].itemIds isEqualToString:itemIds] && [[ETTCoursewarePresentViewControllerManager sharedManager].testPaperId isEqualToString:testPaperId]) {
                    
                    return;
                } else {//第一次进来的时候状态不是8
                    
                    int randow = [self getRandomNumber:1 to:2];
                    
                    ETTLog(@"%d",randow);
                    
                    self.pushTestPaperState                                               = CO_04_state;
                    [ETTCoursewarePresentViewControllerManager sharedManager].itemIds     = itemIds;
                    [ETTCoursewarePresentViewControllerManager sharedManager].testPaperId = testPaperId;
                    self.testPaperLastMid                                                 = mid;
                    
                    //如果当前是pdf阅读控制器,先dismiss然后在push学生试卷详情控制器
                    
                    //试卷详情控制器
                    ETTNavigationController *currentVc = self.childViewControllers[self.index];
                    
                    ETTViewController *rootVC = (ETTViewController *)currentVc.topViewController;
                    
                    /*
                     *  判断当前视图是否是试卷，及处理方法移到下面页面加载中。
                     *  Johnny      2017.03.09
                     */
                    
                    ETTStudentTestPaperDetailViewController *studentTestPaperDetail = [[ETTStudentTestPaperDetailViewController alloc]init];
                    studentTestPaperDetail.testPaperId                              = testPaperId;
                    studentTestPaperDetail.pushId                                   = pushId;
                    studentTestPaperDetail.courseId                                 = courseId;
                    studentTestPaperDetail.itemIds                                  = itemIds;
                    studentTestPaperDetail.testPaperName                            = testPaperName;
                    studentTestPaperDetail.paperRootUrl                             = paperRootUrl;
                    studentTestPaperDetail.pushedTestPaperId                        = pushedTestPaperId;
                    
                    /**
                     *  @author LiuChuanan, 17-03-28 16:51:57
                     *  
                     *  @brief 每次推送试卷或者试题之前,把学生的提交状态置为NO,也就是学生还没有提交.如果老师点击了结束作答或者学生主动点击了提交,提交状态置为YES
                     *
                     *
                     *  @since 
                     */
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"studentCommit"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    BOOL studentCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
                    NSLog(@"%d",studentCommit);

                    if (ETTCOURSELOADMODE_REPLACE == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:studentTestPaperDetail]) {
                        [rootVC resetViewController];
                        [rootVC.navigationController popViewControllerAnimated:NO];
                        
                        [self addCoursewarePushAnimationWithTitle:@"正在加载试卷..."];
                        
                        dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_CONCURRENT);
                        dispatch_async(queue, ^{
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * randow)), dispatch_get_main_queue(), ^{
                                
                                [currentVc pushViewController:studentTestPaperDetail animated:YES];
                                [self removeCoursewarePushAnimation];
                            });
                        });

                    }else if(ETTCOURSELOADMODE_EJECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:studentTestPaperDetail]||ETTCOURSELOADMODE_DIRECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:studentTestPaperDetail]){
                        
                        if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[ReaderViewController class]]) {
                            
                            ReaderViewController *reader = (ReaderViewController *)[ETTBackToPageManager sharedManager].pushingVc;
                            [reader dismissViewControllerAnimated:YES completion:^{
                            }];
                        }
                        
                        if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[ReaderViewController class]]) {
                            
                            ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
                            [reader dismissViewControllerAnimated:NO completion:^{
                                
                                [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
                                [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = NO;
                                
                            }];
                        }
                        if (ETTCOURSELOADMODE_EJECT == [[ETTCoursewareStackManager new]judgingLoadingModeWithCurrentPage:studentTestPaperDetail]) {
                            [rootVC.navigationController popViewControllerAnimated:NO];
                        }
                        
                        [self addCoursewarePushAnimationWithTitle:@"正在加载试卷..."];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * randow)), dispatch_get_main_queue(), ^{
                                
                                [currentVc pushViewController:studentTestPaperDetail animated:YES];
                                [self removeCoursewarePushAnimation];
                            });
                        });
                        
                    }
                }
            }
        }
    }
}

#pragma mark - backPageDelegate
- (void)backToTheNeedPage:(UITapGestureRecognizer *)tap {
    
    [self presentViewControllerToIndex:[ETTBackToPageManager sharedManager].currentIndex title:nil];
}


- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 *  设置针对状态改变的notification
 */
-(instancetype)setupNotifaction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifactionHandler) name:kChangeNavigationStatus object:nil];
    
    return self;
}

-(void)onNotifactionHandler
{
    NSLog(@"onNotifactionHandler");
    [self moveView];
}

-(instancetype)createNavigatonForIdentity:(ETTSideNavigationViewIdentity)identity
{
    NSArray *navigationArr = [NSArray arrayWithArray:[ETTSideNavigationViewModel getArrayForPath:nil withIdentity:identity]];
    for (id obj in navigationArr) {
        [self createController:obj];
    }
    return self;
}

#pragma mark ----- 创建对应Controller ------
-(instancetype)createController:(NSDictionary *)dic
{
    NSString *className;
    NSString *titleName;
    for (id obj in dic) {
        if ([obj isEqualToString:@"class"]) {
            className = [dic objectForKey:obj];
        }
        
        if ([obj isEqualToString:@"title"]) {
            titleName = [dic objectForKey:obj];
        }
    }
    if ([[NSClassFromString(className)alloc]isKindOfClass:[ETTViewController class]]) {
        ETTViewController *vc = [[NSClassFromString(className) alloc]init];
        [self setupChildViewController:vc title:titleName];
        if ([titleName isEqualToString:@"学生管理"]) {
            _studentManagerObj = vc;
        }
        
        if (_MVScenePorter)
        {
          [_MVScenePorter registerGuradCaptainManager:vc type: [self getSNIdentity]] ;
        }
    }else{
        NSLog(@"%@ 应该继承与ETTViewController！",className);
    }
    return self;
}

-(instancetype)setupChildViewController:(ETTViewController *)vc title:(NSString *)title
{
    ETTNavigationController *nav =[[ETTNavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.tintColor   = kETTRGBCOLOR(33, 136, 216);
    nav.navigationBar.alpha       = 1;
    nav.navigationBar.translucent = NO;
    [nav.navigationBar setBarTintColor:kETTRGBCOLOR(65, 164, 237)];


    [vc putInOpenClassroomDoBackModel:self.openClassroomModel];
    vc.navigationItem.title       = title;
    vc.view.alpha                 = 1;
    [self addChildViewController:nav];

    UIButton *btn                 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(100, 100, 100, 40)];
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickHandler) forControlEvents:UIControlEventTouchUpInside];
    //[vc.view addSubview:btn];
    
    return self;
}

-(void)onClickHandler
{
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}


-(instancetype)setupContentView
{
    ETTView *contentView         = [[ETTView alloc]init];
    contentView.width            = kSCREEN_WIDTH;
    contentView.height           = self.view.height - kStatusBarHeight;
    contentView.x                = 0;
    contentView.y                = kStatusBarHeight;

    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    return self;
}


-(instancetype)setupDock:(ETTSideNavigationViewIdentity)identity
{
    
    ETTDockView *dock;
    if (ETTSideNavigationViewIdentityTeacher == identity) {
        dock = [[ETTDockView alloc]initWithIdentity:identity];
    }else if (ETTSideNavigationViewIdentityStudent == identity){
        dock = [[ETTDockView alloc]initWithModel:_studentSelectTeacherModel ForIdentity:identity];
    }else if (ETTSideNavigationViewIdentityObserveStudents == identity){
        dock = [[ETTDockView alloc]initWithModel:_studentSelectTeacherModel ForIdentity:identity];
    }
    
    [self.view addSubview:dock];
    self.dock = dock;
    
    BOOL isLandscape           = (self.view.width > self.view.height);
    [dock rotateToLandscape:isLandscape];

    self.dock.tabBar.MDelegate = self;
    self.dock.bottomMenu.MDelegate = self;
    
    [self.dock.iconButton addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

#pragma mark - 头像点击
-(void)iconBtnClick
{
    // 弹出关于我们页面
    [self setMask];
    // 弹出我们页控制器
    [self aboutAXP];
    
}

#pragma mark - 弹出关于我们页面的相关操作
- (void)setMask
{
    //添加笼罩视图  这是懒加载
        _maskView = [[UIControl alloc]initWithFrame:self.view.bounds];
        //设置背景颜色
        [_maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];
        [_maskView addTarget:self action:@selector(maskAction:) forControlEvents:UIControlEventTouchUpInside];
        ETTMaskingView *mv = (ETTMaskingView *)[self.view viewWithTag:10086];
        if (mv) {
            [self.view insertSubview:_maskView aboveSubview:mv];
        }else{
            [self.view addSubview:_maskView];
        }
}

- (void)aboutAXP
{
    if (!_aboutView) {
        _aboutView = [[ETTAboutView alloc]initWithFrame:CGRectMake(0, 0, 500, 600)];
        _aboutView.center = self.view.center;
        _aboutView.layer.cornerRadius = 15;
        [self.view addSubview:_aboutView];
    }
}

- (void)maskAction:(UIControl *)mask
{

    if (_aboutView) {
        [_aboutView removeFromSuperview];
        _aboutView = nil;
    }
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    BOOL isLandscape = (size.width > size.height);
    
    CGFloat duration = [coordinator transitionDuration];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.dock rotateToLandscape:isLandscape];
        
        self.contentView.x = self.dock.width;
    }];
}

#pragma mark - ETTSideNavigationManagerDelegate
-(BOOL)changeNavigationState
{
    return [self moveView];
}

-(ETTSideNavigationViewIdentity)getETTSideNavigationViewIdentity
{
    return [self getSNIdentity];
}

#pragma mark - move view
-(BOOL)moveView
{
    switch ([self getSNStates]) {
        case ETTSideNavigationViewStatesIndentation:
            [self setSNStates:ETTSideNavigationViewStatesMoving];
            if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(naviagtionViewMoving)]) {
                [self.MDelegate navigationViewDidIndentation];
            }
            [self viewMoving:1];
            break;
        case ETTSideNavigationViewStatesStickOut:
            [self setSNStates:ETTSideNavigationViewStatesMoving];
            if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(naviagtionViewMoving)]) {
                [self.MDelegate navigationViewDidIndentation];
            }
            [self viewMoving:-1];
            break;
        case ETTSideNavigationViewStatesMoving:
            NSLog(@"The view is Moving!!");
            return NO;
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - 保持导航收起状态
-(void)keepLeft
{
    NSArray *viewArr = self.view.subviews;
    UIView *firvView = [viewArr firstObject];
    CGRect rect      = firvView.frame;
    
    if (rect.origin.x == -kDockLandscapeWidth) {
        ///导航条在左侧,不需要做任何操作.
    }else if (rect.origin.x == 0){
        ///导航条在右侧,需要收起导航条.
        [self viewMoving:-1];
    }
}

-(void)viewMoving:(NSInteger)type
{
    for (ETTView *viewObj in self.view.subviews) {
        
        if ([viewObj isKindOfClass:[ETTView class]] || [viewObj isKindOfClass:[ETTDockView class]] || [viewObj isKindOfClass:[ETTMaskingView class]]) {
            
            [ETTView animateWithDuration:kMoveTime animations:^{
                viewObj.frame = CGRectMake(viewObj.frame.origin.x + type *kDockLandscapeWidth, viewObj.frame.origin.y, viewObj.frame.size.width, viewObj.frame.size.height);
            } completion:^(BOOL finished) {
                if (type >0) {
                
                //添加蒙版
                    [self setSNStates:ETTSideNavigationViewStatesStickOut];
                    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(navigationViewDidStatesStickOut)]) {
                        [self.MDelegate navigationViewDidStatesStickOut];
                    }
                }else{
                
                //移除蒙版
                    [self setSNStates:ETTSideNavigationViewStatesIndentation];
                    if ([viewObj isKindOfClass:[ETTMaskingView class]]) {
                        ETTMaskingView *mv = (ETTMaskingView *)viewObj;
                        [mv removeMaskView];
                    }

                    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(navigationViewDidIndentation)]) {
                        [self.MDelegate navigationViewDidIndentation];
                    }
                }
            }];
        }
    }
}

#pragma mark - 操作ETTMaskStates
-(void)setSNMaskStates:(ETTMaskStates)maskStates
{
    self.maskStates = maskStates;
}

-(ETTMaskStates)getSNMaskStates
{
    return self.maskStates;
}

#pragma mark - 操作ETTSideNavigationViewIdentity
- (void)setSNIdentity:(ETTSideNavigationViewIdentity)identity
{
    self.identity = identity;
}

- (ETTSideNavigationViewIdentity)getSNIdentity
{
    return self.identity;
}

#pragma mark - 操作states
- (void)setSNStates:(ETTSideNavigationViewStates)states
{
    if (states == ETTSideNavigationViewStatesStickOut && [self getSNMaskStates] == ETTMaskStatesNO) {
        [self setSNMaskStates:ETTMaskStatesYES];
        [self createMaskingView];
    }else if(states == ETTSideNavigationViewStatesIndentation)
    {
        [self setSNMaskStates:ETTMaskStatesNO];
    }
    self.states = states;
}

- (ETTSideNavigationViewStates)getSNStates
{
    return self.states;
}

- (void)createMaskingView
{
    ETTMaskingView *mV = [[ETTMaskingView alloc]initWithFrame:CGRectMake(kDockLandscapeWidth, 0, kSCREEN_WIDTH - kDockLandscapeWidth, kSCREEN_HEIGHT)];
    mV.navigationManager = self;
    mV.tag = 10086;
    [self.view addSubview:mV];
    self.mV = mV;
}

#pragma mark - ETTTabBarDelegate
- (void)tabbar:(ETTTabBar *)tabbar fromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    if ([self getSNIdentity] != ETTSideNavigationViewIdentityTeacher)
    {
        ETTViewController *oldVc = self.childViewControllers[from];
        [oldVc.view removeFromSuperview];

        ETTViewController *newVc = self.childViewControllers[to];
        newVc.view.frame         = self.contentView.bounds;
        [self.contentView addSubview:newVc.view];
        
        self.index = to;
        return;
        
    }
    ETTNavigationController *oldVc = self.childViewControllers[from];
   
    
    ETTNavigationController *newVc = self.childViewControllers[to];
   
    
    self.index = to;
    
    if ([_MVScenePorter canOpenDoor:(ETTViewController  *)newVc.topViewController withNum:to])
    {
        [oldVc.view removeFromSuperview];
        newVc.view.frame = self.contentView.bounds;
        [_MVScenePorter recordWhereabouts:from to:to];
        [self.contentView addSubview:newVc.view];
      
    }
        
    
}
#pragma mark
#pragma mark  ---------快速返回回调----------
-(void)pChangeViewFromDoorplate:(NSInteger)toDoorplate
{
    [self.dock.tabBar itemClickHandler:self.dock.tabBar.subviews[toDoorplate]];
}

- (void)presentViewControllerToIndex:(NSInteger)toIndex title:(NSString *)title {
    
    [self getSNIdentity];

    [self.dock.tabBar itemClickHandler:self.dock.tabBar.subviews[toIndex]];
}

#pragma mark - ETTBottomMenuDelegate
-(void)bottomMenu:(ETTBottomMenu *)bottomMenu type:(ETTBottomMenuItemType)type
{
    switch (type) {
        case ETTBottomMenuItemTypeUpload:
            NSLog(@"上传数据!!");
            break;
            
        case ETTBottomMenuItemTypeSignOut:
            //退出
            [self exitSideNavigaitonController];
            break;
            
        case ETTBottomMenuItemTypeSetup:
            NSLog(@"设置!!!!");
            break;
            
        default:
            break;
    }
}

-(void)exitSideNavigaitonController
{
    /*
     new      : Modify
     time     : 2017.3.14  10:56
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-1004rollback_Epic0313_1061
     describe : 对AIXUEPAIOS-1004_Epic0313_1061 分支代码的恢复
     */
    /////////////////////////////////////////////////////
    [ETTScenePorter attempDealloc];
    [ETTUSERDefaultManager close];
    [self processExitClassroom];
    
    /**
     *  @author LiuChuanan, 17-04-10 17:42:57
     *  
     *  @brief 学生课堂恢复,课件的部分功能恢复,如果退出了,更改是否重连状态.
     *
     *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
     *   
     *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
     * 
     *  @since 
     */
     [ETTBackToPageManager sharedManager].isHavenRecovery = NO;
    
    /**
     *  @author 徐梅娜, 17-04-18 17:42:57
     *
     *  @brief 清空白板设置.
     *
     *  branch origin/bugfix/AIXUEPAIOS-1245
     *
     *  Epic   origin/bugfix/Epic-0331-AIXUEPAIOS-1157
     *
     *  @since
     */
    [self resetWhiteboard];

}

-(void)resetWhiteboard
{
    
    AXPWhiteboardToolbarManager *manager = [AXPWhiteboardToolbarManager sharedManager];
    if (!manager.axpWhiteboardView) {
        [manager.axpWhiteboardView removeFromSuperview];
        manager.axpWhiteboardView = nil;
    }
    if (!manager.whiteboardToolbar) {
        [manager.whiteboardToolbar removeFromSuperview];
        manager.whiteboardToolbar = nil;
    }
    if (manager.whiteboards.count>0) {
        [manager.whiteboards removeAllObjects];
    }
}

-(void)returnLoginVC
{
    UIApplication *app = [UIApplication sharedApplication];
    ETTLoginViewController *loginVC = [[ETTLoginViewController alloc]initWithType:ETTLoginAfterUsing];
    [app.keyWindow setRootViewController:loginVC];
    CGRect rect = [UIScreen mainScreen].bounds;
    [loginVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
    [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
        loginVC.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)processExitClassroom
{
    /***************************************************
     暂时为了确保点击退出能返回登录。
     此处暂时无论任何情况都能返回登录界面。
     Johnny
     2017.03.22
     ***************************************************/

    WS(weakSelf);
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        [weakSelf teacherProcessRedisSetForCloseClassroom];
        [ETTUserInformationProcessingUtils closeClassroomWithJid:_openClassroomModel.jid withClassroomId:_openClassroomModel.classroomId callBackHandler:^(id value, NSError *error) {
            if (error) {
                NSLog(@"关闭课堂失败！");
            }else{
                if ([value isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *reDic = (NSDictionary *)value;
                    NSNumber *result = (NSNumber *)reDic[@"result"];
                    if ([result isEqualToNumber:[NSNumber numberWithInteger:1]]) {
                        [ETTUSERDefaultManager setStartPageState:nil];
                        NSLog(@"关闭成功!");
                    }else{
                        NSLog(@"关闭课堂失败!");
                    }
                }
            }
        }];
    }else{
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
        [self quitRedisManager:redisManager];
    }
}

-(void)showAlerMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)teacherProcessRedisSetForCloseClassroom
{
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *key;
    key = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,_openClassroomModel.classroomId];
    NSDictionary *dict = @{@"type":@"CLOSE"};
    NSString *messJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf quitRedisManager:redisManager];
    });
    
    [redisManager redisSet:key value:messJSON respondHandler:^(id value, id error) {
        [self teacherProcessExitClassroom:redisManager];
        if (!error) {
//            [self teacherProcessExitClassroom:redisManager];
        }else{
            NSLog(@"教师关闭课堂失败!");
        }
    }];
    
    [ETTUserInformationProcessingUtils setClassroomState:@"CLOSE" classroomId:[NSString stringWithFormat:@"%@",_openClassroomModel.classroomId] identity:[ETTUSERDefaultManager getCurrentIdentity] withMessage:nil];
}

-(void)teacherProcessExitClassroom:(ETTRedisBasisManager *)redisManager
{
    NSString *classroomChannel = [NSString stringWithFormat:@"%@%@",_openClassroomModel.classroomId,kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                              @"time":[ETTRedisBasisManager getTime],
                              @"from":@"XMAN",
                              @"to":@"ALL",
                              @"type":@"CLOSE"};
    NSString *messJSON = [ETTRedisBasisManager getJSONWithDictionary:messDic];
    WS(weakSelf);
    [redisManager publishMessageToChannel:classroomChannel message:messJSON respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"通知学生课堂已关闭成功！");
            [weakSelf quitRedisManager:redisManager];
        }else{
            NSLog(@"通知学生课堂已关闭失败！");
            [weakSelf quitRedisManager:redisManager];
        }
    }];
}

-(void)quitRedisManager:(ETTRedisBasisManager *)redisManager
{
    [redisManager endWorker];
    [self returnLoginVC];
}


/**
    添加学生端接收到老师推送课件动画
 */
- (void)addCoursewarePushAnimationWithTitle:(NSString *)title {
    self.coursewarePushAnimationView = [[ETTCoursewarePushAnimationView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 20) andTitle:title andAnimationTime:1];
    
    /**
     *  @author LiuChuanan, 17-04-06 16:42:57
     *  
     *  @brief 推送动画正在加载的过程中,取消用户交互(自己要多测几遍)
     *
     *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
     *   
     *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
     * 
     *  @since 
     */
    self.coursewarePushAnimationView.userInteractionEnabled = NO;
    self.coursewarePushAnimationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.coursewarePushAnimationView];
    
    [self.view bringSubviewToFront:self.coursewarePushAnimationView];
} 


/**
    移除学生端接收到老师推送课件动画
 */
- (void)removeCoursewarePushAnimation {
    [self.coursewarePushAnimationView removeFromSuperview];
}

/**
 打开pdf之前动画
 */
- (void)openPDFCoursewareWhitCoverView {
    
    /**
     *  @author LiuChuanan, 17-03-21 15:22:57
     *  
     *  @brief 更改打开课件前的提示语
     *
     *
     *  @since 
     */
    self.coverView = [[ETTCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) labelTitle:@"正在打开,请稍候"];
    self.coverView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:self.coverView];
    
}


/**
 移除pdf之前动画
 */
- (void)removePdfCoverView {
    
    [self.coverView removeFromSuperview];
}

/**
 *  @author LiuChuanan, 17-03-10 14:25:57
 *  
 *  @brief 如果sideNav已经实例化了一次,返回true
 *
 *  @since 
 */
- (BOOL)haveInitView
{
    return YES;
}

/**
 学生收到推课件/试卷动画
 */
- (void)addSynchronizeCoverView {
    
    ETTSideNavigationViewController *side = [ETTJudgeIdentity getSideNavigationViewController];
    
    self.synchronizeCoverView = [[ETTCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) synchronizeViewTitle:@"正在推送"];
    self.synchronizeCoverView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [side.view addSubview:self.synchronizeCoverView];
   
}

//生成from 到 to的随机数 包括from不包括to
-(int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

/**
 移除学生收课件/试卷动画
 */
- (void)removeSynchronizeCoverView {
    [self.synchronizeCoverView removeFromSuperview];
}


#pragma mark ----- 查看功能 ------
- (UIImage *)capture
{
    /**
     *  @author LiuChuanan, 17-04-11 11:42:57
     *  
     *  @brief 查看功能bug修复
     *
     *  branch origin/bugfix/AIXUEPAIOS-1196
     *   
     *  Epic   origin/bugfix/Epic-0407-AIXUEPAIOS-1175
     * 
     *  @since 
     */
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, appDelegate.window.opaque, 0.0);
    [appDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    /**
     *  @author LiuChuanan, 17-05-13 21:42:57
     *  
     *  @brief  mini1 拍照和取照片质量压缩比例调为 ,非mini1按照0.78压缩
     *
     *  branch  origin/bugfix/AIXUEPAIOS-1319
     *   
     *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
     * 
     *  @since 
     */
    NSData *imageData;
    NSString *deviceType = [NSString getDeviceType];
    if ([deviceType isEqualToString:iPadMini1]) 
    {
        imageData = UIImageJPEGRepresentation(img, 0.4);
        NSLog(@"查看命令 mini1学生截屏传给老师压缩后图片大小:%.2fKB",imageData.length / 1024.0);
    } else
    {
        imageData = UIImageJPEGRepresentation(img, 0.78);
        NSLog(@"查看命令 不是mini1学生截屏传给老师压缩后图片大小:%.2fKB",imageData.length / 1024.0);
    }
    UIImage *theImage = [UIImage imageWithData:imageData];

    UIGraphicsEndImageContext();

    return theImage;
}


#pragma mark - 学生处理教师查看当前状态

///通过HPH缓存图片
-(void)onMA04Handler:(NSNotification *)notification
{
    UIImage *studentImage = [ETTUserInformationProcessingUtils scaleFromImage:[self capture] toSize:CGSizeMake(kIMAGE_WIDTH_VIEW_STUDENT, kIMAGE_HEIGHT_VIEW_STUDENT)];
    NSData *imageData     = UIImageJPEGRepresentation(studentImage,0.7);
    NSString *urlStr      = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
    [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:nil fileData:imageData mimeType:@"image/jpg" uploadImageRule:kCacheImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        if (!error&&responseDictionary) {
            NSLog(@"图片缓存成功!");
            NSString *cacheAddressUrl = [NSString stringWithFormat:@"%@",(NSArray *)responseDictionary[@"attachUrl"][0]];
            NSString *classroomChannel = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
            NSDictionary *messUserInfo = @{@"CacheAddressUrl":cacheAddressUrl};
            NSDictionary *messageDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                                         @"time":[ETTRedisBasisManager getTime],
                                         @"from":[AXPUserInformation sharedInformation].jid,
                                         @"to":@"XMAN",
                                         @"type":@"SMA_04",
                                         @"userInfo":messUserInfo};
            NSString *messJSON = [ETTRedisBasisManager getJSONWithDictionary:messageDic];
            NSLog(@"查看功能--开始通知老师!");
            [[ETTRedisBasisManager sharedRedisManager]publishMessageToChannel:classroomChannel message:messJSON respondHandler:^(id value, id error) {
                if (!error) {
                    NSLog(@"学生查看信息发送成功!");
                }else{
                    NSLog(@"学生查看息发送失败!");
                }
            }];
        }else{
            NSLog(@"%s  %d",__FILE__,__LINE__);
        }
    }];
}

//试卷动画
- (void)addPsuhCoverView {
    
    UIWindow *window   = [UIApplication sharedApplication].keyWindow;

    self.pushCoverView = [[ETTPushCoverView alloc]initWithLabelTitle:@"正在推送"];
    self.pushCoverView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [window addSubview:self.pushCoverView];
    
    [self.pushCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).offset(0);
        make.top.equalTo(window).offset(0);
        make.right.equalTo(window).offset(0);
        make.bottom.equalTo(window).offset(0);
    }];
    
}

//移除试卷动画
- (void)removePushCoverView {
    [self.pushCoverView removeFromSuperview];
}

-(BOOL)shouldAutorotate{
    
    return NO;
    
}

-(void)appExit
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"课堂已关闭或该账号已在其他设备登录。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [weakSelf exitSideNavigaitonController];
                                                              });
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}



-(void)classClosedHandler
{
    /***************************************************
     此处两个业务逻辑不同，不应放在一起。
     Johnny
     2017.03.22
     ***************************************************/
//    [self appExit];
    if ([[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        [self appExit];
    }else{
        [self showAlerMessage:@"课堂已关闭!"];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCLASS_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kEXIT object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kChangeNavigationStatus object:nil];
    [ETTUSERDefaultManager setTeacherClassroomMessage:nil];
    
    /**
     *  @author LiuChuanan, 17-03-15 17:31:57
     *  
     *  @brief 代码回滚,恢复到修改之前
     *
     *  @since 
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CO_02 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CO_03 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CO_04 object:nil];
}



#pragma mark
#pragma mark ----- 职能任务专区 ------
/*
 add 2017.5.4  14:35  KXG-AIXUEPAIOS-1141
 */
-(void)connectTaskComplete
{
    ETTGovernmentWorkTask * task = [[ETTGovernmentWorkTask alloc]initTask:ETTSITUATIONINCLASSROOM];
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONINCLASSROOM withEntity:self];
}

-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (commond == nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;  //试卷

    }
    switch (commond.EDCommandType)
    {
        case ETTCOMMANDTYPEWHITEBOARD:
        {
            [self.dock.tabBar itemClickHandler:self.dock.tabBar.subviews[2]];
            
           // [self tabbar:nil fromIndex:0 toIndex:2];
        }
            break;
        case ETTCOMMANDTYPEPAPER :
        {
            
        }
        case ETTCOMMANDTYPECOURSEWARE:
        {
             [self.dock.tabBar itemClickHandler:self.dock.tabBar.subviews[1]];
//            [self tabbar:nil fromIndex:0 toIndex:1];
        }
            break;
            
        default:
            break;
    }

    ETTNavigationController *nav = self.childViewControllers[self.index];
    ETTViewController * vc = nav.childViewControllers.firstObject;
    
    [vc performTask:commond];

}

@end
