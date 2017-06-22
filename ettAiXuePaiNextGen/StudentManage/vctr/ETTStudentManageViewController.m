//
//  ETTStudentManageViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentManageViewController.h"
#import "ETTSideNavigationViewController.h"
#import "ETTOpenClassroomDoBackModel.h"
#import "AppDelegate.h"
#import "ETTTestViewController.h"

#import "ETTStudentManageViewModel.h"
#import "ETTClassListView.h"
#import "GlobelDefine.h"
#import "ETTTeacherCommandView.h"
#import "ETTClassUserListView.h"
#import "ETTShowOnlineUserView.h"
#import "ETTShowUserCurrentOperationView.h"
#import "ETTShowTeacherResponderVCTR.h"
#import "ETTShowTeacherRollCallView.h"
#import "ETTTeacherClassPerformanceVCTR.h"

#import "ETTPushedTestPaperDataManager.h"
#import "ETTPushedTestPaperModel.h"
#import "ETTTestPushedTestPaperViewController.h"

#import "ETTClassPerformanceModel.h"

#import "ETTStudentClassPerformanceVCTR.h"
#import "ETTBackToPageManager.h"
#import "ETTUSERDefaultManager.h"
#import "ETTCoursewarePushAnimationView.h"
#import "ETTScenePorter.h"
#import "EttRunLoopTimerOperation.h"
#import "ETTCharacterAnimationManager.h"
#import "ETTJSonStringDictionaryTransformation.h"
@interface ETTStudentManageViewController ()<ETTOperationDelegate>
{
    ETTStudentManageViewModel * _mModel;
    NSOperationQueue         * _mOperationQueue;
    ETTStuPerformanceRunLoop * _mTimerOperation;
}
@property (nonatomic,retain) ETTStudentManageViewModel      * MVModel;
@property (nonatomic,retain) ETTClassListView               * MVLeftView;
@property (nonatomic,retain) ETTClassUserListView           * MVRightUserView;
@property (nonatomic,retain) UIButton                       * MVPerformanceBtn;
@property (nonatomic,retain) UIButton                       * MVIsPushingBtn;
@property (nonatomic,retain) ETTCoursewarePushAnimationView * MVAnimationView;

@property (nonatomic,retain)NSOperationQueue           *  MDOperationQueue;
@end

@implementation ETTStudentManageViewController
@synthesize MVModel = _mModel;
@synthesize MDOperationQueue  = _mOperationQueue;
-(id)init
{
    if (self = [super init])
    {
        [self initData];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initStudentsintegralBroadcastOperationQueue];
    
}
-(NSOperationQueue *)MDOperationQueue
{
    if (_mOperationQueue == nil)
    {
        _mOperationQueue      = [[NSOperationQueue alloc]init];
        _mOperationQueue.name = @"stumanagerStateRequestQueue";
        _mOperationQueue.maxConcurrentOperationCount = 1;
    }
    
    return _mOperationQueue;
}


-(void)initStudentsintegralBroadcastOperationQueue
{
    [self stopStudentsintegralPush];
    if (_mTimerOperation == nil)
    {
   
        _mTimerOperation = [[ETTStuPerformanceRunLoop alloc]initWithInterval:kREDIS_HEARTBEAT_TIME withDelegate:self];
        
        _mTimerOperation.name = @"stumanagerStateRequestOperation";
        [self.MDOperationQueue addOperation:_mTimerOperation];
    }
    
}
-(void)puspendeQueue:(BOOL)puspende
{
    if (_mOperationQueue)
    {
        [_mOperationQueue setSuspended:puspende];
    }
}
-(void)stopStudentsintegralPush
{
    if (_mTimerOperation)
    {
        [_mTimerOperation stop];
        [_mOperationQueue cancelAllOperations];
        _mTimerOperation = nil;
        _mOperationQueue = nil;
    }
    
}


/**
 *  Description 轮询回调
 */
-(void)pRunLoopEntry:(NSOperation *)operation
{
    if (_mModel.EDGetStudentsIntegral)
    {
         [self  pushClassIntegral];
    }
   
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopStudentsintegralPush];
    //[self puspendeQueue:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRewardScore:) name:ChangeRewardScoreKey object:nil];
    [self createSubView];
    [self updateClassStudentsintegral];
    [self settingNetworkConnect];
    
    //查询所有数据
    NSMutableArray *array = [[ETTPushedTestPaperDataManager sharedManager]selectAllData];
    
    if (array.count > 0) 
    {
        
        ETTPushedTestPaperModel *model = [array lastObject];

        NSString *itemId               = model.itemId;
        NSString *testPaperId          = model.testPaperId;
        NSString *testPaperUrlString   = model.testPaperUrlString;
        
        //如果缓存数据存在,itemId存在,说明上次断开之前推送的是单道题
        if (![itemId isEqualToString: @""]&& itemId && testPaperId) 
        {
            ETTLog(@"上次推送的是单道题");
        } else
        {
            ETTLog(@"上次推送的是试卷");  
            ETTTestPushedTestPaperViewController *testVC = [[ETTTestPushedTestPaperViewController alloc]init];
            testVC.urlString = testPaperUrlString;
        }
    }

    
}

// 当收到奖励的通知的时候出发奖励+1的操作
- (void)changeRewardScore:(NSNotification *)notification
{
    NSString *jid = [notification.userInfo objectForKey:@"jid"];
    
    if ([jid containsString:@","]) {
        NSArray *jidArr = [jid componentsSeparatedByString:@","];
        for (int i=0; i<jidArr.count; i++) {
            NSString *jidStr = jidArr[i];
            [_mModel.EDClassModel changeRewardScoreUserModel:jidStr.integerValue];
        }
    }else{
        [_mModel.EDClassModel changeRewardScoreUserModel:jid.integerValue];
    }
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.3.23  17:30
     modifier : 康晓光
     version  ：AIXUEPAIOS-924
     branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
     describe : 师端奖励后学生端没有出现奖励数值的变化
     operation: 推送一下数据
     */
     [self  pushClassIntegral];
    ////////////////////////////////////////////////////////
}

-(void)settingNetworkConnect
{
    WS(weakSelf);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown)
        {
            
            [weakSelf.MDOperationQueue setSuspended:YES];
        }
        else
        {
            [weakSelf.MDOperationQueue setSuspended:false];
        }
        
        
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

-(void)updateClassStudentsintegral
{
    
    NSString * key = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_INTEGRAL,_mModel.EDClassModel.classroomId];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [redisManager redisGet:key respondHandler:^(id value, id error) {
            if (!error)
            {
                NSLog(@"学生刷新课堂表现，成功拉取数据  %@",value);
                NSDictionary * dic = [ETTRedisBasisManager getDictionaryWithJSON:value];
                [weakSelf reciveClassPeformacneMsg:dic];
            } else {
                NSLog(@"学生刷新课堂表现，拉取数据失败!");
                NSError * err = error;
                if (err.code == ETTREDISERRORTYPEREDISNULL )
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                         [weakSelf updateClassStudentsintegral];
                    });
                                   
                   
                }
                
                else
                {
                    ////////////////////////////////////////////////////////
                    /*
                     new      : Modify
                     time     : 2017.3.23  13:20
                     modifier : 康晓光
                     version  ：AIXUEPAIOS-924
                     branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
                     describe : 师端奖励后学生端没有出现奖励数值的变化
                     operation: 如果key值不存在，把开关打开
                     */
                    if (err.code == ETTREDISERRORTYPEGETWITHNOKEY)
                    {
                        _mModel.EDGetStudentsIntegral = YES;

                    }
                    [weakSelf initStudentsintegralBroadcastOperationQueue];
                    ////////////////////////////////////////////////////////
                }
            }
        }];
    });

    
    
    
}
-(void)reciveClassPeformacneMsg:(NSDictionary *)dic
{
    
    [_mModel processingDataClassMap:[dic valueForKey:@"userInfo"]];
   


}

-(void)putInOpenClassroomDoBackModel:(ETTOpenClassroomDoBackModel *)model
{
    if (model)
    {
        _mModel.EDClassModel = model;
        
    }

}


#pragma mark ----  刷新学生管理学生信息  -----

-(void)refreshClassOnlinePersonnelInformation:(NSDictionary *)dic
{

   double  timeInterva=1.f;
   if (!_mModel.EDLastRefreTime) {
        _mModel.EDLastRefreTime = [[NSDate date]timeIntervalSince1970];
    }
   else
   {
       timeInterva=[[NSDate date]timeIntervalSince1970] - _mModel.EDLastRefreTime;
   }


    if (dic && dic.count && timeInterva>1.0)
    {
        
        [_mModel refreshClassOnlineData:dic block:^(ETTProcessingDataState state) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self refreshView];
            });

        }];
    }
}

-(void)refreshView
{
    ETTClassificationModel  * model = [_MVLeftView getCurrentViewModel];
    switch (model.classType)
    {
        case ETTCLASSTYPEONLINE:
        {
            [_MVRightUserView reloadView:_mModel.EDOnlineUserArr lockScreen:_mModel.EDLockView];
        }
            break;
        case ETTCLASSTYPEATTEND:
        {
            [_MVRightUserView reloadView:_mModel.EDAttendUserArr lockScreen:_mModel.EDLockView];
        }
            break;
        case ETTCLASSESTABLISH:
        {
            ETTClasssModel * classModel =  [_mModel getClassModel:model.classId];
            [_mModel refreshClassStudentWithClassModel:classModel];
            [_MVRightUserView reloadView:@[classModel] lockScreen:_mModel.EDLockView];
            
        }
            break;
        default:
            break;
    }
    [_MVLeftView reloadView];
    

}
#pragma mark ----刷新旁听人数-----

-(void)refreshClassEattendPersonnelInformation:(NSArray * )arr
{
   
}


-(void)initData
{
    if (_mModel == nil)
    {
        _mModel = [[ETTStudentManageViewModel alloc]init];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unLockScreen) name: RemindLockScreenAssociatedKey object:nil];
  
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)unLockScreen
{
    if(_mModel.EDLockView)
    {
        _mModel.EDLockView = false;
        [_MVLeftView serLockScreenSelected:false];
        _MVRightUserView.EVIsLockView = _mModel.EDLockView;
    }
 

}
-(void)createSubView
{
    self.view.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
    [self setupNavBar];
    [self crateLeftView];
    [self createIspushingView];
}

-(void)createIspushingView
{
    [self.view addSubview:self.MVIsPushingBtn];
    if ([ETTBackToPageManager sharedManager].isPushing)
    {
        [self showIspushView];
    }
    else
    {
        [self hidenIspushView];
    }
}

-(UIButton *)MVIsPushingBtn
{
    if (_MVIsPushingBtn == nil)
    {
        _MVIsPushingBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVIsPushingBtn setTitle:@"返回推送界面" forState:UIControlStateNormal];
        [_MVIsPushingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _MVIsPushingBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _MVIsPushingBtn.backgroundColor = [[UIColor colorWithHexString:@"#f2b922"]colorWithAlphaComponent:204.0/255];
        _MVIsPushingBtn.frame           = CGRectMake(0, self.view.height+24, self.view.width, 24);
        [_MVIsPushingBtn addTarget:self action:@selector(gobackToPushingView) forControlEvents:UIControlEventTouchUpInside];

    }
    return _MVIsPushingBtn;
}

-(void)showIspushView
{
    [UIView animateWithDuration:0.5 animations:^{
        _MVIsPushingBtn.frame =CGRectMake(0, self.view.height-24, self.view.width, 24);
    }];
}

-(void)hidenIspushView
{
    [UIView animateWithDuration:0.5 animations:^{
        _MVIsPushingBtn.frame =CGRectMake(0, self.view.height+24, self.view.width, 24);
    }];
}

-(void)gobackToPushingView
{
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_MVRightUserView)
    {
        _MVRightUserView.frame = CGRectMake(233+10, 10, self.view.width-233-10, self.view.height -10);
    }
}
-(void)createRightOnlieUserView
{
    if (_MVRightUserView)
    {
        [_MVRightUserView removeFromSuperview];
        _MVRightUserView = nil;
    }
    
    if (_MVRightUserView == nil)
    {
        _MVRightUserView = [[ETTOnlineClassUserListView alloc]initWithFrame:CGRectMake(233+10, 10, self.view.width-233-10, self.view.height -10)];
        [_MVRightUserView reloadView:_mModel.EDOnlineUserArr lockScreen:_mModel.EDLockView];
        _MVRightUserView.EVDelegate = self;
        [self.view addSubview:_MVRightUserView];
       
        NSLog(@"视图的原点 %lf,视图的高度%lf", self.view.y, self.view.height);
        
    }
    
//    _MVRightUserView.backgroundColor = [UIColor redColor];
}

-(void)createRightAttendUserView
{
    if (_MVRightUserView)
    {
        [_MVRightUserView removeFromSuperview];
        _MVRightUserView = nil;
    }
    
    if (_MVRightUserView == nil)
    {
        _MVRightUserView = [[ETTEattendClassUserListView alloc]initWithFrame:CGRectMake(233+10, 10, self.view.width-233-10, self.view.height- 10)];
        [_MVRightUserView reloadView:_mModel.EDAttendUserArr lockScreen:_mModel.EDLockView];
        _MVRightUserView.EVDelegate = self;
        [self.view addSubview:_MVRightUserView];
        
    }
}

-(void)createRightEstablsihView:(NSString *)classId
{
    if (_MVRightUserView)
    {
        [_MVRightUserView removeFromSuperview];
        _MVRightUserView = nil;
    }
    
    if (_MVRightUserView == nil)
    {
        _MVRightUserView            = [[ETTEstablishClassUserListView  alloc]initWithFrame:CGRectMake(233+10, 10, self.view.width-233-10, self.view.height - 10)];
        _MVRightUserView.EVDelegate = self;
        ETTClasssModel * classModel = [_mModel getClassModel:classId];
        [_MVRightUserView reloadView:@[classModel] lockScreen:_mModel.EDLockView];
        [self.view addSubview:_MVRightUserView];
       
    }
}
-(void)crateLeftView
{
    [self.view addSubview:self.MVLeftView];
}

-(ETTClassListView *)MVLeftView
{
    if (_MVLeftView == nil)
    {
        _MVLeftView            = [[ETTClassListView alloc]initWithFrame:CGRectMake(0, 10, 233, self.view.height - KNavigationH -10)];
        _MVLeftView.EVDelegate = self;
        _MVLeftView.EVModel    = _mModel;
    }
    return _MVLeftView;
}

-(void)pEvenHandler:(id)object withCommandType:(NSInteger)commandType
{
    if (!object)
    {
        return;
    }
    
    if([object isKindOfClass:[ETTClassUserModel class]])
    {
        
    }
}


//用于页面切换
-(void)pEvenChangeViewHandler:(id)object withCommandType:(NSInteger)commandType
{
    if ([object isKindOfClass:[ETTClassificationModel class]])
    {
        [self changeUserListView:object ];
    }
}
#pragma mark --------------所以 ETTView 类型视图 集中代理回调 ----------------------
//用户功能名利操作
-(void)pEvenFunctionOperation:(id)object withCommandType:(NSInteger)commandType withInfo:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = sender;
        [self postUserPerformanceDataDic:dic withCommandType:commandType];
    }
    
    
    if ([object isKindOfClass:[ETTClassListView class]])
    {
        ///锁屏
        [self classListOperation:commandType];
    }
    
    else if ([object isKindOfClass:[ETTShowOnlineUserView class]])
    {
        [self userOperation:commandType withInfo:sender];
    }
    else if ([object isKindOfClass:[ETTClassUserListView class]])
    {
        [self showOnlineUserOperation:commandType withInfo:sender];
    }
    else if ([object isKindOfClass:[ETTShowTeacherRollCallView class]])
    {
        [self teachRollCallOperation:commandType withInfo:sender];
    }
}

// 发送网络请求
- (void)postUserPerformanceDataDic:(NSDictionary *)dic withCommandType:(NSInteger)commandType
{
    NSString *jid = isEmptyString(dic[@"jid"])?@"":dic[@"jid"];
    NSString *eventTime = isEmptyString(dic[@"eventTime"])?@"":dic[@"eventTime"];
    
    if (isEmptyString(jid)||isEmptyString(eventTime)) {
        return;
    }

    // 向后台发数据
    NSString *urlBody = @"axpad/event/saveRaceEvent.do";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];
    int type = 0;
    NSArray *raceArr;
    switch (commandType) {
        case ETTTEACHERMOMMANDREWARD:// 奖励
            type = 1;
            break;
        case ETTTEACHERMOMMANDREMIND:// 提醒
            type = 2;
            break;
        case ETTTEACHERMOMMANDREPONDER:// 抢答
            type = 3;
            raceArr = [dic objectForKey:@"raceArr"];
            break;
        case ETTTEACHERMOMMANDROLLCALL:// 点名
            type = 4;
            break;
        default:
            break;
    }
    
    NSMutableArray *userListArr = [NSMutableArray array];
    NSDictionary *userListDic;
    if (raceArr&&raceArr.count>0) {
        for (int i=0; i<raceArr.count; i++) {
            ETTResponderModel *model =raceArr[i];
            NSDictionary *userListDics = @{@"jid":model.jid,
                                          @"raceTime":model.time
                                          };
            [userListArr addObject:userListDics];
        }
        
    }else{
        userListDic = @{@"jid":jid,
                        };
        [userListArr addObject:userListDic];
    }

    
    NSDictionary *dataDic = @{@"eventType":@(type),
                              @"eventTime":eventTime,
                              @"userList":userListArr
                              };
    NSArray *dataArr = [NSArray arrayWithObject:dataDic];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *param = @{@"jid":_mModel.EDClassModel.jid,
                            @"classroomId":_mModel.EDClassModel.classroomId,
                            @"dataJson":jsonStr
                            };
    [[ETTNetworkManager sharedInstance] POST:urlString Parameters:param responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        if (error) {
            ETTLog(@"%@",error);
        }else{
            NSNumber *result = [responseDictionary objectForKey:@"result"];
            if ([result isEqual:@1]) {
                ETTLog(@"提交成功");
            }else{
                
            }
        }
 
    }];

}
#pragma  mark -----------点名 后回调--------------

/**
 Description   点名视图 回调

 @param commandType 事件类型
 @param sender      回调的对象
 */
-(void)teachRollCallOperation:(NSInteger)commandType withInfo:(id)sender
{
   
    switch (commandType)
    {
        case ETTTEACHERMOMMANDROLLCALL:
        {

            NSDictionary * dic = sender;
            BOOL show = [[dic valueForKey:@"show"] boolValue];
            if (show)
            {
                _mModel.EDRollCallCount ++;
                NSString * jid = [dic valueForKey:@"jid"];
                if(jid.integerValue<=0)
                {
                    jid = @"";
                }
                
                ///老师点名学生数据
                [ETTUserInformationProcessingUtils publishMessageType:@"MA_06" toJid:jid];
            }
            else
            {
                ///老师点名学生数据
                [ETTUserInformationProcessingUtils publishMessageType:@"MA_06_End" toJid:nil];
            }
            
        }
            break;
        case  ETTTEACHERMOMMANDREWARD:
        {
            NSDictionary * dic = sender;

            NSString * jid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"jid"]];
            if(jid.integerValue<=0)
            {
                jid = @"";
            }
            //奖励
            
            [ETTUserInformationProcessingUtils publishMessageType:@"MA_02" toJid:jid names:@[[dic valueForKey:@"name"]]];
            

        }
            break;
        default:
            break;
    }

}

-(void)pEvenCloseView:(id)object
{
    if ([object isKindOfClass:[ETTShowTeacherRollCallView class]])
    {
        [_MVLeftView setRollCallSelected:false];
    }
   
        ETTView * view = object;
        [view removeFromSuperview];

        
}
#pragma mark ----------------- 左侧班级 列表 事件回调 --------------------
/**
 Description  左侧班级 列表 事件回调 处理

 @param commandType 事件类型
 */
-(void)classListOperation:(NSInteger)commandType
{
    switch (commandType)
    {
        //锁屏
        case ETTTEACHERMOMMANDLOCKSCREEN:
        {
            _mModel.EDLockView =!_mModel.EDLockView;
            _MVRightUserView.EVIsLockView = _mModel.EDLockView;
        }
            break;
        //点名
        case ETTTEACHERMOMMANDROLLCALL:
        {
            if (_mModel.EDOnlineUserArr.count)
            {
                ETTShowTeacherRollCallView * resview = [[ETTShowTeacherRollCallView alloc]initWithFrame:self.view.bounds withModelList:_mModel.EDOnlineUserArr];
                resview.EVDelegate = self;
                [resview showView];
            }
            else
            {
                [self.view toast:@"还没有在线学生"];
                [_MVLeftView setRollCallSelected:false];
            }
           
        }
            break;
        //抢答
        case ETTTEACHERMOMMANDREPONDER:
        {
            [ETTUserInformationProcessingUtils publishMessageType:@"MA_07_BEGIN" toJid:nil];
            ETTShowTeacherResponderVCTR * vctr = [[ETTShowTeacherResponderVCTR alloc]init];
            vctr.EVManagerVCTR = self;
            [self.navigationController pushViewController:vctr animated:YES];
        }
            break;
        //分组
        case ETTTEACHERMOMMANDGROUP:
        {
            
        }
            break;
        //偷屏
        case ETTTEACHERMOMMANDTV:
        {
            
        }
            break;
            
        default:
            break;
    }

}
#pragma mark 点击在线用户头像 展示对用户的操作视图

/**
 Description   点击 右侧 班级列表 对在线学生，弹出视图，进行操作

 @param commandType 事件类型
 @param sender      操作传递的对象
 */
-(void)showOnlineUserOperation:(NSInteger)commandType withInfo:(id)sender
{
    if (!sender)
    {
        return;
    }
    switch (commandType) {
        //对在线学生，弹出视图，进行操作
        case ETTTEACHERMOMMANDSHOWUERINFO:
        {
            ETTClassUserModel * model = sender;
            if (model)
            {
                ETTShowOnlineUserView * view = [[ETTShowOnlineUserView alloc]initWithFrame:self.view.bounds withModel:model];
                view.EVDelegate = self;
                [view showView];
            }
           
        }
            break;
        //分组奖励
        case ETTTEACHERMOMMANDREWARDGROUP:
        {
            //ETTClassUserModel 在线需要奖励的用户model数组
            NSDictionary * dic = sender;

            NSArray * arr = [dic valueForKey:@"jid"];
            
            if (arr.count)
            {
                NSString  * string = [arr componentsJoinedByString:@","];
                [ETTUserInformationProcessingUtils publishMessageType:@"MA_02" toJid:string names:[dic valueForKey:@"names"]];
                ////////////////////////////////////////////////////////
                /*
                 new      : add
                 time     : 2017.3.22  18:46
                 modifier : 康晓光
                 version  ：Epic_0322_AIXUEPAIOS-1124
                 branch   ：Epic_0322_AIXUEPAIOS-1124/AIXUEPAIOS-1116
                 describe : 小组奖励没有动画效果
                 operation: 加入奖励分组文字动画效果
                 
                 */
                [[ETTCharacterAnimationManager shareAnimationManager] createAnimationView:ETTCHARANIMATIONREWAREGROUP info:[dic valueForKey:@"names"]];
                /////////////////////////////////////////////////////
            }
        }
            break;
        default:
            break;
    }

}
#pragma mark ---------- 对在线学生 进行操作   ------

/**
 Description  点击在线学生 弹出的视图 中事件回调

 @param commandType 事件类型
 @param sender      回调传递对象
 */
-(void)userOperation:(NSInteger)commandType withInfo:(id)sender
{
    NSDictionary  * dic  = sender;
    if (!dic )
    {
        return;
    }
    
    NSString * jid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"jid"]];
    if (jid.integerValue<= 0)
    {
        return;
    }
    switch (commandType) {
        case ETTTEACHERMOMMANDREWARD:
        {
            //奖励
            [_mModel.EDClassModel changeRewardScoreUserModel:jid.integerValue];
            [ETTUserInformationProcessingUtils publishMessageType:@"MA_02" toJid:jid names:@[[dic valueForKey:@"name"]]];
            
        }
            break;
        case ETTTEACHERMOMMANDREMIND:
        {
            //提醒
            [ETTUserInformationProcessingUtils publishMessageType:@"MA_03" toJid:jid];
        }
            break;
        case ETTTEACHERMOMMANDLOOKSTU:
        {
            //查看
            [ETTUserInformationProcessingUtils publishMessageType:@"MA_04" toJid:jid];
        }
            break;
            
        default:
            break;
    }
}


-(void)changeUserListView:(id)object
{
    ETTClassificationModel * model = object;
    switch (model.classType)
    {
        case ETTCLASSTYPEONLINE:
        {
            self.MVPerformanceBtn.hidden = YES;
            [self createRightOnlieUserView];
        }
            break;
        case ETTCLASSTYPEATTEND:
        {
            self.MVPerformanceBtn.hidden = YES;
            [self createRightAttendUserView];
        }
            break;
        case ETTCLASSESTABLISH:
        {
            [self createRightEstablsihView:model.classId];
            self.MVPerformanceBtn.hidden = false;

        }
            break;
        default:
            break;
    }
    [self.view bringSubviewToFront: _MVIsPushingBtn];
}
-(void)manageViewControllerClose:(ETTViewController *)VCTR withCommond:(NSInteger)commondType
{
    switch (commondType)
    {
        case ETTVCTROMMANDTYPECLOSE:
        {
            [_MVLeftView setResponderSelected:false];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ----------------------抢答 控制器页面返回------------------------------
-(void)manageViewDataOperation:(id)data
{
    _mModel.EDResponderCount ++;
    NSArray * arr = data;
    if(arr && arr.count)
    {
        [_mModel setStudentAnswerData:arr];
    }
}


/**
 Description 抢答 控制器页面返回 回调

 @param VCTR 抢答 控制器
 @param commondType 操作类型
 @param object 回调数据字典 分为：操作的学生model和在控制器页面 点击抢答操作数目总和
 */
-(void)manageViewControllerClose:(ETTViewController *)VCTR withCommond:(NSInteger)commondType withInfo:(id)object
{
    switch (commondType)
    {
        case ETTVCTROMMANDTYPECLOSE:
        {
            if (object)
            {
                [self postUserPerformanceDataDic:object withCommandType:ETTTEACHERMOMMANDREPONDER];
                NSDictionary * dic = object;
                NSString * jid = [dic valueForKey:@"jid"];
                if(jid.integerValue<=0)
                {
                    return;
                }
                
            }
            [_MVLeftView setResponderSelected:false];
        }
            break;
            
        default:
            break;
    }
}
- (void)showReaderViewController {
    
    ETTTestViewController *testVC = [[ETTTestViewController alloc]init];
    testVC.view.backgroundColor   = [UIColor whiteColor];
    [self.navigationController pushViewController:testVC animated:YES];
    
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    UIView *leftView     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];

    //左侧菜单按钮
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    menuButton.frame     = CGRectMake(-10, 2, 42, 41);
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];

    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label       = [[UILabel alloc] init];
    label.textColor      = [UIColor whiteColor];
    label.font           = [UIFont systemFontOfSize:17];
    label.textAlignment  = NSTextAlignmentCenter;
    label.text           = @"学生管理";
    label.frame          = CGRectMake(42+5-10, 7, 75, 30);
    [leftView addSubview:menuButton];
    [leftView addSubview:label];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
    [self createRerformanceBtn];
}

-(void)createRerformanceBtn
{
    if (_MVPerformanceBtn == nil)
    {
        _MVPerformanceBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MVPerformanceBtn setTitle:@"课堂表现" forState:UIControlStateNormal];
        [_MVPerformanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_MVPerformanceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _MVPerformanceBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_MVPerformanceBtn.titleLabel sizeToFit];
        _MVPerformanceBtn.frame           = CGRectMake(0, 0, _MVPerformanceBtn.titleLabel.width, 44);
        [_MVPerformanceBtn addTarget:self action:@selector(rerformanceBtnHandle) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_MVPerformanceBtn];
    }

}
#pragma mark ---发送 班级信息数据---
-(void)sendClassRedisMsg:(NSDictionary *)dic
{
    
}

-(void)pushClassIntegral
{
    NSMutableDictionary * classDic = [NSMutableDictionary dictionary];
    [classDic setValue:@(_mModel.EDRollCallCount) forKey:@"rollCallCount"];
    [classDic setValue:@(_mModel.EDResponderCount) forKey:@"answerCount"];
    NSArray * arr                  = [_mModel.EDClassModel getClassClassIntegral];
    [classDic setValue:arr forKey:@"data"];
    NSDictionary * messDic         = @{@"userInfo":classDic};

    WS(weakSelf);
    NSString * messJSON            = [ETTRedisBasisManager getJSONWithDictionary:messDic] ;
    NSString * key                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_INTEGRAL,_mModel.EDClassModel.classroomId];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    [redisManager redisSet:key value:messJSON respondHandler:^(id value, id error) {
        if (!error) {
            [weakSelf setHMapWithRedis:classDic];
            NSLog(@"提交学生积分成功");
        }else{
            NSLog(@"提交学生积分失败!");
        }
    }];


}
-(void)rerformanceBtnHandle
{
    ETTTeacherClassPerformanceVCTR * vctr = [[ETTTeacherClassPerformanceVCTR alloc]init];
    ETTTeaClassPerformanceModel * model   = [[ETTTeaClassPerformanceModel alloc]init];
    NSString * classid                    = [_MVLeftView getCurrentViewModel].classId;
    NSArray * arr =[NSArray arrayWithObjects:[_mModel getClassModel:classid ], nil];
    model.EDClassModelArr                 = arr;
    model.EDResponderCount                = _mModel.EDResponderCount;
    model.EDRollCallCount                 = _mModel.EDRollCallCount;
    model.EDClassroomId                   = _mModel.EDClassModel.classroomId;

    vctr.EVModel                          = model;
    [[ETTScenePorter shareScenePorter] registerGurad:vctr withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
    [self.navigationController pushViewController:vctr animated:YES];


 
}


//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHMapWithRedis:(NSDictionary *)dict
{
    
    NSString *classroomChannle = [NSString stringWithFormat:@"%@%@",_mModel.EDClassModel.classroomId,kPCI_CLASSROOM_CHANNEL];
    NSDictionary *messDic = @{@"mid":[NSString stringWithFormat:@"%@_IOS",[ETTRedisBasisManager getTime]],
                              @"time":[ETTRedisBasisManager getTime],
                              @"form":_mModel.EDClassModel.jid,
                              @"type":@"CP_01",
                              @"to":@"ALL",
                              @"userInfo":dict};
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *channelJSON = [ETTRedisBasisManager getJSONWithDictionary:messDic];
    [redisManager publishMessageToChannel:classroomChannle message:channelJSON respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"推送学生课堂信息成功!");
            NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
            NSString *key = [NSString stringWithFormat:@"%@%@",_mModel.EDClassModel.classroomId,kPCI_WHICHPERFORMED];
            NSString *field = @"XMAN";
            NSDictionary *messDic = @{field:messageJSON};
            ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
            [redisManager redisHMSET:key dictionary:messDic respondHandler:^(id value, id error) {
                if (!error) {
                    NSLog(@"学生课堂表现数据更新成功！！！");
                } else {
                    NSLog(@"学生课堂表现数据更新失败！！！");
                }
            }];
        }else{
            NSLog(@"推送学生课堂信息失败!");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
