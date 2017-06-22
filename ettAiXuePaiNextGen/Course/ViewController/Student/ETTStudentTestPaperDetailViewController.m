//
//  ETTStudentTestPaperDetailViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/3.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentTestPaperDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ETTClassroomModelManager.h"
#import "AXPRedisManager.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTURLUTF8Encoder.h"
#import "ETTRedisManagerConst.h"
#import "AXPWhiteboardViewController.h"
#import "AXPCheckOriginalSubjectView.h"
#import "ETTRedisBasisManager.h"
#import "ETTJudgeIdentity.h"
#import "ETTPromptView.h"
#import "ETTRemindManager.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTImageManager.h"
#import "AXPGetRootVcTool.h"
#import "UIImagePickerController+ETTUIImagePickerController.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTPushMProgressBarView.h"
#import "ETTLCAButton.h"
#import "NSString+ETTDeviceType.h"

/**
 *  @author LiuChuanan, 17-04-13 21:42:57
 *  
 *  @brief 获取照片压缩比例 按照等比例压缩,不能按照之前写死的数值压缩
 *
 *  branch origin/bugfix/Refix-imageSize
 *   
 *  Epic   origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
static CGFloat const zipScale = 0.9;

@interface ETTStudentTestPaperDetailViewController ()<WKUIDelegate,WKNavigationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIButton                *backButton;//返回按钮

@property (strong, nonatomic) UIButton                *submitButton;//提交按钮

@property (copy, nonatomic  ) NSString                *urlStr;

@property (copy, nonatomic  ) NSString                *urlString;

@property (strong, nonatomic) WKWebView               *webView;

@property (copy, nonatomic  ) NSString                *teacherForceAnswerJson;//老师强制交卷的json字符串

@property (copy, nonatomic  ) NSString                *studentSelfCommitAnswerJosn;//学生自己提交试卷的json字符串

@property (copy, nonatomic  ) NSString                *submitTips;//提交提示

@property (copy, nonatomic  ) NSString                *unsubmitTips;//未做完提交

@property (copy, nonatomic  ) NSString                *currentPaper;//试卷当前页

@property (assign, nonatomic) BOOL                    isStudentSelfCommit;//学生自己是否提交了 默认没有

@property (copy, nonatomic  ) NSString                *studentAnswerJsonString;//学生作答json字符串

@property (copy, nonatomic  ) NSString                *endAnswerMid;

@property (assign, nonatomic) BOOL                    isPushTestPaper;//是否在推试卷 默认不是

@property (strong, nonatomic) NSDictionary            *pushDict;

@property (strong, nonatomic) ETTPushMProgressBarView *progressView;

@property (strong, nonatomic) ETTLCAButton            *failedAndReloadButton;

@property (copy, nonatomic  ) NSString                *putImgAnswerUrl;//相机,相册作答字符串

@property (assign, nonatomic) BOOL                    isAppearBlank;//加载网页的时候是否出现空白

@property (strong, nonatomic) UIImage                 *image;

@property (copy, nonatomic  ) NSString                *questionId;//当前问题id

@property (assign, nonatomic) BOOL isFirst;

@property (nonatomic, strong) UIImagePickerController *imagePickerViewController;

@end


@implementation ETTStudentTestPaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [ETTBackToPageManager sharedManager].cameraOpenTimes = 0;
    
    [self setupNavBar];
    
    [self setupSubView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherPushTestPaperInfo:) name:kREDIS_COMMAND_TYPE_CO_04 object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studentGetTeacherPushWBInfo:) name:kREDIS_COMMAND_TYPE_WB_01 object:nil];
    
    int random = [self getRandomNumFrom:1 to:2];
    
    //移除课堂重连的推送动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ETTSideNavigationViewController *side = [ETTJudgeIdentity getSideNavigationViewController];
        [side removeCoursewarePushAnimation];
    });
    
    //初始化
    self.isAppearBlank = NO;
    
}
-(void)resetViewController
{
    if (_webView)
    {
        if (_webView.loading)
        {
            [_webView stopLoading];
        }
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc]init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
-(void)createWebView
{
    if (self.webView.superview == nil)
    {
        [self.view addSubview:self.webView];
    }
}
/**
 初始化webView
 */
- (void)setupSubView {
    
    //webview
    [self createWebView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
        _webView.scrollView.delegate = self;
    }
    _webView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    //加载老师推过来的没有公布答案前的h5
    self.urlStr = [NSString stringWithFormat:@"%@taskTestPager.html",[AXPUserInformation sharedInformation].paperRootUrl];
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    NSDictionary *params = [NSDictionary dictionary];
    if ([self.itemIds isEqualToString:@"1"]) {//推试卷
        
        params = @{@"jid":userInformation.jid,
                   @"classroomId":userInformation.classroomId,
                   @"userName":userInformation.userName,
                   @"userPhoto":userInformation.userPhoto,
                   @"userType":userInformation.userType,
                   @"testPaperId":self.testPaperId,
                   @"pushId":self.pushId,
                   @"courseId":self.courseId
                   };
        self.isFirst = NO;
        self.isPushTestPaper = YES;
        self.isStudentSelfCommit = NO;
        self.studentAnswerJsonString = nil;
    } else {//推试题
        params = @{@"jid":userInformation.jid,
                   @"classroomId":userInformation.classroomId,
                   @"userName":userInformation.userName,
                   @"userPhoto":userInformation.userPhoto,
                   @"userType":userInformation.userType,
                   @"testPaperId":self.testPaperId,
                   @"pushId":self.pushId,
                   @"itemIds":self.itemIds,
                   @"courseId":self.courseId
                   };
        self.isFirst = NO;
        self.isPushTestPaper = NO;
        self.isStudentSelfCommit = NO;
        self.studentAnswerJsonString = nil;
    }
    
    NSAssert(params, @"参数有问题");
    
    [[ETTNetworkManager sharedInstance]GETSign:self.urlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.urlString = [NSString stringWithFormat:@"%@?%@",self.urlStr,[self getParamsStringWithParams:responseDictionary]];
        
    }];
    
    if (self.urlString) {
        //加载没公布答案前的h5
        [self.webView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.urlString]]];
    }
    
    //网页加载进度条
    _progressView = [[ETTPushMProgressBarView alloc]init];
    _progressView.layer.cornerRadius = 1.0;
    _progressView.barBorderColor = [UIColor blackColor];
    _progressView.barBorderWidth = 0.5;
    _progressView.barFillColor = kC2_COLOR;
    _progressView.barInnerPadding = 0.0;
    _progressView.frame = CGRectMake(10, 5, self.view.width - 20, 5);
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    
    //加载失败按钮
    _failedAndReloadButton = [[ETTLCAButton alloc]init];
    _failedAndReloadButton.frame = CGRectMake(0, 0, 200, 200);
    _failedAndReloadButton.center = self.view.center;
    [_failedAndReloadButton setTitle:@"加载失败,点击重新加载" forState:UIControlStateNormal];
    _failedAndReloadButton.titleLabel.textColor = [UIColor blackColor];
    _failedAndReloadButton.hidden = YES;
    [_failedAndReloadButton addTarget:self action:@selector(reloadButtonDidClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_failedAndReloadButton];
    
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

/**
 KVO 监测试卷页面加载进度
 
 @param keyPath 
 @param object 
 @param change 
 @param context 
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _progressView.progress = [change[@"new"]floatValue];
            if (_progressView.progress == 1.0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _progressView.hidden = YES; 
                });
            }
        });
    }
}

//加载失败重新加载
- (void)reloadButtonDidClick:(ETTLCAButton *)button {
    [_webView reload];
    _webView.hidden = NO;
    button.hidden = YES;
}

#pragma WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    ETTLog(@"网页开始加载");
    _progressView.hidden = NO;
}

/**
 *  数据开始返回调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    ETTLog(@"页面内容开始返回");
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (self.isAppearBlank) {
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
        
    }
    ETTLog(@"加载完成的时候调用");
    
}

- (void)delayMethod {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *setCurrQuestionInfoForIOS = [NSString stringWithFormat:@"setCurrQuestionInfoForIOS('%@')",self.questionId];
        
        ETTLog(@"putImgAnswerUrl: %@",self.putImgAnswerUrl);
        
        [self.webView evaluateJavaScript:setCurrQuestionInfoForIOS completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
            if (!error) {
                
                self.questionId = nil;
                
                [self.webView evaluateJavaScript:self.putImgAnswerUrl completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    
                    if (!error) {
                        self.putImgAnswerUrl = nil;
                        self.image           = nil;
                    }
                }];
            }
        }];
    });
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_webView setHidden:YES];
    [_failedAndReloadButton setHidden:NO];
    ETTLog(@"加载失败的时候调用%@",error);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    ETTLog(@"接收到服务器跳转请求之后调用");
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    ETTLog(@"接到请求后决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//HTTPS认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    self.isAppearBlank = YES;
    
    /**
     *  @author LiuChuanan, 17-03-23 18:42:57
     *  
     *  @brief 如果出现空白页,webView把url重新加载一遍,不调用reload方法
     *
     *
     *  @since 
     */
    if ([self.webView isLoading]) 
    {   
        NSLog(@"正在加载,停止加载");
        [self.webView stopLoading];
    }
    
    NSLog(@"出现空白页重新加载");
    if (self.urlString) 
    {
        //加载没公布答案前的h5
        [self.webView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.urlString]]];
    }
}

/**
 生成from 到 to的随机数
 
 @param from 
 @param to 
 @return 
 */
- (int)getRandomNumFrom:(int)from to:(int)to {
    
    return (int)(from + (arc4random() % (to - from + 1)));
}

//学生接收到结束作答信息后作出相应的操作
- (void)studentGetEndAnswerInfoAndDoRelationOperation {
    
    //1.试卷变成公布答案状态
    [self.webView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable script, NSError * _Nullable error) {
        
        ETTLog(@"%@",error);
        
        [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
        self.submitButton.enabled = NO;
        
    }];
    
}

// 学生接收到教师推送的课堂状态信息
-(void)studentGetTeacherPushWBInfo:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    
    //学生提交了作答信息才将互批信息分给他
    BOOL isCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
    
    //判断学生有没有提交
    if (isCommit) {
        self.pushDict = userInfo;
    }
}

//老师点击了结束作答按钮学生应该做出的处理
- (void)teacherClickEndAnswerButton {
    
    
    BOOL studentCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
    
    //学生自己点击了提交
    if (studentCommit) 
    {
        
    } else 
    {
        //2.获得学生的作答信息
        [self.webView evaluateJavaScript:@"getAnswerJson('true')" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            
            if (error) {
                ETTLog(@"学生给老师提交答案失败%@",error);
            } else {
                
                //将强制收卷的作答信息提交到老师那边
                [self commitStudentAnswerInfoToTeacher];
            }
        }];
    }
    
    [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
    self.submitButton.enabled = NO;
}

- (void)studentGetTeacherPushTestPaperInfo:(NSNotification *)notify {
    
    NSDictionary *dict = notify.object;
    /**
     *  @author LiuChuanan, 17-03-15 17:02:57
     *  
     *  @brief 判断字典是否为空
     *
     *  @since 
     */
    
    if (dict == nil || !dict) {
        return;
    }
    
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    NSString *CO_04_state = [userInfo objectForKey:@"CO_04_state"];
    
    /**学生获得老师结束作答信息后应该做的事情:
     1.试卷变成公布答案状态
     2.获得学生的作答信息
     3.将每人的作答信息提交到老师那边
     
     */
    
    if ([CO_04_state isEqualToString:@"CO_04_state2"]) {
        
        [ETTCoursewarePresentViewControllerManager sharedManager].isPushSubjectItem = NO;
        
        if ([self.endAnswerMid isEqualToString:[dict objectForKey:@"mid"]]) {
            return;
        } else {
            self.endAnswerMid = [dict objectForKey:@"mid"];
            //1.试卷变成公布答案状态
            [self.webView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable script, NSError * _Nullable error) {
                
                /**
                 *  @author LiuChuanan, 17-03-10 18:32:57
                 *  
                 *  @brief 如果学生主动提交了答案,收到命令后不再提交
                 *
                 *  @since 
                 */
                BOOL studentCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
                if (studentCommit == NO) {
                    
                    [self teacherClickEndAnswerButton];
                }
            }];
        }
    }
    
    
    /**老师滑动试卷到不同页码学生应该做的事情:
     1.获得老师推送过来的试卷页码,滚动到相应页码
     
     */
    if ([CO_04_state isEqualToString:@"CO_04_state3"]) {
        
        NSString *currentPaper = [userInfo objectForKey:@"currentPaper"];
        NSString *runToPage = [NSString stringWithFormat:@"setItemIndex(%@)",currentPaper];
        
        //如果老师上次推送过来的试卷页码和上次的一样,就不做操作,否则就协同浏览
        if (([self.currentPaper isEqualToString:currentPaper])) {
            return ;
        } else {
            
            self.currentPaper = currentPaper;
            
            //3.协同浏览
            [self.webView evaluateJavaScript:runToPage completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            }];
        }
    }
    
    /**学生接收到老师奖励消息应该做的事情:
     1.判断多少学生答对,做出相应的处理
     只有一个人答对的时候,答对人本人不显示下拉提示框
     */
    if ([CO_04_state isEqualToString:@"CO_04_state4"]) {
        
        NSString *msg = [userInfo objectForKey:@"msg"];
        NSString *rewardUserStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"rewardUserStr"]];
        
        NSArray *rewardUserArray;
        
        if (rewardUserStr.length > 10) {
            
            rewardUserArray = [rewardUserStr componentsSeparatedByString:@","];
            
            for (int i = 0; i < rewardUserArray.count; i++) {
                NSString *jid = rewardUserArray[i];
                
                NSString *userJid = [NSString stringWithFormat:@"%@",[AXPUserInformation sharedInformation].jid];
                
                if ([jid isEqualToString:userJid]) {
                    
                    //答对的学生 既要显示奖励动画 也要显示下拉提示框
                    [[ETTRemindManager shareRemindManager] createRemindView:ETTREWARDSVIEW withCount:1];
                }
                
                //没答对的学生只显示下拉提示框
                [self showPromptViewWithString:msg];
                
            }
            
        } else {
            
            NSString *jid = [NSString stringWithFormat:@"%@",[AXPUserInformation sharedInformation].jid];
            
            if ([jid isEqualToString:rewardUserStr]) {
                
                //本人不显示下拉提示框  只显示奖励动画
                //显示奖励动画
                [[ETTRemindManager shareRemindManager] createRemindView:ETTREWARDSVIEW withCount:1];
            } else {//答错的显示 msg下拉提示框
                
                [self showPromptViewWithString:msg];
            }
        }
    }
    
    
    /**老师点击结束推送学生应该做的事情
     1.学生显示返回按钮
     
     */
    if ([CO_04_state isEqualToString:@"CO_04_state5"]) {
        
        //1.弹出返回按钮
        [self.backButton setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"studentCommit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //学生获得老师结束推送信息后要把上次的学生作答json字符型置为nil
        self.studentAnswerJsonString = nil;
        
        self.unsubmitTips = nil;
        
        self.submitTips = nil;
        
        self.isFirst = NO;
        
        [ETTCoursewarePresentViewControllerManager sharedManager].itemIds = nil;
        [ETTCoursewarePresentViewControllerManager sharedManager].testPaperId = nil;
    }
}

//学生向老师提交的作答信息
- (void)commitStudentAnswerInfoToTeacher {
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if (self.studentAnswerJsonString) {
        
        NSString *time = [ETTRedisBasisManager getTime];
        
        NSDictionary *userInfo = @{@"answerJson":self.studentAnswerJsonString,
                                   
                                   @"pushedTestPaperId":self.pushedTestPaperId  //新增的一个字段  老师过滤答案的时候会用到
                                   };
        
        NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                @"to":@"ALL",
                                @"from":[AXPUserInformation sharedInformation].jid,
                                @"type":@"SCO_01",
                                @"userInfo":userInfo
                                };
        
        NSString *key = [NSString stringWithFormat:@"%@%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL,self.pushedTestPaperId];
        NSString *jid = [AXPUserInformation sharedInformation].jid;
        
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
        NSString *dicJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
        NSDictionary *messageDic = @{jid:dicJSON};
         NSString *channelKey = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
        
        [redisManager redisHMSET:key dictionary:messageDic respondHandler:^(id value, id error) {
            
            if (error) {
                ETTLog(@"同步进课错误原因:%@",error);
            }else{
                NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
                [redisManager publishMessageToChannel:channelKey message:messageJSON  respondHandler:^(id value, id error) {
                    if (!error) {
                        //NSLog(@"成功发送消息%@",dict);
                    }else{
                        NSLog(@"发送消息%@失败！",dict);
                    }
                }];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.studentAnswerJsonString = nil;
    self.unsubmitTips = nil;
    self.submitTips = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //保存用户提交状态 下次重连课堂的时候用到
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"studentCommit"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //设备常亮
    [self resetIdleTimerDisabled];
}

- (void)resetIdleTimerDisabled
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

//拼接字典key和value成字符串
- (NSString *)getParamsStringWithParams:(NSDictionary *)params {
    NSMutableArray *array = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *keyValueString = [NSString stringWithFormat:@"%@=%@",key,value];
        [array addObject:keyValueString];
    }];
    NSString *string = [array componentsJoinedByString:@"&"];
    return string;
}

#pragma WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
    
    //学生提交试卷的
    NSDictionary *dict = [ETTJSonStringDictionaryTransformation jsonStringTodictionary:message];
    
    NSNumber *result = [dict objectForKey:@"result"];
    
    //不可交卷
    if ([result isEqual:@109]) {
        
        [self.submitButton setEnabled:NO];
        [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    //试卷未作答完
    if ([result isEqual:@116]) {
        
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.submitButton setEnabled:YES];
        self.submitTips = @"有未作答的题目";
    }
    
    //可交卷
    if ([result isEqual:@108]) {
        
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.submitButton setEnabled:YES];
        
    }
    
    if ([result isEqual:@105]) {
        
        
        self.unsubmitTips = @"都回答完了";
        
        
        // 将JSON转化为字典
        self.studentAnswerJsonString = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"answerJson"]];
    }
    
    //拍照作答主观题
    if ([result isEqual:@102]) {
        
        self.questionId = [[dict objectForKey:@"data"] objectForKey:@"questionId"];
        
        ETTLog(@"%@",self.questionId);
        
        [self selectImageWithNumber:@102];
    }
    
    //相册作答主观题
    if ([result isEqual:@103]) {
        
        [self selectImageWithNumber:@103];
    }
    
    //白板作答主观题
    if ([result isEqual:@104]) {
        ETTLog(@"%@",[NSThread currentThread]);
        [self addWhiteboardImage];
        
    }
    
    // 作答的图片被点击
    if ([result isEqual:@114]) {
        
        [self paperAnswerImageClickWithDict:dict];
    }
    
    //js提示加载完毕
    
    if ([result isEqual:@112]) {
        
        //重连课堂的公布答案后 
        if ([ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndPublishAnswer == YES) {
            
            //判断学生的提交状态
            [self judgeStudentCommitStatus];
            
            [self studentGetEndAnswerInfoAndDoRelationOperation];
            [ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndPublishAnswer = NO;
        }
        
        //重连课堂试卷协同浏览
        if ([ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndShowCurrentPage) {
            
            //判断学生的提交状态
            [self judgeStudentCommitStatus];
            
            NSString *currentPaper = self.pushCurrentPage;
            NSString *runToPage = [NSString stringWithFormat:@"setItemIndex(%@)",currentPaper];
            [self.webView evaluateJavaScript:runToPage completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            }];
            
            [ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndShowCurrentPage = NO;
        }
        
    }
}

//判断重连课堂后学生的提交状态
- (void)judgeStudentCommitStatus {
    
    //判断学生重连课堂有没有提交过试卷
    BOOL studentCommit = [[NSUserDefaults standardUserDefaults]boolForKey:@"studentCommit"];
    UIButton *submitButton = [[UIButton alloc]init];
    CGFloat submitButtonWidth = 60;
    CGFloat submitButtonHeight = 44;
    submitButton.enabled = NO;
    submitButton.frame = CGRectMake(0, 0, submitButtonWidth, submitButtonHeight);
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitButton];
    
    if (studentCommit) {
        [submitButton setTitle:@"已提交" forState:UIControlStateNormal];
        self.submitButton = submitButton;
    } else {
        [submitButton setTitle:@"未提交" forState:UIControlStateNormal];
    }
}

-(void)paperAnswerImageClickWithDict:(NSDictionary *)dict
{
    NSLog(@"作答图片被点击了...");
    
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    __block UIView *view;
    
    [rootVc.view.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[AXPCheckOriginalSubjectView class]]) {
            
            *stop = YES;
            view = obj;
        }
    }];
    
    if (view) {
        return;
    }
    
    NSDictionary *imageDict = dict[@"data"];
    
    NSString *imageUrlStr = imageDict[@"imgUrl"];
    
    // 显示图片
    AXPCheckOriginalSubjectView *showView = [AXPCheckOriginalSubjectView showPaperAnswerImageWithUrlString:imageUrlStr];
    
    if ([self.pushDict[kstate] isEqualToString:@"27"]) {
        
        showView.checkCommentOrAnswerButton.hidden = NO;
        
    }else
    {
        showView.checkCommentOrAnswerButton.hidden = YES;
    }
    
    [rootVc.view addSubview:showView];
}

-(void)addWhiteboardImage
{
    [ETTCoursewarePresentViewControllerManager sharedManager].isPushSubjectItem = YES;
    
    // 0. 进入白板控制器
    ETTSideNavigationViewController *rootVc =[AXPGetRootVcTool getCurrentWindowRootViewController];
    
    ETTNavigationController *nv = rootVc.childViewControllers[1];
    
    AXPWhiteboardViewController *whiteboardVc;
    
    if ([nv.topViewController isKindOfClass:[AXPWhiteboardViewController class]]) {
        
        whiteboardVc = (AXPWhiteboardViewController *)nv.topViewController;
        whiteboardVc.currentIndex = rootVc.index;
        
    }else
    {
        UIViewController *vc = nv.topViewController;
        [nv popViewControllerAnimated:NO];
        whiteboardVc = (AXPWhiteboardViewController *)nv.topViewController;
        whiteboardVc.topVc = vc;
    }
    
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isPushSubjectItem == YES) {
        [whiteboardVc.menuButton setUserInteractionEnabled:NO];
        [whiteboardVc.menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateNormal];
    }
    
    [rootVc presentViewControllerToIndex:1 title:nil];
    
    [whiteboardVc addWhiteboardImageToPaperWithPaperImageHandle:^(UIImage *resondImage) {
        
        CGSize imagesize = CGSizeMake(kWIDTH - kAXPWhiteboardManagerWidth, kHEIGHT - 64);
        
        resondImage = [self imageWithImage:resondImage scaledToSize:imagesize];
        
        /**
         *  @author LiuChuanan, 17-05-10 11:41:57
         *  
         *  @brief  白板作答主观题,把图片压缩 mini1要到40%,其它设备78%
         *
         *  branch  origin/bugfix/AIXUEPAIOS-1319
         *   
         *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
         * 
         *  @since 
         */
        NSData *data;
        NSString *device = [NSString getDeviceType];
        if ([device isEqualToString:iPadMini1]) 
        {
           data = UIImageJPEGRepresentation(resondImage, 0.4);
        } else
        {
            data = UIImageJPEGRepresentation(resondImage, 0.78);
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
        
        //上传图片
        [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:nil fileData:data mimeType:@"image/jpg" uploadImageRule:kStudentAnswerImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
            
            if (!error && responseDictionary) {
                NSArray *attachUrl = responseDictionary[@"attachUrl"];
                NSString *imageURL = [NSString stringWithFormat:@"http://%@%@",[AXPUserInformation sharedInformation].redisIp,attachUrl.firstObject];
                
                NSString *putImgAnswerUrl = [NSString stringWithFormat:@"putImgAnswerUrl('%@')",imageURL];
                
                [self.webView evaluateJavaScript:putImgAnswerUrl completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    
                }];
            }
        }];
    }];
}

#pragma mark -调用相机相册答主观题
- (void)selectImageWithNumber:(NSNumber *)number {
    ETTLog(@"%@",[NSThread currentThread]);
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    /**
     *  @author LiuChuanan, 17-03-23 17:02:57
     *  
     *  @brief 相册/相机导航栏颜色,模态出来的形势
     *
     *
     *  @since 
     */
    imagePicker.navigationController.navigationBar.barTintColor = [UIColor redColor];
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if ([number isEqual:@102]) {
        [imagePicker shouldAutorotate];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [imagePicker shouldAutorotate];
        }
    }
    
    if ([number isEqual:@103]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    self.imagePickerViewController = imagePicker;
}

#pragma mark UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        
        /**
         *  @author LiuChuanan, 17-03-23 17:02:57
         *  
         *  @brief 让相机/相册视图先消失,然后在上传照片,上传成功后传给h5
         *
         *
         *  @since 
         */        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self performSelector:@selector(resetIdleTimerDisabled) withObject:nil afterDelay:1.0];
            
            //移除后,销毁相机控制器
            self.imagePickerViewController = nil;
        }];
        
        /**
         *  @author LiuChuanan, 17-05-09 16:42:57
         *  
         *  @brief  mini1 拍照和取照片质量压缩比例调为 ,非mini1按照0.78压缩
         *
         *  branch  origin/bugfix/AIXUEPAIOS-1319
         *   
         *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
         * 
         *  @since 
         */
        
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *noCompressData = UIImageJPEGRepresentation(self.image, 1.0);
        NSLog(@"压缩之前大小 %fKB",noCompressData.length / 1024.0);
        
        NSData *data;
        
        NSString *deviceType = [NSString getDeviceType];
        if ([deviceType isEqualToString:iPadMini1]) 
        {
            data = UIImageJPEGRepresentation(self.image, 0.4);
            
            NSLog(@"mini1压缩之后大小 %fKB",data.length / 1024.0);
        } else
        {
            data = UIImageJPEGRepresentation(self.image, 0.78);
            
            NSLog(@"不是mini1压缩之后大小 %fKB",data.length / 1024.0);
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
        
        //上传图片
        [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:nil fileData:data mimeType:@"image/jpg" uploadImageRule:kStudentAnswerImage responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
            
            if (!error && responseDictionary) {
                NSArray *attachUrl = responseDictionary[@"attachUrl"];
                NSString *imageURL = [NSString stringWithFormat:@"http://%@%@",[AXPUserInformation sharedInformation].redisIp,attachUrl.firstObject];
                
                self.putImgAnswerUrl = [NSString stringWithFormat:@"putImgAnswerUrl('%@')",imageURL];
                
                [self.webView evaluateJavaScript:self.putImgAnswerUrl completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    
                    self.image = nil;
                }];
            }
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self performSelector:@selector(resetIdleTimerDisabled) withObject:nil afterDelay:1.0];
    }];
}



#pragma mark - 对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    
    return newImage;
}

-(NSData *)getSuitableImageFromOriginImage:(UIImage *)originImage
{
    CGSize whiteboardSize = CGSizeMake(kWIDTH - kAXPWhiteboardManagerWidth, kHEIGHT - 64);
    
    CGSize size = [ETTImageManager getImageSizeWithImage:originImage maxSize:whiteboardSize];
    
    CGFloat X = (whiteboardSize.width - size.width)/2;
    CGFloat Y = (whiteboardSize.height - size.height)/2;
    
    UIGraphicsBeginImageContext(whiteboardSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, whiteboardSize.width, whiteboardSize.height));
    
    [originImage drawInRect:CGRectMake(X, Y, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(image);
    
    return data;
}

- (BOOL)shouldAutorotate {
    return NO;
}

//返回按钮点击
- (void)backButtonDidClick {
    
    [self resetViewController];
    [self.navigationController popViewControllerAnimated:YES];
}

//提交按钮点击 (学生自己点的提交)
- (void)submitButtonDidClick {
    
    [ETTCoursewarePresentViewControllerManager sharedManager].isPushSubjectItem = NO;
    /**学生自己点击提交按钮应该做的事情
     1.判断学生的作答状态
     2.若答题了,将试卷变成公布答案状态
     3.若答题了,将作答信息提交到老师那边
     
     */
    //获得学生作答信息
    [self.webView evaluateJavaScript:@"getAnswerJson()" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        if(error){
            
        }else{
            
            //是否是在推试卷
            if (self.isPushTestPaper == NO) {//NO为推题
                
                if ([self.submitTips isEqualToString:@"有未作答的题目"]) {
                    [self presentAlertToCommit];
                } else {
                    [self pushSubmitButton];
                }
            } else {//YES为推试卷
                
                if ([self.unsubmitTips isEqualToString:@"都回答完了"]) {
                    [self pushSubmitButton];
                } else {
                    [self presentAlertToCommit];
                }
            }
        }
    }];
}


/**
 弹出alert来确认是否提交
 */
- (void)presentAlertToCommit {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"还有未作答的试题,确定提交吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //2.若答题了,将试卷变成公布答案状态
        [self pushSubmitButton];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//3.若答题了,将作答信息提交到老师那边
- (void)pushSubmitButton {
    
    //学生如果1题都没有作答的话  不让提交
    [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.submitButton setTitle:@"已提交" forState:UIControlStateNormal];
    self.submitButton.enabled = NO;
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"studentCommit"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //获得学生作答信息
    [self.webView evaluateJavaScript:@"getAnswerJson('true')" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
        //3.若答题了,将作答信息提交到老师那边
        [self commitStudentAnswerInfoToTeacher];
        
    }];
}

//显示提示框
- (void)showPromptViewWithString:(NSString *)string {
    
    ETTPromptView *promptView = [[ETTPromptView alloc]initPromptViewWithPromptString:string];
    promptView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    promptView.frame = CGRectMake(0, -50, 500, 50);
    promptView.centerX = self.view.centerX;
    [self.view addSubview:promptView];
    [self.view bringSubviewToFront:promptView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        promptView.center = CGPointMake(kWIDTH / 2, 30);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                promptView.center = CGPointMake(kWIDTH / 2, -50);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 animations:^{
                    [promptView removeFromSuperview];
                }];
            }];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //如果在拍照的过程中,监测到内存,先关闭
    if ([ETTBackToPageManager sharedManager].cameraOpenTimes == 0) 
    {
        [ETTBackToPageManager sharedManager].cameraOpenTimes = 1;
        [self.imagePickerViewController dismissViewControllerAnimated:YES completion:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备运行内存太小啦" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    } else
    {
        if (self.imagePickerViewController) 
        {
            [self.imagePickerViewController dismissViewControllerAnimated:YES completion:^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"可用运行内存不足，无法拍照。请稍后再试。" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
        }
        
        [ETTBackToPageManager sharedManager].cameraOpenTimes++;
        NSLog(@"调用相机由于内存警告闪退次数: %d",[ETTBackToPageManager sharedManager].cameraOpenTimes);
    }
}

//设置导航栏
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title = self.testPaperName;
    
    //左边返回试卷列表按钮 pop上个控制器
    UIButton *backButton = [UIButton new];
    [backButton setHidden:YES];
    backButton.frame = CGRectMake(15, 0, 80, 44);
    
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 50);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.backButton = backButton;
    
    //提交按钮
    UIButton *submitButton = [[UIButton alloc]init];
    CGFloat submitButtonWidth = 60;
    CGFloat submitButtonHeight = 44;
    
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.enabled = NO;
    submitButton.frame = CGRectMake(0, 0, submitButtonWidth, submitButtonHeight);
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitButton];
    self.submitButton = submitButton;
    
}

- (void)dealloc 
{
    [self resetViewController];
    
}



@end
