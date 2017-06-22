//
//  AXPWhiteboardViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//
#import "AXPWhiteboardViewController.h"
#import "AXPWhiteboardToolbarManager.h"
#import "ETTSideNavigationManager.h"
#import "UIView+UIImage.h"
#import "ETTStudentAnswerListView.h"
#import "AXPStudentAnswerListCollectionViewCell.h"
#import "AXPMarkScoreView.h"
#import "AXPCheckOriginalSubjectView.h"
#import "AXPStudentSubjectViewController.h"
#import "ETTNetworkManager.h"
#import "AXPRedisManager.h"
#import "AXPWhiteboardPushModel.h"
#import <SDWebImageManager.h>
#import "ETTNetworkManager.h"
#import "ETTImagePickerManager.h"
#import "AXPUserInformation.h"
#import "AXPRewardManagerView.h"
#import "AXPRedisSendMsg.h"
#import "ETTImageManager.h"
#import "AXPGetRootVcTool.h"
#import "ETTNormalGuardModel.h"
#import "ETTScenePorter.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTJudgeIdentity.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTStudentTestPaperDetailViewController.h"
#import "ETTStudentVideoAudioViewController.h"
#import "ETTCoursewareStackManager.h"
#import "ReaderViewController.h"
#import "ETTCoursewareStackManager.h"
#import "ETTRestoreCommand.h"
#import "ETTAnouncement.h"
#define CHECKSUBJECTBUTTON   @"checkSubjectButton"
#define FINISHEDANSERBUTTON  @"finishedAnswerButton"

@interface AXPWhiteboardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

#pragma  mark -- studentProperty

@property (nonatomic        ) BOOL                 isPaperComment;

@property (nonatomic ,strong) NSTimer              *getCommentImageTimer;

@property (nonatomic ,copy  ) NSString             *answerImageUrl;

@property (nonatomic ,copy  ) NSString             *wbImgUrl;

// 批阅图片
@property (nonatomic ,strong) UIImage              *commentImage;

@property (nonatomic ,strong) AXPRewardManagerView *rightRewardView;

// 学生作答的白板页
@property (nonatomic ,strong) UIView               *studentAnswerWbView;

// 学生互批的白板页
@property(nonatomic ,strong) UIView                *studentConmmentWbView;

@property(nonatomic ,strong) UIButton *markScoreButton;
@property(nonatomic ,strong) UIButton *submitButton;
@property(nonatomic ,strong) UIButton *commentButton;

@property(nonatomic ,strong) NSMutableDictionary *pushDict;
@property(nonatomic ) BOOL isSubmitSuccess;
@property(nonatomic ) BOOL isCommentSuccess;
@property(nonatomic ) BOOL isSuccessGetImage;

@property(nonatomic ) BOOL isSubmitPaperImage;

@property(nonatomic ) NSInteger score;

@property(nonatomic ) BOOL hasPresentVc;

@property(nonnull,retain)UIButton  * pushButton;
@property(nonatomic,copy) NSString *studentGetTeacherPushWhiteboardId;//学生获得老师每次推送白板id

@property(nonatomic ,copy) NSString *brushColorStr;
@property(nonatomic ,strong) UIColor *brushColor;
@property(nonatomic ) CGFloat brushAlpha;
@property(nonatomic ) CGFloat brushSize;

@property(nonatomic ,strong) UIColor *textColor;
@property(nonatomic ) CGFloat textFontSize;



#pragma  mark -- teacherProperty

@property (nonatomic ,strong) NSMutableArray           *pushStatus;

@property (nonatomic ,strong) NSMutableDictionary      *classroomDict;
@property (nonatomic ,strong) UILabel                  *titleLabel;
@property (nonatomic ,strong) UIButton                 *finishedPushButton;
@property (nonatomic ,strong) NSMutableArray           *studentAnswerList;
@property (nonatomic ,weak  ) ETTStudentAnswerListView *answerListView;
@property (nonatomic ,copy  ) NSString                 *pushId;
@property (nonatomic ,strong) NSMutableDictionary      *scoreDict;
@property (nonatomic ,strong) NSMutableArray           *studentScoreList;
@property(nonatomic  ,copy)   NSString                 *teacherPushWhithboardId;//老师每次推送白板的id


@property(nonatomic) BOOL isMarkScore;

#pragma  mark -- publickProperty

@property (nonatomic ,strong) NSMutableArray                *wbStatus;

// 原题
@property (nonatomic ,strong) UIImage                       *originImage;
// 用户信息
@property (nonatomic ,strong) AXPUserInformation            *userInformation;

@property (nonatomic ,strong) UILabel                       *eleWhiteboardLabel;


@property (nonatomic ,strong) AXPWhiteboardToolbarManager   *whiteboardManager;

@property (nonatomic ,copy  ) studentRespondImage           paperImageHandle;

@property (nonatomic        ) ETTSideNavigationViewIdentity identity;

@property (strong, nonatomic) NSMutableDictionary           *dictionary;

@property (copy, nonatomic  ) NSString                      *imageUrlString;//老师推送过来的图片链接

@property (nonatomic,assign)  BOOL                           MVHasPushAction;


////////////////////////////////////////////////////////
/*
 new      : Modify
 time     : 2017.3.14  18:30
 modifier : 康晓光
 version  ：Epic-0313-AIXUEPAIOS-1061
 branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
 describe : 增加开始答题判断
 */
@property (nonatomic,assign)  BOOL                           MVIsBeginAnser;
/////////////////////////////////////////////////////


@end

// 直接走频道订阅的数据:

// NSString * const kREDIS_COMMAND_TYPE_WB_01 = @"RedisCommandTypeWB01";
// 对应的 Type :WB_01; 老师改变课堂状态. 学生负责接收这个Key值的信息获取课堂状态;

// NSString * const kREDIS_COMMAND_TYPE_SWB_02 = @"RedisCommandTypeSWB02";
// 对应的 Type :SWB_02; 学生白板作答. 老师负责接收这个Key值的白板作答信息;

// NSString * const kREDIS_COMMAND_TYPE_SWB_03 = @"RedisCommandTypeSWB03";
// 对应的 Type :SWB_03; 学生白板批阅. 老师负责接收这个Key值的白板批阅信息;

// NSString * const kREDIS_COMMAND_TYPE_SWB_04 = @"RedisCommandTypeSWB04";
// 对应的 Type :SWB_04; 学生试卷批阅. 老师负责接收这个Key值的试卷批阅信息;

// 先redis缓存再通过频道订阅通知学生的数据:
// NSString * const kREDIS_COMMAND_TYPE_WB_05 = @"RedisCommandTypeWB05";
// 对应的 Type :WB_05; 老师分发完作答数据之后,通过频道订阅告诉学生.学生接收到这个Key值对应的数据之后,去相应的redis缓存中获取自己需要的数据.

static NSString *classroomState = @"WB_01";
static NSString *student_wb_answer = @"SWB_02";
static NSString *student_wb_commnet = @"SWB_03";
static NSString *student_pt_commnet = @"SWB_04";
static NSString *teacher_issue_answerCard = @"WB_05";

static int DELAY_DOWNLOAD_TIME = 3;

@implementation AXPWhiteboardViewController
@synthesize MVHasPushAction = _MVHasPushAction;

-(void)viewDidLoad
{
    [super viewDidLoad];
    _MVHasPushAction = false;
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  18:31
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
     describe : 初始化值
     */
    _MVIsBeginAnser  = false;
    /////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOriginalSubject) name:@"checkOriginalSubject" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCommentImage) name:@"checkCommentImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStudentRespondImage) name:@"checkStudentRespondImage" object:nil];
    
    ETTSideNavigationViewIdentity identity;
    
    if (![self.userInformation.userType isEqualToString:@"teacher"]) {
        
        identity = ETTSideNavigationViewIdentityStudent;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studentGetTeacherPushWBInfo:) name:kREDIS_COMMAND_TYPE_WB_01 object:nil];
        
    }else
    {
        identity = ETTSideNavigationViewIdentityTeacher;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherGetStudentWBAnswerInfo:) name:kREDIS_COMMAND_TYPE_SWB_02 object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherGetStudentWBCommentInfo:) name:kREDIS_COMMAND_TYPE_SWB_03 object:nil];
    }
    
    self.identity = identity;

    self.whiteboardManager = [AXPWhiteboardToolbarManager reginViewController:self];
    [self.whiteboardManager resetToolBarManager];
    [self setUpWhiteboardNavagationBarWithIdentity:identity];
}

-(void)studentGetClassMessage:(NSDictionary *)classMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([classMessage[@"type"] isEqualToString:classroomState]) {
            
            NSDictionary *userInfo = classMessage[@"userInfo"];
            
            [self originGetPushInfo:userInfo];
            
        }
    });
}

#pragma mark -- NSNotification

// 学生接收到教师推送的课堂状态信息
-(void)studentGetTeacherPushWBInfo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    [self originGetPushInfo:userInfo];
}

// 老师接收到学生的白板作答数据
-(void)teacherGetStudentWBAnswerInfo:(NSNotification *)notify
{
     [self reciveteacherGetStudentWBAnswerInfo:notify.object];

}


-(void)reciveteacherGetStudentWBAnswerInfo:(NSDictionary *)dict
{
    if (dict)
    {
        NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
        
        NSString *whiteboardId = [userInfo objectForKey:@"whiteboardId"];
        
        //新增:如果学生提交的白板id和老师推送的白板id一样才接受
        if ([self.teacherPushWhithboardId isEqualToString:whiteboardId]) {
            
            [self getStudentWbAnswerData:userInfo];
        }

    }
}
-(void)getStudentWbAnswerData:(NSDictionary *)dict
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  18:49
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
     describe : 判断如果没有开始推送并且开始答题 则不接受数据
     */
   
    if (_MVIsBeginAnser && _MVHasPushAction)
    {
        if (self.studentAnswerList)
        {
        
             [self.studentAnswerList addObject:dict.mutableCopy];
            
            ////////////////////////////////////////////////////////
            /*
             new      : add
             time     : 2017.4.7  15:33
             modifier : 康晓光
             version  ：bugfix/Epic-0331-AIXUEPAIOS-1157
             branch   ：bugfix/Epic-0331-AIXUEPAIOS-1157／AIXUEPAIOS-1155
             problem  ：老师某次白板推送，结束作答时，开始收到双份答案
             describe : 过滤相同的学生数据
             */

             [self filterSamestudentAnswer];
            ////////////////////////////////////////////////////////

        }
       
    }
    else
    {
        if (self.studentAnswerList)
        {
            [self.studentAnswerList removeAllObjects];
        }
    }
    //[self.studentAnswerList addObject:dict.mutableCopy];
    /////////////////////////////////////////////////////
   
    
    [self changeStatuesWhenGetStudentAnswers];
}
////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.4.7  15:33
 modifier : 康晓光
 version  ：bugfix/Epic-0331-AIXUEPAIOS-1157
 branch   ：bugfix/Epic-0331-AIXUEPAIOS-1157／AIXUEPAIOS-1155
 problem  ：老师某次白板推送，结束作答时，开始收到双份答案
 describe : 过滤相同的学生数据
 */

-(void)filterSamestudentAnswer
{
    NSMutableSet *seenObjects = [NSMutableSet set];
    NSPredicate *dupPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        NSDictionary  *hObj = (NSDictionary *)obj;
        BOOL seen = [seenObjects containsObject:[hObj valueForKey:@"userId"]];
        if (!seen) {
            [seenObjects addObject:[hObj valueForKey:@"userId"]];
            
        }
        return !seen;
    }];
    
    [self.studentAnswerList filterUsingPredicate:dupPred];;
    
}
/////////////////////////////////////////////////////
// 老师接收到学生的白板批阅数据
-(void)teacherGetStudentWBCommentInfo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    [self getStudentWbCommentData:userInfo];
}

-(void)getStudentWbCommentData:(NSDictionary *)scoreDict
{
    // 4. 监听学生打分数据
    self.isMarkScore = YES;
    
    // 在作答列表数据中增加互批(打分)数据.
    [self.studentAnswerList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableDictionary *answerDict = dict.mutableCopy;
        
        [scoreDict enumerateKeysAndObjectsUsingBlock:^(NSString *jid, NSDictionary *pointDict, BOOL * _Nonnull stop) {
            
            NSString *markJid = [NSString stringWithFormat:@"%@",answerDict[kmarkJid]];
            
            if ([jid isEqualToString:markJid]) {
                
                [answerDict setObject:pointDict[kpoint] forKey:kmarkPoint];
                [answerDict setObject:pointDict[kcommentImageUrl] forKey:kcommentImageUrl];
                
                [self.studentScoreList addObject:answerDict];
                
                *stop = YES;
            }
        }];
    }];
    
    // 属性数据
    [self changeStatuesWhenGetStudentAnswers];
}

//设置menuButton
- (void)setupMenu {
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    self.menuButton.frame = CGRectMake(-10, 2, 42, 41);
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isPushSubjectItem == YES) {
        [self.menuButton setUserInteractionEnabled:NO];
        [self.menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateNormal];
    } else {
        [self.menuButton setUserInteractionEnabled:YES];
        [_menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
        [_menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
    }
    
    UILabel *label = [self creatNavigationBarLabel];
    label.frame    = CGRectMake(42+5-10, 7, 75, 30);
    label.text     = self.navigationItem.title;
    self.eleWhiteboardLabel = label;
    
    [leftView addSubview:self.menuButton];
    [leftView addSubview:self.eleWhiteboardLabel];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.identity == ETTSideNavigationViewIdentityTeacher) {
        
        __block BOOL isWBPush;
        
        [self.wbStatus enumerateObjectsUsingBlock:^(NSString *state, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([self.classroomDict[@"state"] isEqualToString:state]) {
                
                isWBPush = YES;
                
                *stop = YES;
            }
        }];
        
        if (!isWBPush) {
            
            self.whiteboardManager.suspendNimbleView.suspendNimbleButton.hidden = NO;
        }else
        {
        }
        
        if ([ETTBackToPageManager sharedManager].isPushing )
        {
            if (![[ETTScenePorter shareScenePorter] queryWhetherCanPushOperation:self.EVGuardModel])
            {
                _pushButton.hidden = YES;
            }
            
        }
        else
        {
            _pushButton.hidden = false;
        }
        if (self.whiteboardManager)
        {
            [self.whiteboardManager byManagementViewWillAppear];
        }
        
    } else {
        
        [self setupMenu];
        
    }
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.identity == ETTSideNavigationViewIdentityTeacher) {
        
        [self.whiteboardManager.suspendNimbleView hiddenNimbleToolbarCompletion:^{
        }];
    }
}

- (void)hiddenRewardManagerView
{
    if (self.rightRewardView) {
        [self.rightRewardView hiddenRewardManagerView];
    }
}

#pragma mark -- Student


-(void)originGetPushInfo:(NSDictionary *)dict
{   /*
     课堂状态：
     
     -2:被关闭
     
     0:自由
     
     1:同步阅读中
     
     2:测试进行中
     
     3:测试结束讲解进行中
     
     4:画板推送中
     
     5:画板答案推送中
     
     6:课堂锁定
     
     7:画板预览推送
     
     20:白板互批结束
     
     21:推送学生作答图片
     
     22:推送学生批阅图片
     
     23:推送学生 作答/批阅 图片结束
     
     (包括白板作答/批阅,试卷作答/批阅)
     
     24:推送学生试卷作答图片
     
     25:推送学生试卷批阅图片
     
     26:学生试卷互批
     
     27:学生试卷互批结束
     */
    
    if (self.presentedViewController) {
        
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (![dict[kstate] isEqualToString:@"5"] && ![dict[kstate] isEqualToString:@"26"]) {
        self.whiteboardManager.whiteboardConfig.isMutualCorrect = NO;
    }
    
    //白板推送
    if ([dict[kstate] isEqualToString:@"4"]) {
        ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];

        ETTNavigationController *currentVc       = sideNav.childViewControllers[sideNav.index];
        [[ETTCoursewareStackManager new]resumeCourse:currentVc];
        UIViewController *rootVC                 = currentVc.topViewController;
        
        // 收到老师白板推送  发送消息 康晓光 2.21 下午 4:11 添加  //
        [[NSNotificationCenter defaultCenter]postNotificationName:ETTWBPushingNotification object:nil];
        //////////////////////////////////////////////////////
        
        /*
         *  相同操作，一行代码可以解决.
         *  Johnny      2017.03.09
         */
        if ([rootVC isKindOfClass:[ETTStudentTestPaperDetailViewController class]]||[rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
            [rootVC.navigationController popViewControllerAnimated:NO];
        }else if ([rootVC isKindOfClass:[ReaderViewController class]]){
            [rootVC dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
        
        /**
         *  @author LiuChuanan, 17-04-07 17:42:57
         *  
         *  @brief  老师在推白板时,如果学生之前自己打开了一个课件,把记录学生自己打开的课件控制器置为nil
         *
         *  @branch origin/bugfix/AIXUEPAIOS-1178
         *   
         *  @Epic   origin/bugfix/Epic-0407-AIXUEPAIOS-1175
         * 
         *  @since 
         */
        if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[ReaderViewController class]]) 
        {
            [ETTBackToPageManager sharedManager].pushingVc = nil;
        }
        
        //收起左侧栏
        [sideNav keepLeft];
    }
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    // 跳转到白板控制器
    [self.wbStatus enumerateObjectsUsingBlock:^(NSString *status, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([dict[kstate] isEqualToString:status]) {
            
            self.whiteboardManager.whiteboardConfig.isWhiteboardPushing = YES;
            
            // 0. 进入白板控制器
            
            // 试卷主观题互批
            if ([status isEqualToString:@"26"])
            {
                if (!self.isPaperComment) {
                    
                    [self startPaperComment];
                    
                    if (rootVc.index != 1) {
                        
                        // 学生/电子白板页是 1, 教师是 2
                        
                        //学生提交了作答信息才将互批信息分给他
                        BOOL isCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
                        
                        //判断学生有没有提交
                        if (isCommit) {
                            [rootVc presentViewControllerToIndex:1 title:nil];
                        }
                    }
                    
                }
            }else
            {
                [self checkCurrentWhiteboardVc];
                
                // 记录白板推送之前学生端的页面
                [ETTBackToPageManager sharedManager].forwardIndex = rootVc.index;
                
                if (rootVc.index != 1) {
                    // 学生端跳转到白板页 学生/电子白板页是 1, 教师是 2
                    [rootVc presentViewControllerToIndex:1 title:nil];
                }
                
            }
            
            *stop = YES;
            
        }else
        {
            self.whiteboardManager.whiteboardConfig.isWhiteboardPushing = NO;
        }
    }];
    
    // 判断推送状态和本地缓存的推送状态是否相同
    if (![[dict objectForKey:kstate] isEqualToString:[self.pushDict objectForKey:kstate]]) {
        
        self.pushDict = dict.mutableCopy;
        
        // 白板推送中
        if ([self.pushDict[kstate] isEqualToString:@"4"]){
            
            //新增 每次推送的唯一值
            self.studentGetTeacherPushWhiteboardId = [self.pushDict objectForKey:@"whiteboardId"];
            
            [ETTBackToPageManager sharedManager].isPushing = YES;
            self.isPaperComment = NO;
            
            // 0. 显示白板推送状态下 学生端白板的导航栏
            [self setUpStudentPushingBarStatus];
            
            // 1. 更换当前白板页为推送状态下的白板页: -- 白板答题页
            
            // 1.1 创建白板答题页
            [self.whiteboardManager addPushingWhiteboardView];
            
            // 1.2 记录白板答题页
            self.studentAnswerWbView = self.whiteboardManager.whiteboardView;
            
            // 2. 下载推送中的白板图片并显示在白板答题页中
            [self studentWhiteboardPushing];
            
            return ;
            
        }
        // 白板答题
        if ([self.pushDict[kstate] isEqualToString:@"2"]){
            
            self.isPaperComment = NO;
            
            // 0. 显示白板答题状态下 学生端白板的导航栏(提交按钮)
            [self setUpStudentAnswerStatus];
            
            // 1. 判断是否存在白板答题页并添加
            if (!self.studentAnswerWbView) {
                
                [self addStudentWhiteboardAnswerView];
            }
            
            return;
        }
        // 白板答题结束
        if ([self.pushDict[kstate] isEqualToString:@"3"]){
            
            self.isPaperComment = NO;
            
            // 0. 提交按钮变为已结束
            [self setUpStudentAnswerOverStatus];
            
            // 1. 判断是否存在白板答题页
            if (!self.studentAnswerWbView) {
                
                [self addStudentWhiteboardAnswerView];
                
            }else
            {
                // 强制提交学生未作答的信息.
                [self submitAnswerImageIsforce:YES];
            }
            
            return;
        }
        // 白板互批
        if ([self.pushDict[kstate] isEqualToString:@"5"]){
            
            self.isCommentSuccess = NO;

            self.isPaperComment = NO;
            
            // 无论是手动提交还是被强制提交,提交成功之后都会有成功标志
            if (self.isSubmitSuccess) {
                // 进入互批环节
                
                // 0. 显示批阅按钮和打分按钮.
                [self setUpStudentMutualCorrectStatus];
                
                // 1. 创建学生白板批阅页面
                [self.whiteboardManager addPushingWhiteboardView];
                
                // 1.0 记录学生端创建的白板批阅页面
                self.studentConmmentWbView = self.whiteboardManager.whiteboardView;
                
                // 2. 获取互批数据并展示在白板批阅页面
                [self studentBeiganGetCommentImage];
                
                // 3. 学生端 画笔默认:红色,3px.不可弹框.
                // 文字默认: 红色,13px.不可弹框
                [self setUpDefaultWhiteboardManagerisRed:YES];
                
            }else
            {
                // 0. 提交按钮变为已结束
                [self setUpStudentAnswerOverStatus];
                
                // 显示白板答题页面,不参与互批
                if (!self.studentAnswerWbView) {
                    
                    [self addStudentWhiteboardAnswerView];
                }
            }
            
            return;
        }
        // 白板互批结束
        if ([self.pushDict[kstate] isEqualToString:@"20"]){
            
            self.isPaperComment = NO;
            
            // 0. 显示批阅成功之后的状态
            [self setUpStudentCommentSuccessStatus];
            
            if (self.studentConmmentWbView) {
                
                // 0. 强制收卷
                [self readOverAndCommentWhiteboardIsforce:YES];
                
                // 1. 显示右侧功能按钮: 查看原题/批阅图片
                [self addRightRewardManagerView];
                
                // 2. 显示白板答题页面
                [self.whiteboardManager resumeBeforePushedWhiteboard:self.studentAnswerWbView];
            }else
            {
                if (!self.studentAnswerWbView) {
                    
                    [self addStudentWhiteboardAnswerView];
                }
            }
            
            [self setUpDefaultWhiteboardManagerisRed:NO];
            return;
        }
        // 试卷主观题互批
        if ([self.pushDict[kstate] isEqualToString:@"26"]){
            
            self.isCommentSuccess = NO;
            // 进入试卷互批环节
            self.isPaperComment = YES;
            
            // 0. 显示批阅按钮和打分按钮.
            
            /**
             如果学生没有作答隐藏打分按钮,作答了的话,批阅显示打分按钮
             */
            
            //学生提交了作答信息才将互批信息分给他
            BOOL isCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
            
            //判断学生有没有提交
            if (isCommit) {
                
                [self setUpStudentMutualCorrectStatus];
            
            
            
            // 1. 创建学生白板批阅页面
            [self.whiteboardManager addPushingWhiteboardView];
            
            // 1.0 记录学生端创建的白板批阅页面
            self.studentConmmentWbView = self.whiteboardManager.whiteboardView;
            
            // 2. 获取互批数据并展示在白板批阅页面
            [self studentBeiganGetCommentImage];
            
            // 3. 学生端 画笔默认:红色,3px.不可弹框.
            // 文字默认: 红色,13px.不可弹框
            [self setUpDefaultWhiteboardManagerisRed:YES];
            }
            
            return;
        }
        // 试卷主观题互批结束
        if ([self.pushDict[kstate] isEqualToString:@"27"]){
            
            // 0. 强制收卷
            [self readOverAndCommentWhiteboardIsforce:YES];
            
            return;
        }
        // 推送学生作答图片
        if ([self.pushDict[kstate] isEqualToString:@"21"]){
            
            [self downloadAndShowImageWithState:self.pushDict[kstate]];
            
            return;
        }
        // 推送学生批阅图片
        if ([self.pushDict[kstate] isEqualToString:@"22"]){
            
            [self downloadAndShowImageWithState:self.pushDict[kstate]];
            
            return;
        }
        // 推送学生试卷作答图片
        if ([self.pushDict[kstate] isEqualToString:@"24"]){
            
            [self downloadAndShowImageWithState:self.pushDict[kstate]];
            
            return;
        }
        // 推送学生试卷批阅图片
        if ([self.pushDict[kstate] isEqualToString:@"25"]){
            
            [self downloadAndShowImageWithState:self.pushDict[kstate]];
            
            return;
        }
        // 推送学生 作答/批阅 图片结束
        if ([self.pushDict[kstate] isEqualToString:@"23"]){
            // 1. 关闭推送图片
            [self closePushingImage];
            
            return;
        }
        // 课堂锁定
        if ([self.pushDict[kstate] isEqualToString:@"6"]){
            
            return;
        }
        // 课堂关闭
        if ([self.pushDict[kstate] isEqualToString:@"-2"]){
            
            [self setUpStudentFinishedPushStatus];
            [self clearPushFinishedData];
            
            return;
        }
        // 结束推送
        if ([self.pushDict[kstate] isEqualToString:@"0"])
        {
            
            self.imageUrlString = nil;
            
            [ETTBackToPageManager sharedManager].isPushing = NO;
            [self setUpStudentFinishedPushStatus];
            [self clearPushFinishedData];
            
            // 恢复白板推送之前白板上显示的内容
            [self.whiteboardManager resumeBeforePushedWhiteboard:self.whiteboardManager.whiteboards.lastObject];
            
            // 恢复到白板推送之前的页面
            // 学生/电子白板页是 1, 教师是 2
            if ([ETTBackToPageManager sharedManager].forwardIndex != 1) {
                [rootVc presentViewControllerToIndex:[ETTBackToPageManager sharedManager].forwardIndex title:nil];
            }
            
            
            
            return;
        }
    }
}

-(void)checkCurrentWhiteboardVc
{
    UIViewController *vc = self.navigationController.topViewController;
    
    if (![vc isKindOfClass:[self class]]) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

// 试卷主观题互批的时候判断当前控制器
-(void)startPaperComment
{
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    self.hasPresentVc = NO;
    
    if (rootVc.index != 1) {
        
        self.currentIndex = rootVc.index;
        
    }else
    {
        UIViewController *vc = self.navigationController.topViewController;
        [self.navigationController popViewControllerAnimated:NO];
        self.topVc = vc;
    }
}

-(void)paperCommentFinished
{
    // 1. 显示试卷主观题答题之前的白板页
    [self.whiteboardManager resumeBeforePushedWhiteboard:self.whiteboardManager.whiteboards.firstObject];
    
    [self setUpStudentFinishedPushStatus];
    
    // 2. 学生回到当前试题页.
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    if (!self.hasPresentVc) {
        
        if (self.topVc) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:self.topVc animated:YES];
                
                self.topVc = nil;
                
            });
            
        }else
        {
            [rootVc presentViewControllerToIndex:self.currentIndex title:nil];
        }
        
        self.hasPresentVc = YES;
    }
    
    self.isPaperComment = NO;
}

-(void)downloadAndShowImageWithState:(NSString *)state
{
    NSURL *url;
    
    switch (state.integerValue) {
        case 21:
            //作答图片
            url = [NSURL URLWithString:self.pushDict[kAnswerImg]];
            
            break;
            
        case 22:
            
            //批阅图片
            url = [NSURL URLWithString:self.pushDict[kCommentImg]];
            
            break;
            
        case 24:
            
            //试卷作答图片
            url = [NSURL URLWithString:self.pushDict[kPaperAnswerImg]];
            
            break;
            
        case 25:
            
            //试卷批阅图片
            url = [NSURL URLWithString:self.pushDict[kPaperCommentImg]];
            
            break;
            
        default:
            break;
    }
    
    // 下载推送的学生作答图片
    [self downloadWhiteboardOrTestPaperImageWithURL:url];
    
}

- (void)downloadWhiteboardOrTestPaperImageWithURL:(NSURL *)url {
    
    /*
     新增
     */
    self.imageUrlString = [NSString stringWithFormat:@"%@",url];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        // 将下载完毕的白板图片展示在白板上
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self checkPushingImage:image];
            });
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *theImage = [UIImage imageNamed:@"image_large_fail"];
                
                [self checkPushingImage:theImage];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DOWNLOAD_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.imageUrlString isEqualToString:[NSString stringWithFormat:@"%@", url]]) {
                    
                    [self downloadWhiteboardOrTestPaperImageWithURL:url];
                }
                
            });
            
        }
    }];
}

// 添加白板答题页
-(void)addStudentWhiteboardAnswerView
{
    // 1.1 创建白板答题页
    [self.whiteboardManager addPushingWhiteboardView];
    
    // 1.2 记录白板答题页
    self.studentAnswerWbView = self.whiteboardManager.whiteboardView;
    
    // 1.3 下载老师推送的白板答题图片并显示在白板答题页中
    [self studentWhiteboardPushing];
}

// 下载白板推送的图片并添加到白板答题页中
-(void)studentWhiteboardPushing
{
    
    [self downloadImageWithURLString:self.pushDict[kwbImg]];
    
}

- (void)downloadImageWithURLString:(NSString *)urlString {
    
    self.imageUrlString = urlString;
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        // 将下载完毕的白板图片展示在白板上
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.originImage = image;
                [self.whiteboardManager.whiteboardView addImage:image from:AXPPushImage];
            });
            
        }else
        {
            NSLog(@"图片下载失败");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *theImage = [UIImage imageNamed:@"image_large_fail"];

                self.originImage  = theImage;
                [self.whiteboardManager.whiteboardView addImage:theImage from:AXPPushImage];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DOWNLOAD_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.imageUrlString isEqualToString:urlString]) {
                    
                    [self downloadImageWithURLString:urlString];
                    
                }
            });
        }
    }];
    
}

-(void)setUpDefaultWhiteboardManagerisRed:(BOOL)isRed
{
    if ([[AXPUserInformation sharedInformation].userType isEqualToString:@"student"]) {
    AXPWhiteboardConfiguration *config = self.whiteboardManager.whiteboardConfig;
    // 画笔
    if (isRed) {
        self.brushColorStr   = config.brushColorStr;
        self.brushColor      = config.brushColor;
        self.brushAlpha      = config.brushAlpha;
        self.brushSize       = config.brushSize;
        
        self.textColor       = config.textColor;
        self.textFontSize    = config.textFontSize;
        
        config.brushColor    = kAXPMAINCOLORc13;
        config.brushSize     = 3;
        config.brushAlpha    = 100;
        config.brushSelected = AXPWhiteboardBrush;
        config.brushColorStr = @"red";
        
        // 文字
        config.textColor     = kAXPMAINCOLORc13;
        config.textFontSize  = 13;
        config.isMutualCorrect = YES;
    }else{
//        config.brushColor    = kAXPCOLORblack;
//        config.brushSize     = 3;
//        config.brushAlpha    = 100;
//        config.brushSelected = AXPWhiteboardBrush;
//        config.brushColorStr = @"black";
//        
//        // 文字
//        config.textColor     = kAXPCOLORblack;
//        config.textFontSize  = 13;
//        config.isMutualCorrect =NO;
        config.brushColor    = _brushColor;
        config.brushSize     = _brushSize;
        config.brushAlpha    = _brushAlpha;
        config.brushSelected = AXPWhiteboardBrush;
        config.brushColorStr = _brushColorStr;
        
        // 文字
        config.textColor     = _textColor;
        config.textFontSize  = _textFontSize;
        config.isMutualCorrect = NO;
        
        [config saveConfiguration];
    }



    
    [self.whiteboardManager checkoutSelectedButton];
    }
}

-(void)addRightRewardManagerView
{
    if (!self.rightRewardView) {
        
        AXPRewardManagerView *rewardView = [[AXPRewardManagerView alloc] initWithButtonType:@[@"查看原题",@"查看批阅"]];
        self.rightRewardView = rewardView;
        [self.view addSubview:rewardView];
        [self.view bringSubviewToFront:rewardView];
    }
}

-(void)studentBeiganGetCommentImage
{
    [self studentGetCommentImage];
}

-(void)studentGetCommentImage
{
    NSString *redisKey = [NSString stringWithFormat:@"%@%@%@",CACHE_CLASSROOM_MATE_TCH,self.userInformation.classroomId,self.pushDict[@"pushId"]];
    
    [AXPRedisManager getRedisMapvalueWithHost:self.userInformation.redisIp redisKey:redisKey field:self.userInformation.jid completionHandle:^(id message) {
        //
        NSDictionary *commentDict = [self getDictWithStr:message];
        
        NSDictionary *markDict = commentDict[kmarkedBean];
        
        NSString *urlStr = markDict[kwbImgUrl];
        
        if ([self.pushDict[kstate] isEqualToString:@"5"]) {
            urlStr = [NSString stringWithFormat:@"http://%@%@%@",[AXPUserInformation sharedInformation].redisIp,@"/ettschoolmitm/mitm2ettschool/localok//",markDict[kwbImgUrl]];
            
            // 记录学生批阅的白板作答地址
            self.wbImgUrl = urlStr;
        } 
        
        if ([self.pushDict[kstate] isEqualToString:@"26"]) {
            
            // 记录学生批阅的白板作答地址
            self.wbImgUrl = urlStr;
        }
        
        // 2. 下载互批图片
        [self downloadWhiteBoardCommentImageWithURLString:urlStr];
        
    }];
}

- (void)downloadWhiteBoardCommentImageWithURLString:(NSString *)urlString {
    
    /*
     新增
     */
    self.imageUrlString = urlString;
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        // 将下载完毕的白板图片展示在白板上
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.whiteboardManager.whiteboardView addImage:image from:AXPPushImage];
                
                self.isSuccessGetImage = YES;
            });
            
        }else
        {
            NSLog(@"图片下载失败");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *theImage = [UIImage imageNamed:@"image_large_fail"];
                
                [self.whiteboardManager.whiteboardView addImage:theImage from:AXPPushImage];
                
                self.isSuccessGetImage = YES;
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_DOWNLOAD_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([self.imageUrlString isEqualToString:urlString]) {
                    
                    [self downloadWhiteBoardCommentImageWithURLString:urlString];
                }
                
            });
        }
    }];
    
}

// 批阅按钮
-(void)readOverAndCommentWhiteboard:(UIButton *)button
{
    if ([self.markScoreButton.currentTitle isEqualToString:@"打分"]) {
        self.score = -1;
        [ETTImagePickerManager creatAlertViewWithMessage:@"还没有打分哦!"];
    }else
    {
        self.isCommentSuccess = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!self.isCommentSuccess) {
                
                [ETTImagePickerManager creatAlertViewWithMessage:@"提交失败,请重试"];
            }
        });
        
        [self readOverAndCommentWhiteboardIsforce:NO];
        
        [self setUpDefaultWhiteboardManagerisRed:NO];
    }
}

// 强制提交批阅数据
-(void)readOverAndCommentWhiteboardIsforce:(BOOL)isforce
{
    // 已经批阅成功
    if (self.isCommentSuccess) {
        return;
    }
    
    if ([self.markScoreButton.currentTitle isEqualToString:@"打分"]) {
        self.score = -1;
    }
    
    CGPoint selectedPoint;
    
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView) {
        
        selectedPoint = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView.center;
        
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:CGPointZero];
    }
    
    // 批阅图片
    if (![AXPWhiteboardToolbarManager sharedManager].whiteboardView.isAddText) {
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView changeTextViewLayer];
    }
    UIImage *whiteboardImage = [UIView snapshot:[AXPWhiteboardToolbarManager sharedManager].whiteboardView];
    
    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:selectedPoint];
    
    self.commentImage = whiteboardImage;
    NSData *data      = UIImagePNGRepresentation(whiteboardImage);

    NSString *urlStr  = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
    NSDictionary *params = [NSDictionary dictionary];
    if (!self.wbImgUrl.lastPathComponent) {
        params = @{@"commentName":[NSNull null]};
    } else {
        params = @{@"commentName":self.wbImgUrl.lastPathComponent};
        [[ETTNetworkManager sharedInstance] POST:urlStr Parameters:params fileData:data mimeType:@"image/jpg" uploadImageRule:kStudentCommentImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
            
            if (!error && responseDictionary) {
                
                // 2. 更改 redis 数据
                NSString *field = [NSString stringWithFormat:@"%@",self.userInformation.jid];
                
                NSArray *imageUrls = responseDictionary[@"attachUrl"];
                NSString *wbImgUrl = [NSString stringWithFormat:@"http://%@%@",self.userInformation.redisIp,imageUrls.firstObject];
                
                NSString *score = [NSString stringWithFormat:@"%zd",self.score];
                
                NSDictionary *dict;
                
                NSString *type;
                
                if (self.isPaperComment) { // 试卷主观题批阅
                    
                    type = student_pt_commnet;
                    dict = @{kpoint:score,kPaperCommentImg:wbImgUrl};
                    
                }else // 白板批阅
                {
                    type = student_wb_commnet;
                    dict = @{kpoint:score,kcommentImageUrl:wbImgUrl};
                }
                
                NSDictionary *userInfo = @{field:dict};
                
                [AXPRedisSendMsg sendMessageWithUserInfo:userInfo type:type successHandle:^{
                    //
                    [self.markScoreButton setTitle:@"打分" forState:UIControlStateNormal];
                    
                    if (!isforce) {
                        [ETTImagePickerManager creatAlertViewWithMessage:@"批阅成功"];
                    }
                    
                    self.isCommentSuccess = YES;
                    
                    // 试卷主观题批阅
                    if (self.isPaperComment) {
                        
                        [self paperCommentFinished];
                        
                    }else // 白板批阅
                    {
                        [self setUpStudentCommentSuccessStatus];
                        
                        // 恢复到答题页面
                        if (self.studentAnswerWbView) {
                            [self.whiteboardManager resumeBeforePushedWhiteboard:self.studentAnswerWbView];
                        }else
                        {
                            [self.whiteboardManager resumeBeforePushedWhiteboard:self.whiteboardManager.whiteboards.lastObject];
                        }
                    }
                    
                } failHandle:^{
                    //
                }];
                if(!self.isPaperComment)
                {
                    NSString * pid = [self.pushDict valueForKey:@"whiteboardId"];
                    if (pid == nil)
                    {
                        return ;
                    }
                 NSDictionary * cachedic = @{@"whiteboardId":pid,field:dict};
                 [AXPRedisSendMsg sendMessageCacheUserInfo:cachedic type:student_wb_commnet  successHandle:nil failHandle:nil];
                }
            }else
            {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
    
    
}

-(void)originStudentReadOverAndCommentWBorPTWithRedisKey:(NSString *)redisKey field:(NSString *)field commentDict:(NSDictionary *)dict score:(NSString *)score wbImgUrl:(NSString *)wbImgUrl isforce:(BOOL)isforce
{
    if (self.isPaperComment) {
        
        redisKey = [NSString stringWithFormat:@"%@%@%@"
                    ,CACHE_PT_MARK_STU,self.userInformation.classroomId,self.pushDict[@"pushId"]];
        
        dict = @{kpoint:score,kPaperCommentImg:wbImgUrl};
        
    }else
    {
        redisKey = [NSString stringWithFormat:@"%@%@%@"
                    ,CACHE_WB_MARK_STU,self.userInformation.classroomId,self.pushDict[@"pushId"]];
        
        dict = @{kpoint:score,kcommentImageUrl:wbImgUrl};
    }
    
    [AXPRedisManager setRedisMapvalueWithHost:self.userInformation.redisIp redisKey:redisKey field:field value:[self getJsonStrWithDict:dict] completionHandle:^(id message) {
        //
        if (!isforce) {
            [ETTImagePickerManager creatAlertViewWithMessage:@"批阅成功"];
        }
        
        self.isCommentSuccess = YES;
        
        // 试卷主观题批阅
        if (self.isPaperComment) {
            
            [self paperCommentFinished];
            
        }else // 白板批阅
        {
            [self setUpStudentCommentSuccessStatus];
            
            // 恢复到答题页面
            if (self.studentAnswerWbView) {
                [self.whiteboardManager resumeBeforePushedWhiteboard:self.studentAnswerWbView];
            }else
            {
                [self.whiteboardManager resumeBeforePushedWhiteboard:self.whiteboardManager.whiteboards.lastObject];
            }
        }
    }];
}

// 提交按钮的点击作答
-(void)submitAnswerQuestion:(UIButton *)button
{
    
    
    if (self.isSubmitPaperImage) {
        [self submitWhiteboardImageToPaper];
        return;
    }
    
    if ([button.currentTitle isEqualToString:@"提交中"]) {
        
        NSLog(@"正在提交,请稍后...");
        return;
        
    }
    
    if ([button.currentTitle isEqualToString:@"提交"])
    {
        self.isSubmitSuccess = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.isSubmitSuccess == NO) {
                
                // 提示提交成功
                [ETTImagePickerManager creatAlertViewWithMessage:@"提交失败,请重试"];
                
                [button setTitle:@"提交" forState:UIControlStateNormal];
                self.submitButton.frame = CGRectMake(30, 0, 40, 44);
                
            }
        });
        
        [button setTitle:@"提交中" forState:UIControlStateNormal];
        self.submitButton.frame = CGRectMake(10, 0, 60, 44);
        
        // 提交作答图片
        [self submitAnswerImageIsforce:NO];
    }
}

// 强制提交作答数据
-(void)submitAnswerImageIsforce:(BOOL)isforce
{
    // 已经批阅成功
    if (self.isSubmitSuccess) {
        return;
    }
    
    CGPoint selectedPoint;
    
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView) {
        
        selectedPoint = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView.center;
        
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:CGPointZero];
    }
    
    // 0.获得当前白板作答图片.
    //老师把作答题目推给学生,学生展示在白板上,老师点击结束作答,截取白板.由于白板处于后台,视图无法渲染了.
    if (![AXPWhiteboardToolbarManager sharedManager].whiteboardView.isAddText) {
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView changeTextViewLayer];
    }
    UIImage *whiteboardImage = [UIView snapshot:[AXPWhiteboardToolbarManager sharedManager].whiteboardView];

    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:selectedPoint];

    NSData *data             = UIImagePNGRepresentation(whiteboardImage);

    NSString *urlStr = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
    
    // 1. 上传作答图片
    [[ETTNetworkManager sharedInstance] POST:urlStr Parameters:nil fileData:data mimeType:@"image/jpg" uploadImageRule:kStudentAnswerImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        if (!error && responseDictionary) {
            
            NSArray *imageUrls = responseDictionary[@"attachUrl"];
            NSString *theI = [NSString stringWithFormat:@"http://%@%@",self.userInformation.redisIp,imageUrls.firstObject];
            
            NSString *wbImgUrl = theI.lastPathComponent;
            
            [ETTCoursewarePresentViewControllerManager sharedManager].cacheHost = [NSString stringWithFormat:@"http://%@%@//",self.userInformation.redisIp,theI.stringByDeletingLastPathComponent];
            
            
            ETTLog(@"%@",wbImgUrl);
            
            self.answerImageUrl = theI;
            
            // 2. 更改 redis 数据
            NSDictionary *dict = @{kuserId:isEmptyString(self.userInformation.jid)?@"":self.userInformation.jid ,kuserName:isEmptyString(self.userInformation.userName)?@"":self.userInformation.userName,kuserPhoto:isEmptyString(self.userInformation.userPhoto)?@"":self.userInformation.userPhoto,kuserWbImg:isEmptyString(wbImgUrl)?@"":wbImgUrl,kmarkJid:[NSNull null],kmarkName:[NSNull null],kmarkPoint:@"-1",@"whiteboardId":isEmptyString(self.studentGetTeacherPushWhiteboardId)?@"":self.studentGetTeacherPushWhiteboardId};
           
            // 学生作答数据
            [AXPRedisSendMsg sendMessageWithUserInfo:dict type:student_wb_answer successHandle:^{
                //
                if (!isforce) {
                    
                    [self.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
                    self.submitButton.frame = CGRectMake(10, 0, 60, 44);
                    self.submitButton.enabled = NO;
                    
                    // 提示提交成功
                    [ETTImagePickerManager creatAlertViewWithMessage:@"提交成功"];
                }
                
                self.isSubmitSuccess = YES;
                
            } failHandle:^{
                //
            }];
            
            [AXPRedisSendMsg sendMessageCacheUserInfo:dict type:student_wb_answer  successHandle:nil failHandle:nil];
            
        }else
        {
            NSLog(@"error:%@",error);
        }
    }];
}

-(void)originStudentSubmitWithRedisKey:(NSString *)redisKey field:(NSString *)field valueDict:(NSDictionary *)dict isforce:(BOOL)isforce
{
    [AXPRedisManager setRedisMapvalueWithHost:self.userInformation.redisIp redisKey:redisKey field:field value:[self getJsonStrWithDict:dict] completionHandle:^(id message) {
        
        if (!isforce) {
            
            [self.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
            self.submitButton.frame = CGRectMake(10, 0, 60, 44);
            self.submitButton.enabled = NO;
            
            // 提示提交成功
            [ETTImagePickerManager creatAlertViewWithMessage:@"提交成功"];
        }
        self.isSubmitSuccess = YES;
        
    }];
}

-(void)addMarkScoreButton
{
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    self.markScoreButton.hidden = YES;
    
    [rootVc.view addSubview:self.markScoreButton];
    
}



-(void)addMarkSocreView
{
    // 模拟学生
    AXPMarkScoreView *markScoreView = [[AXPMarkScoreView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    
    NSLog(@"self.markScoreView:%@",markScoreView);
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [rootVc.view addSubview:markScoreView];
    
    [markScoreView markScoreCompletionHandle:^(NSInteger markScore) {
        
        self.score = markScore;
        [self.markScoreButton setTitle:[NSString stringWithFormat:@"%zd分",markScore] forState:UIControlStateNormal];
    }];
    
    if (![self.markScoreButton.currentTitle isEqualToString:@"打分"]) {
        [markScoreView selectedScore:self.score];
    }
}

-(void)setUpStudentCommentSuccessStatus
{
    self.eleWhiteboardLabel.hidden = YES;
    self.menuButton.hidden         = YES;
    self.submitButton.hidden       = NO;
    self.commentButton.hidden      = YES;
    self.markScoreButton.hidden    = YES;
}

-(void)setUpStudentMutualCorrectStatus
{
    self.eleWhiteboardLabel.hidden = YES;
    self.menuButton.hidden         = YES;
    self.submitButton.hidden       = YES;
    self.commentButton.hidden      = NO;
    self.markScoreButton.hidden    = NO;
}

-(void)setUpStudentAnswerStatus
{   
    
    self.eleWhiteboardLabel.hidden = YES;
    self.menuButton.hidden         = YES;
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.frame        = CGRectMake(30, 0, 40, 44);
    self.submitButton.enabled      = YES;
    self.submitButton.hidden       = NO;
    self.commentButton.hidden      = YES;
    self.markScoreButton.hidden    = YES;
}

-(void)setUpStudentFinishedPushStatus
{
    self.eleWhiteboardLabel.hidden = NO;
    self.menuButton.hidden         = NO;
    self.submitButton.hidden       = YES;
    self.commentButton.hidden      = YES;
    self.markScoreButton.hidden    = YES;
}

-(void)clearPushFinishedData
{
    // 学生移除右侧功能按钮
    [self.rightRewardView removeFromSuperview];
    self.rightRewardView     = nil;

    [self.pushDict removeAllObjects];
    self.studentAnswerWbView = nil;
    self.studentConmmentWbView = nil;
}

-(void)setUpStudentPushingBarStatus
{
    self.eleWhiteboardLabel.hidden = YES;
    self.menuButton.hidden         = YES;
    self.submitButton.hidden       = YES;
    self.markScoreButton.hidden    = YES;
    self.commentButton.hidden      = YES;

    self.isSubmitSuccess           = NO;
    
    // 隐藏白板页码
    self.whiteboardManager.addMoreWhiteboardPageView.hidden = YES;
}

-(void)setUpStudentAnswerOverStatus
{
    [self.submitButton setTitle:@"已结束" forState:UIControlStateNormal];
    self.submitButton.frame = CGRectMake(10, 0, 60, 44);
    self.submitButton.enabled = NO;
}

#pragma mark -- Teacher

//白板推送按钮的点击
// 推送白板内容
-(void)pushWhiteboardContentView
{
    _MVHasPushAction = YES;
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.13  18:36
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061／AIXUEPAIOS-930_Epic0313_1061
     describe : 白板作答，结束作答后“已提交”，变为人数的2倍
     Operation：开始推送时清除上次学生作答数据
     */
    if (self.studentAnswerList)
    {
         [self.studentAnswerList removeAllObjects];
    }
    
    /////////////////////////////////////////////////////
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    [self.EVGuardModel  setNeedNotice:false];
    [[ETTScenePorter shareScenePorter] enterRegistration:self.EVGuardModel];
    [ETTBackToPageManager sharedManager].isPushing = YES;
    
    self.isMarkScore = NO;
    
    UIColor *color = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor;
    
    [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor = kAXPMAINCOLORc17;
    
    CGPoint selectedPoint;
    
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView) {
        
        selectedPoint = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView.center;
        
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:CGPointZero];
    }
    
    // 当前白板页图片
    UIImage *whiteboardImage = [UIView snapshot:[AXPWhiteboardToolbarManager sharedManager].whiteboardView];
    self.originImage = whiteboardImage;
    
    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:selectedPoint];
    
    [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor = color;
    
    // 改变导航栏显示按钮
    [self setUpFinishedPushAndAnswerQuestionButton];
    
    // 隐藏悬浮按钮和页码按钮
    [[AXPWhiteboardToolbarManager sharedManager].suspendNimbleView hiddenNimbleToolbarCompletion:^{
        
        [AXPWhiteboardToolbarManager sharedManager].suspendNimbleView.suspendNimbleButton.hidden = YES;
    }];
    
    [AXPWhiteboardToolbarManager sharedManager].addMoreWhiteboardPageView.hidden = YES;
    
    NSData *data = UIImagePNGRepresentation(whiteboardImage);
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
    
    [[ETTNetworkManager sharedInstance] POST:urlStr Parameters:nil fileData:data mimeType:@"image/jpg" uploadImageRule:kTeacherSourceImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        NSLog(@"---------%@",responseDictionary);
        
        if (!error && responseDictionary) {
            
            NSArray *imageUrls = responseDictionary[@"attachUrl"];
            
            NSString *wbImgUrl = [NSString stringWithFormat:@"http://%@%@",self.userInformation.redisIp,imageUrls.firstObject];
            
            NSString *timeStr = self.pushId;
            
            //更改内容 每次推送添加一个唯一值
            self.teacherPushWhithboardId = [NSString stringWithFormat:@"whiteboardId_%@",[ETTRedisBasisManager getTime]];
            
            self.classroomDict = @{@"state":@"4",@"wbImg":wbImgUrl,@"pushId":timeStr,@"whiteboardId":self.teacherPushWhithboardId}.mutableCopy;
            
            //将白板内容推送给学生
            [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState successHandle:nil failHandle:nil];
            
        }else
        {
            NSLog(@"error:%@",error);
        }
    }];
}

-(void)originSendRedisMsg:(NSString *)msg
{
    [AXPRedisManager setRedisvalueWithHost:self.userInformation.redisIp key:[NSString stringWithFormat:@"%@%@",CACHE_CLASSROOM_STATE,self.userInformation.classroomId] value:msg completionHandle:^(id message) {
        //
        if ([message isKindOfClass:[NSString class]]&&[message isEqualToString:@"OK"]) {
            
            NSLog(@"推送成功!");
        }
    }];
}

// 结束推送
-(void)pushFinished
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.10  14:23
     modifier : 康晓光
     version  ：Epic-0310-AIXUEPAIOS-1059
     branch   ：Epic-0310-AIXUEPAIOS-1059/AIXUEPAIOS-982_Epic0310_1059
     describe : 原AIXUEPAIOS-982 问题修复move 此分支内解决 
                问题标题：锁屏状态下，结束推送后，教师返端锁屏按钮的状态还是锁定状态
                解决方法： 增加消息通知 学生管理 模块收到消息 结束锁屏状态
     
     */
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    /////////////////////////////////////////////////////
    
    [[ETTScenePorter shareScenePorter] cancellationRegistration:self.EVGuardModel];
    [[ETTBackToPageManager sharedManager] endPushing];
    
    // 显示悬浮按钮和页码按钮
    [AXPWhiteboardToolbarManager sharedManager].suspendNimbleView.suspendNimbleButton.hidden = NO;
    [AXPWhiteboardToolbarManager sharedManager].addMoreWhiteboardPageView.hidden = NO;
    
    // 隐藏答题人数Label
    self.titleLabel.hidden = YES;
    _MVHasPushAction = false;
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  18:46
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
     describe : 初始化值
     */
    _MVIsBeginAnser  = false;
    /////////////////////////////////////////////////////
    

    [self.answerListView removeFromSuperview];
    [self setUpWhiteboardNavagationBarWithIdentity:ETTSideNavigationViewIdentityTeacher];
    
    [self.classroomDict setObject:@"0" forKey:@"state"];
    [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState  successHandle:^{
        ETTGovRestoreWorkTask * task = [[ETTGovRestoreWorkTask alloc]initTask:ETTDELRESTOREACACHIVE];
        [ETTAnouncement reportGovernmentTask:task withType:0 withEntity:self];
    } failHandle:nil];
//    [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState successHandle:nil failHandle:nil];
    

    [self setUpDefaultWhiteboardManagerisRed:NO];
    
    // 白板归档成功之后才能删除这些数据.
    [self whiteboardEncodeSuccess:^{
        
        [self.studentAnswerList removeAllObjects];
        [self.studentScoreList removeAllObjects];
    }];
    
}

-(void)whiteboardEncodeSuccess:(void(^)())successHandle
{
    NSMutableArray *answerList = [NSMutableArray array];
    
    // 有批阅打分
    if (self.studentScoreList.count > 0) {
        
        [self.studentScoreList enumerateObjectsUsingBlock:^(NSDictionary * scoreDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *userWbImg = scoreDict[kuserWbImg];
            NSString *wbUrl     = userWbImg.lastPathComponent;
            
            NSDictionary *answerDict = @{@"jid":scoreDict[kuserId],
                                         @"wbUrl":wbUrl,
                                         kmarkJid:scoreDict[kmarkJid],
                                         kmarkPoint:scoreDict[kmarkPoint]};
            [answerList addObject:answerDict];
        }];
        
    }else // 没有批阅打分
    {
        [self.studentAnswerList enumerateObjectsUsingBlock:^(NSDictionary * answerDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *userWbImg = answerDict[kuserWbImg];
            NSString *wbUrl     = userWbImg.lastPathComponent;
            
            NSDictionary *dict = @{@"jid":answerDict[kuserId],
                                   @"wbUrl":wbUrl};
            
            [answerList addObject:dict];
            
        }];
    }
    
    NSString *wbUrl     = self.classroomDict[@"wbImg"];
    NSString *baseWbUrl = wbUrl.lastPathComponent;;
    
    NSDictionary *wbDict = @{@"jid":self.userInformation.jid,
                             @"classroomId":self.userInformation.classroomId,
                             @"pushId":self.classroomDict[@"pushId"],
                             @"baseWbUrl":baseWbUrl,
                             @"answerList":answerList};
    
    if ([NSJSONSerialization isValidJSONObject:wbDict]) {
        
        NSData *wbData = [NSJSONSerialization dataWithJSONObject:wbDict options:0 error:NULL];
        
        
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
        
        // 上传文件
        [[ETTNetworkManager sharedInstance] POST:urlStr Parameters:nil fileData:wbData mimeType:@"text/json" uploadImageRule:kTeacherWBEncode responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
            //
            if (!error && responseDictionary) {
                
                if (successHandle) {
                    successHandle();
                }
            }
        }];
    }
}


// 开始答题
-(void)beiganAnswerQuestion
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.14  18:50
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
     describe : 设置开始答题 防止有上次学生答题数据缓存，清理一次数据
     */
    _MVIsBeginAnser  = YES;
    if (self.studentAnswerList)
    {
        [self.studentAnswerList removeAllObjects];
    }
    /////////////////////////////////////////////////////


    [self setUpCheckSubjectAndFinishedAnswerButton];
    
    self.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  %lu",(unsigned long)self.studentAnswerList.count];
    self.titleLabel.hidden = NO;
    self.eleWhiteboardLabel.hidden = YES;
    [self addStudentAnswerListViewWithItemSize:CGSizeMake(220, 235)];
    
    [self.classroomDict setObject:@"2" forKey:kstate];
    
    ETTLog(@"%@",self.classroomDict);
    
    [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState successHandle:nil failHandle:nil];
    
}


-(void)changeStatuesWhenGetStudentAnswers
{
    self.answerListView.placeholderView.hidden = YES;
    [self.answerListView.answerListCollectionView reloadData];
    
    NSInteger count;
    
    NSIndexPath *indexPath;
    
    if (self.isMarkScore) {
        count = self.studentScoreList.count;
        indexPath = [NSIndexPath indexPathForItem:self.studentScoreList.count -1 inSection:0];
    }else
    {
        count = self.studentAnswerList.count;
        indexPath = [NSIndexPath indexPathForItem:self.studentAnswerList.count -1 inSection:0];
    }
    
    self.answerListView.answerListCollectionView.hidden = NO;
    /*
     new      : Modify
     time     : 2017.3.15  11:56
     modifier : 康晓光
     version  ：Epic-0313-AIXUEPAIOS-1061
     branch   ：Epic-0313-AIXUEPAIOS-1061/AIXUEPAIOS-930_Epic0313_1061
     describe : 判断如果没有开始推送并且开始答题 则不接受数据
     if (_MVHasPushAction)
     */
    if (_MVIsBeginAnser &&_MVHasPushAction )
    {
        self.titleLabel.text = [NSString stringWithFormat:@"已提交 :  %ld",(long)count];
        self.titleLabel.hidden = NO;
    }
    else
    {
        self.titleLabel.text = @"";
        self.titleLabel.hidden = YES;
    }
    
}

-(void)checkPushingImage:(UIImage *)image
{
    AXPCheckOriginalSubjectView *originView = [AXPCheckOriginalSubjectView showPushingImage:image currentPushState:^NSString *{
        return self.pushDict[kstate];
    }];
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [rootVc.view addSubview:originView];
}

-(void)closePushingImage
{
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    [rootVc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[AXPCheckOriginalSubjectView class]]) {
            
            [obj removeFromSuperview];
            
            *stop = YES;
        }
    }];
}

// 学生 :查看批阅
-(void)checkCommentImage
{
    // 1. 下载批阅图片
    // 批阅地址
    NSArray *array = [self.answerImageUrl componentsSeparatedByString:@""];
    
    NSString *answerImgUrl = array.firstObject;
    //http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//50043_20170106_3162002_1483673996921.png
    
    NSString *imageUrl = answerImgUrl.lastPathComponent;//50043_20170106_3162002_1483673996921.png

    NSArray *arrays    = [imageUrl componentsSeparatedByString:@"."];

    NSString *imageU   = [arrays firstObject];

    imageUrl           = [NSString stringWithFormat:@"%@_p.jpg",imageU];//50043_20170106_3162002_1483673996921_p.png

    answerImgUrl       = [answerImgUrl stringByDeletingLastPathComponent];//http://10.20.30.254/ettschoolmitm/mitm2ettschool/localok//

    answerImgUrl       = [NSString stringWithFormat:@"%@//%@",answerImgUrl,imageUrl];
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:answerImgUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (image) {
                [self showBigImage:image canClosed:YES];
            } else {
                //如果图片没有下载下来
                [self showBigImage:[UIImage imageNamed:@""] canClosed:YES];
            }
        });
    }];
}

// 老师 :查看学生作答
-(void)checkStudentRespondImage
{   
    NSURL *url;
    
    if (self.currentRespondImageUrlStr.length <= 60) {
        //白板查看作答
        NSString *studentAnswer = [NSString stringWithFormat:@"http://%@%@%@",[AXPUserInformation sharedInformation].redisIp,@"/ettschoolmitm/mitm2ettschool/localok//",self.currentRespondImageUrlStr];
        url = [NSURL URLWithString:studentAnswer];
        
    } else {
        //主观题互批查看作答
        url = [NSURL URLWithString:self.currentRespondImageUrlStr];
    }
    
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showBigImage:image canClosed:YES];
            });
        }
    }];
}

// 老师/学生 :查看原题
-(void)checkOriginalSubject
{
    [self showBigImage:self.originImage canClosed:YES];
}

-(void)showBigImage:(UIImage *)image canClosed:(BOOL)canClosed
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.17  14:05
                2017.3.20  14:45
     modifier : 康晓光
     version  ：Epic_0314_AIXUEPAIOS-1068
     branch   ：AIXUEPAIOS-1008
     describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
               2017.3.17 增加对视图是否加载的判断，防止重复加载
               2017.3.20 去除上次修改 ，判断是否已经加载，后加载的视图干掉上次的加载视图
     
     */
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    AXPCheckOriginalSubjectView *  oldOriginView = [rootVc.view viewWithTag:2018];
    if (oldOriginView && [oldOriginView isKindOfClass:[AXPCheckOriginalSubjectView class]])
    {
        [oldOriginView removeFromSuperview];
    }
    AXPCheckOriginalSubjectView *originView = [AXPCheckOriginalSubjectView showOriginSubjectImage:image canClosed:canClosed];
        originView.tag  = 2018;
    [rootVc.view addSubview:originView];

   /////////////////////////////////////////////////////

}

// 结束作答/学生互批/互批结束 按钮的点击
-(void)finishedAnswerQuestion:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"结束作答"]) {
        
        button.enabled = NO;
        
        [self.classroomDict setObject:@"3" forKey:@"state"];
        
        [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState successHandle:nil failHandle:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (self.studentAnswerList.count <= 1) {
                
                [button setTitle:@"已结束" forState:UIControlStateNormal];
                
            }else
            {
                button.enabled = YES;
                [button setTitle:@"学生互批" forState:UIControlStateNormal];
            }
        });
        
        [self setUpStudentMutualCorrectBar];
        
    }else if ([button.currentTitle isEqualToString:@"学生互批"])
    {
        
        self.finishedPushButton.hidden = YES;
        
        [button setTitle:@"互批结束" forState:UIControlStateNormal];
        button.enabled = NO;
        
        self.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  0"];
        self.titleLabel.hidden = NO;
        // 1. 修改课堂状态为互批状态: state:5 && markTag:唯一值
        NSString *markTag      = self.pushId;
        
        [self.classroomDict setObject:@"5" forKey:kstate];
        [self.classroomDict setObject:markTag forKey:kmarkTag];
        
        // 2. 显示正在分发作答卡片的占位图片
        self.answerListView.placeholderView.hidden = NO;
        self.answerListView.answerListCollectionView.hidden = YES;
        
        // 3. 分发互批数据. 1->2, 2->3, 3->4, ... 4->1;
        
        NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
        
        [self.studentAnswerList enumerateObjectsUsingBlock:^(NSMutableDictionary *currentDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *forwardDict,*nextDict;
            
            if (idx == 0) {
                
                forwardDict = self.studentAnswerList.lastObject;
            }else
            {
                forwardDict = self.studentAnswerList[idx-1];
            }
            
            if (idx == self.studentAnswerList.count - 1) {
                
                nextDict = self.studentAnswerList.firstObject;
                
            }else
            {
                nextDict = self.studentAnswerList[idx + 1];
            }
            
            // 1. 更改白板作答数据表.
            [currentDict setObject:nextDict[kuserId] forKey:kmarkJid];
            [currentDict setObject:nextDict[kuserName] forKey:kmarkName];
            
            // 2.
            NSString *field            = currentDict[kuserId];

            NSDictionary *markedDict   = @{kmarkedJid:forwardDict[kuserId],kmarkedPoint:@"-1",kwbImgUrl:forwardDict[kuserWbImg],kmarkTag:self.classroomDict[kmarkTag]};

            NSDictionary *mutuallyDict = @{kuserId:currentDict[kuserId],kuserName:currentDict[kuserName],kuserPhoto:currentDict[kuserPhoto],kmarkedBean:markedDict};

            NSString *jsonStr          = [self getJsonStrWithDict:mutuallyDict];
            
            [commentDict setObject:jsonStr forKey:field];
        }];
        
        NSString *redisKey = [NSString stringWithFormat:@"%@%@%@",CACHE_CLASSROOM_MATE_TCH,self.userInformation.classroomId,self.classroomDict[@"pushId"]];
        
        NSLog(@"发送开始互批");
        [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict redisValueDict:commentDict type:classroomState redisKey:redisKey successHandle:nil failHandle:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            button.enabled = YES;
            
        });
        
        // 4. 监听学生打分数据
        [self beiganGetStudentMarkScoreData];
        
        
    }else if ([button.currentTitle isEqualToString:@"互批结束"])
    {
        button.enabled = NO;
        [button setTitle:@"已结束" forState:UIControlStateNormal];
        
        self.finishedPushButton.hidden = NO;
        
        [self.classroomDict setObject:@"20" forKey:@"state"];
        
        // 发送互批结束的状态
        [AXPRedisSendMsg sendMessageWithUserInfo:self.classroomDict type:classroomState successHandle:nil failHandle:nil];
    }
}

-(void)beiganGetStudentMarkScoreData
{
    self.isMarkScore = YES;
    // 创建打分UI
    [self addStudentAnswerListViewWithItemSize:CGSizeMake(220, 248)];
}


-(void)addStudentAnswerListViewWithItemSize:(CGSize)itemSize
{
    [self.answerListView removeFromSuperview];
    
    ETTStudentAnswerListView *answerListView = [[ETTStudentAnswerListView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT - 64)];
    self.answerListView = answerListView;
    [self.view addSubview:answerListView];
    
    if (self.isMarkScore) {
        
        if (self.studentScoreList.count == 0) {
            answerListView.placeholderView.hidden = NO;
            answerListView.explainLabel.text = @"暂时无人互批";
        }
        
    }else
    {
        if (self.studentAnswerList.count == 0) {
            // 显示占位图片
            answerListView.placeholderView.hidden = NO;
            answerListView.explainLabel.text = @"暂无学生答题";
        }
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(38, 30, 30, 28);
    layout.minimumLineSpacing = 30;
    
    layout.itemSize = itemSize;
    
    // 显示学生作答界面
    AXPStudentAnswerListCollectionView *answerListCollectionView = [[AXPStudentAnswerListCollectionView alloc] initWithFrame:answerListView.frame collectionViewLayout:layout];
    
    [answerListCollectionView registerClass:[AXPStudentAnswerListCollectionViewCell class] forCellWithReuseIdentifier:@"axpStudentAnswerListCollectionViewCell"];
    
    answerListCollectionView.delegate = self;
    answerListCollectionView.dataSource = self;
    
    answerListCollectionView.hidden = YES;
    answerListView.answerListCollectionView = answerListCollectionView;
    [answerListView addSubview:answerListCollectionView];
    
   
}

#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXPStudentSubjectViewController *vc = [[AXPStudentSubjectViewController alloc] init];
    
    vc.classroomDict = self.classroomDict;
    
    NSDictionary *dict;
    
    if (self.isMarkScore) {
        
        dict = self.studentScoreList[indexPath.item];
        
        NSString *urlStr = dict[kcommentImageUrl];
        
        [vc.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //
            CGSize size = [ETTImageManager getImageSizeWithImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                vc.imageView.frame = CGRectMake(0, 0, size.width, size.height);
                
                vc.imageView.center = vc.view.center;
                
            });
            
        }];
        vc.imageUrlStr = urlStr;
        vc.answerJid = [NSString stringWithFormat:@"%@",dict[kuserId]];
        
        self.currentRespondImageUrlStr = dict[kuserWbImg];
        
    }else
    {
        dict = self.studentAnswerList[indexPath.item];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://%@%@%@",[AXPUserInformation sharedInformation].redisIp,@"/ettschoolmitm/mitm2ettschool/localok//",dict[kuserWbImg]];
        
        [vc.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //
            CGSize size = [ETTImageManager getImageSizeWithImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                vc.imageView.frame = CGRectMake(0, 0, size.width, size.height);
                
                vc.imageView.center = vc.view.center;
                
            });
        }];
        vc.imageUrlStr = urlStr;
        vc.answerJid = [NSString stringWithFormat:@"%@",dict[kuserId]];
        
    }
    
    vc.title = dict[@"userName"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isMarkScore) {
        
        return self.studentScoreList.count;
        
    }else
    {
        return self.studentAnswerList.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AXPStudentAnswerListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axpStudentAnswerListCollectionViewCell" forIndexPath:indexPath];
    
    if (self.isMarkScore) {
        
        [cell setUpAttributesWithDict:self.studentScoreList[indexPath.item] isMarkScore:self.isMarkScore];
    }else
    {
        [cell setUpAttributesWithDict:self.studentAnswerList[indexPath.item] isMarkScore:self.isMarkScore];
    }
    
    return cell;
}

#pragma mark -- publick
-(void)addWhiteboardImageToPaperWithPaperImageHandle:(studentRespondImage)paperImageHandle;
{
    self.paperImageHandle = paperImageHandle;
    
    // 1. 显示导航栏提交按钮
    self.submitButton.hidden  = NO;
    self.submitButton.enabled = YES;
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTitle:@"提交" forState:UIControlStateHighlighted];
    self.submitButton.frame   = CGRectMake(30, 0, 40, 44);
    self.isSubmitPaperImage   = YES;
  
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.3.22  16:25
     modifier : 康晓光
     version  ：Epic_0322_AIXUEPAIOS-1124
     branch   ：Epic_0322_AIXUEPAIOS-1124/AIXUEPAIOS-1117
     describe : 白板作答主观题后，原白板的内容被清空了
     operation: 白板作答加入一个新的白板视图
     
     */
    // 1.1 创建白板答题页
    [self.whiteboardManager addPushingWhiteboardView];
    // 1.2 记录白板答题页
    self.studentAnswerWbView = self.whiteboardManager.whiteboardView;
    /////////////////////////////////////////////////////
    
    
    
}

-(void)submitWhiteboardImageToPaper
{
    // 截取当前白板屏幕
    
    CGPoint selectedPoint;
    
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView) {
        
        selectedPoint = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView.center;
        
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:CGPointZero];
    }
    
    // 当前白板页图片
    if (![AXPWhiteboardToolbarManager sharedManager].whiteboardView.isAddText) {
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView changeTextViewLayer];
    }
    UIImage *whiteboardImage = [UIView snapshot:[AXPWhiteboardToolbarManager sharedManager].whiteboardView];
    
    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:selectedPoint];
    
    if (self.paperImageHandle) {
        self.paperImageHandle(whiteboardImage);
    }
    
    self.submitButton.hidden = YES;
    self.isSubmitPaperImage = NO;
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.22  16:20
     modifier : 康晓光
     version  ：Epic_0322_AIXUEPAIOS-1124
     branch   ：Epic_0322_AIXUEPAIOS-1124/AIXUEPAIOS-1117
     describe : 白板作答主观题后，原白板的内容被清空了
     operation: 1.取消原来的清理白板调用，这样不会是出现空白的白板
                2.恢复白板作答前的白板
     */
    //[self.whiteboardManager.whiteboardView clearWhiteboard];
    [self.whiteboardManager resumeBeforePushedWhiteboard:self.whiteboardManager.whiteboards.lastObject];
    self.studentAnswerWbView = nil;
    /////////////////////////////////////////////////////
    
    
    // 跳转到之前的控制器
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    if (self.topVc) {
        
        [self.navigationController pushViewController:self.topVc animated:YES];
        
        self.topVc = nil;
        
    }else
    {
        [rootVc presentViewControllerToIndex:self.currentIndex title:nil];
    }
}

-(id)getDictWithStr:(NSString *)jsonStr
{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    return dict;
}

-(NSString *)getJsonStrWithDict:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        
        NSData *data      = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];

        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        return jsonStr;
    }else
    {
        return nil;
    }
}

-(void)dealloc
{
    
    NSLog(@"%@ ------------------------白板控制器被销毁!",[NSThread currentThread]);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpStudentMutualCorrectBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    self.menuButton.frame = CGRectMake(-10, 2, 42, 41);
    self.finishedPushButton.frame = CGRectMake(42+5-10, 0, 80, 44);
    
    [leftView addSubview:self.menuButton];
    [leftView addSubview:self.finishedPushButton];
    
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}


-(void)setUpWhiteboardNavagationBarWithIdentity:(ETTSideNavigationViewIdentity)identity
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    self.menuButton.frame = CGRectMake(-10, 2, 42, 41);
    
    UILabel *label          = [self creatNavigationBarLabel];
    label.frame             = CGRectMake(42+5-10, 7, 75, 30);
    label.text              = self.navigationItem.title;
    self.eleWhiteboardLabel = label;
    
    [leftView addSubview:self.menuButton];
    [leftView addSubview:self.eleWhiteboardLabel];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    if (identity != ETTSideNavigationViewIdentityTeacher) {
        
        self.whiteboardManager.suspendNimbleView.suspendNimbleButton.hidden = YES;
        
        self.whiteboardManager.addMoreWhiteboardPageView.hidden = YES;
        
        [self addStudentRightBarButton:rightView];
    }else
    {
        UIButton *pushbutton = [self creatNavigationBarButtonWithTitle:@"推送"];
        pushbutton.frame = CGRectMake(28, 2, 42, 41);
        [pushbutton addTarget:self action:@selector(pushWhiteboardContentView) forControlEvents:UIControlEventTouchUpInside];
        _pushButton = pushbutton;
        [rightView addSubview:pushbutton];
    }
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.titleLabel.text = nil;
}

-(void)addStudentRightBarButton:(UIView *)rightView
{
    [self addMarkScoreButton];
    
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.hidden  = YES;
    self.submitButton.frame   = CGRectMake(30, 0, 40, 44);
    self.submitButton.enabled = YES;

    self.commentButton.frame  = CGRectMake(30, 0, 40, 44);
    self.commentButton.hidden = YES;
    
    [rightView addSubview:self.submitButton];
    [rightView addSubview:self.commentButton];
}

-(UILabel *)setUpTitleView
{
    UILabel *label = [self creatNavigationBarLabel];
    label.frame = CGRectMake(0, 0, 120, 44);
    self.navigationItem.titleView = label;
    
    return label;
}

-(void)setUpCheckSubjectAndFinishedAnswerButton
{
 
    UIButton *checkSubjectButton   = [self creatNavigationBarButtonWithTitle:@"查看原题"];
    checkSubjectButton.frame       = CGRectMake(10, 0, 80, 44);
    checkSubjectButton.tag         = 8010;
    [checkSubjectButton addTarget:self action:@selector(checkOriginalSubject) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *finishedAnswerButton = [self creatNavigationBarButtonWithTitle:@"结束作答"];
    finishedAnswerButton.frame     = CGRectMake(80+30+10, 0, 80, 44);
    [finishedAnswerButton addTarget:self action:@selector(finishedAnswerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    finishedAnswerButton.tag       = 8011;
    UIView *rightView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
 
    [rightView addSubview:checkSubjectButton];
    [rightView addSubview:finishedAnswerButton];

    UIBarButtonItem *rightBarItem  = [[UIBarButtonItem alloc] initWithCustomView:rightView];

    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

-(void)setUpFinishedPushAndAnswerQuestionButton
{
    UIButton *answerQuestionButton = [self creatNavigationBarButtonWithTitle:@"答题"];
    answerQuestionButton.frame     = CGRectMake(10, 0, 40, 44);
    [answerQuestionButton addTarget:self action:@selector(beiganAnswerQuestion) forControlEvents:UIControlEventTouchUpInside];

    self.finishedPushButton.frame  = CGRectMake(40+30+10, 0, 80, 44);

    UIView *rightView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];

    [rightView addSubview:answerQuestionButton];
    [rightView addSubview:self.finishedPushButton];

    UIBarButtonItem *rightBarItem  = [[UIBarButtonItem alloc] initWithCustomView:rightView];

    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(UIButton *)creatNavigationBarButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    return button;
}

-(UILabel *)creatNavigationBarLabel
{
    UILabel *label      = [[UILabel alloc] init];
    label.textColor     = [UIColor whiteColor];
    label.font          = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

-(void)changeToolbarStatus
{
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [self setUpTitleView];
    }
    return _titleLabel;
}

-(UIButton *)menuButton
{
    if (!_menuButton) {
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
        [_menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
        [_menuButton addTarget:self action:@selector(changeToolbarStatus) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _menuButton;
}

-(UIButton *)finishedPushButton
{
    if (!_finishedPushButton) {
        
        _finishedPushButton = [self creatNavigationBarButtonWithTitle:@"结束推送"];
        [_finishedPushButton addTarget:self action:@selector(pushFinished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedPushButton;
}

-(NSMutableArray *)studentAnswerList
{
    if (!_studentAnswerList) {
        _studentAnswerList = [NSMutableArray array];
    }
    return _studentAnswerList;
}

-(NSMutableArray *)studentScoreList
{
    if (!_studentScoreList) {
        _studentScoreList = [NSMutableArray array];
    }
    return _studentScoreList;
}

-(NSString *)pushId
{
    return [ETTNetworkManager currentMsTimeString];
}

-(UIButton *)markScoreButton
{
    if (!_markScoreButton) {
        
        _markScoreButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _markScoreButton.layer.cornerRadius = 28;
        [_markScoreButton setTitle:@"打分" forState:UIControlStateNormal];
        [_markScoreButton setBackgroundColor:[UIColor orangeColor]];
        [_markScoreButton addTarget:self action:@selector(addMarkSocreView) forControlEvents:UIControlEventTouchUpInside];
        _markScoreButton.frame = CGRectMake(kWIDTH - 56 - 16, kHEIGHT - 56 -16, 56, 56);
    }
    return _markScoreButton;
}

-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [self creatNavigationBarButtonWithTitle:@"提交"];
        _submitButton.frame = CGRectMake(10, 0, 40, 44);
        [_submitButton addTarget:self action:@selector(submitAnswerQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

-(UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [self creatNavigationBarButtonWithTitle:@"批阅"];
        _commentButton.frame = CGRectMake(10, 0, 40, 44);
        [_commentButton addTarget:self action:@selector(readOverAndCommentWhiteboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

-(AXPUserInformation *)userInformation
{
    return [AXPUserInformation sharedInformation];
}

-(NSMutableArray *)pushStatus
{
    if (!_pushStatus) {
        _pushStatus = [NSMutableArray arrayWithObjects:@"2",@"3",@"4",@"5",@"20",@"26",nil];
    }
    return _pushStatus;
}

-(NSMutableArray *)wbStatus
{
    if (!_wbStatus) {
        _wbStatus = [NSMutableArray arrayWithObjects:@"2",@"3",@"4",@"5",@"20",@"26",nil];
    }
    return _wbStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"白板里面提示内存⚠️");
}


#pragma mark
#pragma mark  ----------------  白板恢复 -----------------
-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (commond== nil)
    {
        return;
    }
    
    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
    if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state1"])
    {
         [self restoreWhiteboardPushState:restoreCommand];
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state2"])
    {
        [self restoreWhiteboardAnser:restoreCommand];
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state3"])
    {
        [self restoreWhiteboardAnserEnd:restoreCommand];
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state4"])
    {
        [self restoreWhiteboardEachBatch:restoreCommand];

    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state5"])
    {
        [self restoreWhiteboardEachBatchEnd:restoreCommand];
        
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state21"])
    {
        [self restoreWhiteboardNomarkStuImagePush:restoreCommand];
        
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"WB_state22"])
    {
        [self restoreWhiteboardMarkStuImagePush:restoreCommand];
        
    }
    else
    {
        
    }
//    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
//    NSDictionary * dic = restoreCommand.EDListModel.EDDisasterDic;
//    NSInteger state = [[dic valueForKey:@"state"]integerValue];
//    switch (state)
//    {
//        case 4:
//        {
//            [self restoreWhiteboardPushState:restoreCommand];
//        }
//            break;
//        case 2:
//        {
//            
//        }
//           break;
//        default:
//            break;
//    }
 
}

/**
 Description  恢复推送状态

 @param command 恢复命令
 */
-(void)restoreWhiteboardPushState:(ETTRestoreCommand *)command
{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardPushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [self pushWhiteboardContentView];
        }
            break;
        default:
            break;
    }

}

-(void)restoreWhiteboardPushed:(ETTRestoreCommand *)command
{
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    _MVHasPushAction = YES;
    if (self.studentAnswerList)
    {
        [self.studentAnswerList removeAllObjects];
    }
    
    /////////////////////////////////////////////////////
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    [self.EVGuardModel  setNeedNotice:false];
    [[ETTScenePorter shareScenePorter] enterRegistration:self.EVGuardModel];
    [ETTBackToPageManager sharedManager].isPushing = YES;
    
    self.isMarkScore = NO;
    
    UIColor *color = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor;
    
    [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor = kAXPMAINCOLORc17;
    
    CGPoint selectedPoint;
    
    if ([AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView) {
        
        selectedPoint = [AXPWhiteboardToolbarManager sharedManager].whiteboardView.selectedView.center;
        
        [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:CGPointZero];
    }
    self.teacherPushWhithboardId  = [command.EDListModel.EDDisasterDic valueForKey:@"whiteboardId"];
    // 当前白板页图片
    UIImage *whiteboardImage = [UIView snapshot:[AXPWhiteboardToolbarManager sharedManager].whiteboardView];
    self.originImage = whiteboardImage;
    
    [[AXPWhiteboardToolbarManager sharedManager].whiteboardView selectedMovedImageWithPoint:selectedPoint];
    
    [AXPWhiteboardToolbarManager sharedManager].whiteboardView.backgroundColor = color;
    
    // 改变导航栏显示按钮
    [self setUpFinishedPushAndAnswerQuestionButton];
    
    // 隐藏悬浮按钮和页码按钮
    [[AXPWhiteboardToolbarManager sharedManager].suspendNimbleView hiddenNimbleToolbarCompletion:^{
        
        [AXPWhiteboardToolbarManager sharedManager].suspendNimbleView.suspendNimbleButton.hidden = YES;
    }];
    
    [AXPWhiteboardToolbarManager sharedManager].addMoreWhiteboardPageView.hidden = YES;
   
    
    self.classroomDict = [[NSMutableDictionary alloc]initWithDictionary:command.EDListModel.EDDisasterDic];
   
    

    [self downloadImageWithURLString:self.classroomDict[kwbImg]];
    
    [command commandPeriodicallyComplete:self];
}

/**
 Description  恢复答题状态
 
 @param command 恢复命令
 */
-(void)restoreWhiteboardAnser:(ETTRestoreCommand *)command
{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardAnserPushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }

}
-(void)restoreWhiteboardAnserPushed:(ETTRestoreCommand *)command
{
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
    _MVIsBeginAnser  = YES;
    if (self.studentAnswerList)
    {
        [self.studentAnswerList removeAllObjects];
    }
    /////////////////////////////////////////////////////
    
    self.teacherPushWhithboardId = [command.EDListModel.EDDisasterDic valueForKey:@"whiteboardId"];
    WS(weakSelf);

    dispatch_async(dispatch_get_main_queue(), ^{
        
     [weakSelf setUpCheckSubjectAndFinishedAnswerButton];
        weakSelf.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  %lu",(unsigned long)self.studentAnswerList.count];
        weakSelf.titleLabel.hidden = NO;
        weakSelf.eleWhiteboardLabel.hidden = YES;
    });
  
    

    [weakSelf addStudentAnswerListViewWithItemSize:CGSizeMake(220, 235)];
    ETTLog(@"%@",self.classroomDict);

    NSString * key = [NSString stringWithFormat:@"%@_%@",student_wb_answer,[self.classroomDict valueForKey:@"whiteboardId"]];
    [[ETTRedisBasisManager sharedRedisManager] redisHGETALL:key respondHandler:^(id value, id error) {
        [weakSelf restoreWhiteboardStudentAnsered:value view:nil];
        [command commandPeriodicallyComplete:self];
    }];
 
   
}

-(void)restoreWhiteboardStudentAnsered:(id)value view:(UIButton * )button
{
     WS(weakSelf);
    NSDictionary  * dic = value;
    if (dic )
    {
        NSDictionary  * dic = value;
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [weakSelf reciveteacherGetStudentWBAnswerInfo:[ETTRedisBasisManager getDictionaryWithJSON:obj]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  %lu",(unsigned long)self.studentAnswerList.count];
            weakSelf.titleLabel.hidden = NO;
        });
    }
    
    if (value == nil || self.studentAnswerList.count <= 1) {
        if (button)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                button.enabled = NO;
                [button setTitle:@"已结束" forState:UIControlStateNormal];
            });
           
        }
        
        
    }else
    {
        if (button)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                button.enabled = YES;
                [button setTitle:@"学生互批" forState:UIControlStateNormal];
            });
          
        }
        
    }

 
}


/**
 Description  恢复结束作答状态
 
 @param command 恢复命令
 */
-(void)restoreWhiteboardAnserEnd:(ETTRestoreCommand *)command
{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardAnserEndPushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }
    
}


-(void)restoreWhiteboardAnserEndPushed:(ETTRestoreCommand *)command
{
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    if ([[command.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 23 )
    {
        [self.classroomDict setObject:@"3" forKey:@"state"];
    }
 
    WS(weakSelf);
    NSString * key = [NSString stringWithFormat:@"%@_%@",student_wb_answer,[self.classroomDict valueForKey:@"whiteboardId"]];
    [[ETTRedisBasisManager sharedRedisManager] redisHGETALL:key respondHandler:^(id value, id error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *rightView              = self.navigationItem.rightBarButtonItem.customView;
            if (rightView == nil)
            {
                
                [self setUpCheckSubjectAndFinishedAnswerButton];
                rightView              = self.navigationItem.rightBarButtonItem.customView;
            }
            
            UIButton *finishedAnswerButton = [rightView viewWithTag:8011];
             NSDictionary  * dic = value;
            if (dic.allKeys.count<=1) {
                
                if (finishedAnswerButton)
                {
                    finishedAnswerButton.enabled = NO;
                    [finishedAnswerButton setTitle:@"已结束" forState:UIControlStateNormal];
                    
                }
                
                
            }else
            {
                if (finishedAnswerButton)
                {
                    finishedAnswerButton.enabled = YES;
                    [finishedAnswerButton setTitle:@"学生互批" forState:UIControlStateNormal];
                    
                }
                
            }
        });
        
        [weakSelf setUpStudentMutualCorrectBar];
        
        [command commandPeriodicallyComplete:self];
    }];




}



-(void)restoreWhiteboardEachBatch:(ETTRestoreCommand *)command

{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardEachBatchPushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }

}
-(void)restoreWhiteboardEachBatchPushed:(ETTRestoreCommand *)command
{
    
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    
    [self.studentAnswerList enumerateObjectsUsingBlock:^(NSMutableDictionary *currentDict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableDictionary *forwardDict,*nextDict;
        
        if (idx == 0) {
            
            forwardDict = self.studentAnswerList.lastObject;
        }else
        {
            forwardDict = self.studentAnswerList[idx-1];
        }
        
        if (idx == self.studentAnswerList.count - 1) {
            
            nextDict = self.studentAnswerList.firstObject;
            
        }else
        {
            nextDict = self.studentAnswerList[idx + 1];
        }
        
        // 1. 更改白板作答数据表.
        [currentDict setObject:nextDict[kuserId] forKey:kmarkJid];
        [currentDict setObject:nextDict[kuserName] forKey:kmarkName];
        
        // 2.
        NSString *field            = currentDict[kuserId];
        
        NSDictionary *markedDict   = @{kmarkedJid:forwardDict[kuserId],kmarkedPoint:@"-1",kwbImgUrl:forwardDict[kuserWbImg],kmarkTag:self.classroomDict[kmarkTag]};
        
        NSDictionary *mutuallyDict = @{kuserId:currentDict[kuserId],kuserName:currentDict[kuserName],kuserPhoto:currentDict[kuserPhoto],kmarkedBean:markedDict};
        
        NSString *jsonStr          = [self getJsonStrWithDict:mutuallyDict];
        
        [commentDict setObject:jsonStr forKey:field];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUpCheckSubjectAndFinishedAnswerButton];
        
        UIView *rightView              =self.navigationItem.rightBarButtonItem.customView;
        
        UIButton *finishedAnswerButton =  [rightView viewWithTag:8011];
        
        
        self.finishedPushButton.hidden = YES;
        
        [finishedAnswerButton setTitle:@"互批结束" forState:UIControlStateNormal];
        
        
        self.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  0"];
        self.titleLabel.hidden = NO;

    });
    
    
    self.isMarkScore = YES;
    // 4. 监听学生打分数据
    [self beiganGetStudentMarkScoreData];

    WS(weakSelf);
    NSString * key = [NSString stringWithFormat:@"%@_%@",student_wb_commnet,[self.classroomDict valueForKey:@"whiteboardId"]];
    
    [[ETTRedisBasisManager sharedRedisManager] redisHGETALL:key respondHandler:^(id value, id error) {
    
     
        NSDictionary  * dic = value;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDictionary * vdic = [ETTRedisBasisManager getDictionaryWithJSON:obj];
            
            [weakSelf getStudentWbCommentData:[vdic  objectForKey:@"userInfo"]];
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.text   = [NSString stringWithFormat:@"已提交 :  %lu",(unsigned long)self.studentScoreList.count];
        });
     
        [command commandPeriodicallyComplete:self];
    }];

}


-(void)restoreWhiteboardEachBatchEnd:(ETTRestoreCommand *)command

{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardEachBatchEndPushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }
    
}
-(void)restoreWhiteboardEachBatchEndPushed:(ETTRestoreCommand *)command
{
    
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    if ([[command.EDListModel.EDDisasterDic valueForKey:@"state"] integerValue] == 20 )
    {
        [self.classroomDict setObject:@(3) forKey:@"state"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *checkSubjectButton   = [self creatNavigationBarButtonWithTitle:@"查看原题"];
        checkSubjectButton.frame       = CGRectMake(10, 0, 80, 44);
        [checkSubjectButton addTarget:self action:@selector(checkOriginalSubject) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *finishedAnswerButton = [self creatNavigationBarButtonWithTitle:@"已结束"];
        finishedAnswerButton.frame     = CGRectMake(80+30+10, 0, 80, 44);
        [finishedAnswerButton addTarget:self action:@selector(finishedAnswerQuestion:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *rightView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
        
        [rightView addSubview:checkSubjectButton];
        [rightView addSubview:finishedAnswerButton];
        
        UIBarButtonItem *rightBarItem  = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        self.navigationItem.rightBarButtonItem = rightBarItem;
        UIButton *  button =  finishedAnswerButton;
        button.enabled = NO;
        
        
        self.finishedPushButton.hidden = NO;

    });
       [self.classroomDict setObject:@"20" forKey:@"state"];

     [command commandPeriodicallyComplete:self];

}

#pragma mark 推送学生作答图片 恢复
-(void)restoreWhiteboardNomarkStuImagePush:(ETTRestoreCommand *)command
{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardNomarkStuImagePushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }

}
-(void)restoreWhiteboardNomarkStuImagePushed:(ETTRestoreCommand *)command
{
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
    AXPStudentSubjectViewController *vc = [[AXPStudentSubjectViewController alloc] init];
    
    vc.classroomDict = self.classroomDict;
    NSDictionary *dict = command.EDListModel.EDDisasterDic;
    NSString *urlStr = dict[kAnswerImg];
//    [NSString stringWithFormat:@"http://%@%@%@",[AXPUserInformation sharedInformation].redisIp,@"/ettschoolmitm/mitm2ettschool/localok//",];
    
    [vc.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        CGSize size = [ETTImageManager getImageSizeWithImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            vc.imageView.frame = CGRectMake(0, 0, size.width, size.height);
            
            vc.imageView.center = vc.view.center;
            
        });
    }];
    vc.imageUrlStr = urlStr;
    vc.answerJid = [NSString stringWithFormat:@"%@",dict[kuserId]];
    self.currentRespondImageUrlStr  = urlStr;
    //= dict[@"wbImg"];

    vc.title = dict[@"userName"];
    [self.classroomDict setObject:@"21" forKey:@"state"];
    [self.navigationController pushViewController:vc animated:YES];
    [command commandPeriodicallyComplete:self];
}
#pragma mark 推送学生批阅图片 恢复

-(void)restoreWhiteboardMarkStuImagePush:(ETTRestoreCommand *)command
{
    switch (command.EDListModel.EDOperationSTate)
    {
        case ETTBACKOPERATIONSTATESTART:
        {
            [self restoreWhiteboardMarkStuImagePushed:command];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            [command commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }
}

-(void)restoreWhiteboardMarkStuImagePushed:(ETTRestoreCommand *)command
{
    if (command.EDListModel.EDDisasterDic == nil)
    {
        [command commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
    AXPStudentSubjectViewController *vc = [[AXPStudentSubjectViewController alloc] init];
    
    vc.classroomDict = self.classroomDict;
    NSDictionary *dict = command.EDListModel.EDDisasterDic;
    
    NSString *urlStr = dict[kCommentImg];
    
    [vc.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
        CGSize size = [ETTImageManager getImageSizeWithImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            vc.imageView.frame = CGRectMake(0, 0, size.width, size.height);
            
            vc.imageView.center = vc.view.center;
            
        });
        
    }];
    vc.imageUrlStr = urlStr;
    vc.answerJid = [NSString stringWithFormat:@"%@",dict[kuserId]];
    
    self.currentRespondImageUrlStr = urlStr;
    //dict[@"wbImg"];
    
    vc.title = dict[@"userName"];
       [self.classroomDict setObject:@"22" forKey:@"state"];
    [self.navigationController pushViewController:vc animated:YES];
    [command commandPeriodicallyComplete:vc];
}
@end

