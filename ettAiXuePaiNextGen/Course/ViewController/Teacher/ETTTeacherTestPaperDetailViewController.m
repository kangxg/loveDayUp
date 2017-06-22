
//  ETTTestPaperDetailViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherTestPaperDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTURLUTF8Encoder.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTCheckAnswerDetailsViewController.h"
#import "ETTCoverView.h"
#import "ETTRedisBasisManager.h"
#import "ETTBackToPageManager.h"
#import "ETTScenePorter.h"
#import "ETTPushMProgressBarView.h"
#import "ETTLCAButton.h"
#import "AXPStudentSubjectViewController.h"
#pragma -mark 推试卷缓存数据
#import "ETTPushedTestPaperModel.h"
#import "ETTPushedTestPaperDataManager.h"

#import "ETTCoursewarePushAnimationView.h"
#import "ETTImageManager.h"
#import "CourseConst.h"
#import "ETTAnouncement.h"
#import "ETTGovernmentTask.h"

#import "ETTRestoreCommand.h"
#import "ETTPaperRestoreActor.h"
#import <UIImageView+WebCache.h>
@interface ETTTeacherTestPaperDetailViewController ()<WKUIDelegate,WKNavigationDelegate,ETTCoursewarePushAnimationViewDelegate,UIScrollViewDelegate>

{
    ETTCoursewarePushAnimationView *coursewarePushAnimationView;
    UIRefreshControl               *_refreshControll;
    ETTPushMProgressBarView        *_progressView;
    ETTLCAButton                   *_failedAndReloadButton;//加载失败重新加载按钮
    
}

@property (nonatomic,strong ) UIButton                            *pushTestPaperButton;

@property (nonatomic,strong ) UIView                              *rightContentView;

@property (nonatomic,strong ) UIButton                            *endAnswerButton;//结束作答按钮

@property (nonatomic,strong ) UIButton                            *testPaperStatisticsButton;//试卷统计按钮

@property (nonatomic,strong ) UIButton                            *backButton;//返回按钮

@property (nonatomic,strong ) UIButton                            *testPaperStatisticsBackButton;//试卷统计返回按钮

@property (nonatomic,strong ) UIButton                            *endPushButton;//结束推送按钮

@property (nonatomic, strong) WKWebView                           *webView;

@property (copy, nonatomic  ) NSString                            *urlString;//初始拼接参数的url

@property (copy, nonatomic  ) NSString                            *urlStr;//初始没拼接参数的url

@property (copy, nonatomic  ) NSString                            *afterH5UrlStr;

@property (copy, nonatomic  ) NSString                            *afterH5UrlString;

@property (assign, nonatomic) NSInteger                           submitCount;//已提交的人数

@property (copy, nonatomic  ) NSString                            *currentPaper;//试卷当前页

@property (copy, nonatomic  ) NSString                            *pushCurrentPaper;

@property (assign, nonatomic) BOOL                                isPushTestPaper;//推试卷

@property (assign, nonatomic) BOOL                                isClickTestPaperStatisticsButton;//试卷统计按钮是否被点击 默认NO

@property (assign, nonatomic) BOOL                                isClickEndAnswerButton;//是否点击了结束作答按钮

@property (nonatomic ,strong) NSMutableDictionary                 *classroomDict;

@property (strong, nonatomic) NSMutableArray                      *studentAnswerInfo;

@property (nonatomic ,strong) ETTCheckAnswerDetailsViewController *answerDetailVc;

@property (nonatomic, strong) UIButton                            *pushItemBackButton;//推单道题按钮的返回按钮 "返回"

@property (nonatomic, strong) UIButton                            *quickBackButton;//底下的黄色快捷返回按钮

@property (nonatomic, assign) BOOL                                isPushingItem;//推单道题

@property (strong, nonatomic) WKWebView                           *singItemWebView;//单道题webView

@property (assign, nonatomic) BOOL                                isSingleWebView;//推单道题webview

@property (assign, nonatomic) BOOL                                isWebView;//推试卷webview

@property (assign, nonatomic) BOOL                                isClickEndPushButton;//是否点击了结束推送按钮

@property (assign, nonatomic) BOOL                                isAppearBlank;//点击结束推送后是否出现空白

@property (copy, nonatomic)   NSString                            *pushedTestPaperId;//推送试卷的id 唯一值

/**
 *  @author LiuChuanan, 17-03-10 15:37:57
 *  
 *  @brief 增加一个属性变量,保存上个学生的jid,判断同一个学生有没有重复提交
 *
 *  @since 
 */

@property (copy, nonatomic)   NSString                            *studentLastJid;//上个学生的jid

@property (copy, nonatomic)   NSString                            *finishNum;//已提交的人数


@end


@implementation ETTTeacherTestPaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor redColor];
    [self setupWebView];
    
    self.submitCount                      = 0;
    self.isPushTestPaper                  = NO;
    self.isClickTestPaperStatisticsButton = NO;
    self.isClickEndAnswerButton           = NO;
    
    //老师接收学生作答信息通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(teacherGetStudentInfo:) name:kREDIS_COMMAND_TYPE_SCO_01 object:nil];
    
    [self setupNavBar];
    
    [ETTPushedTestPaperDataManager sharedManager];
    [ETTAnouncement reportGovernmentRestoreTask:self withState:ETTTASKOPERATIONSTATELOADCOMPLETE];
}


/**
 初始化webView
 */
- (void)setupWebView {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(didDragRefreshControl) forControlEvents:UIControlEventValueChanged];
    _refreshControll                 = refreshControl;
    
    WKWebView *webView               = [[WKWebView alloc]init];
    webView.UIDelegate               = self;
    webView.navigationDelegate       = self;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        
        webView.scrollView.delegate = self;
    }
    
    webView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    //webView.scrollView.scrollEnabled = false;
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:webView];
    self.webView = webView;
    
    //加载没有公布答案之前的url
    [self getUrlString];
    
    //网页加载进度条
    _progressView                    = [[ETTPushMProgressBarView alloc]init];
    _progressView.layer.cornerRadius = 1.0;
    _progressView.barBorderColor     = [UIColor blackColor];
    _progressView.barBorderWidth     = 0.5;
    _progressView.barFillColor       = kC2_COLOR;
    _progressView.barInnerPadding    = 0.0;
    _progressView.frame              = CGRectMake(10, 5, self.view.width - 20, 5);
    _progressView.hidden             = YES;
    [self.view addSubview:_progressView];
    
    //加载失败按钮
    _failedAndReloadButton                      = [[ETTLCAButton alloc]init];
    _failedAndReloadButton.frame                = CGRectMake(0, 0, 200, 200);
    _failedAndReloadButton.center               = self.view.center;
    [_failedAndReloadButton setTitle:@"加载失败,点击重新加载" forState:UIControlStateNormal];
    _failedAndReloadButton.titleLabel.textColor = [UIColor blackColor];
    _failedAndReloadButton.hidden               = YES;
    [_failedAndReloadButton addTarget:self action:@selector(reloadButtonDidClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_failedAndReloadButton];
    
    //单道题webView
    _singItemWebView                     = [[WKWebView alloc]initWithFrame:self.view.frame];
    _singItemWebView.UIDelegate          = self;
    _singItemWebView.navigationDelegate  = self;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        
        _singItemWebView.scrollView.delegate = self;
    }
    _singItemWebView.frame               = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    _singItemWebView.hidden              = true;
    [_singItemWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:_singItemWebView];
}

//获取没有公布答案之前的urlString
- (void)getUrlString {
    //加载没公布答案前的试卷h5页面
    self.urlStr                         = [NSString stringWithFormat:@"%@testPaper.html",[AXPUserInformation sharedInformation].paperRootUrl];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"testPaperId":self.testPaperId
                             };
    [[ETTNetworkManager sharedInstance]GETSign:self.urlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.urlString = [NSString stringWithFormat:@"%@?%@",self.urlStr,[self getParamsStringWithParams:responseDictionary]];
    }];
    
    if (self.urlString) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

//重新加载
- (void)reloadButtonDidClick:(ETTLCAButton *)button {
    [_webView reload];
    [_webView setHidden:NO];
    [button setHidden:YES];
}

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

//拖动刷新控件
- (void)didDragRefreshControl {
    [self.webView reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //主观题互批分数
    if ([ETTCoursewarePresentViewControllerManager sharedManager].markArray.count > 0) {
        NSArray *array = [ETTCoursewarePresentViewControllerManager sharedManager].markArray;
        
        for (NSInteger i = 0; i < [ETTCoursewarePresentViewControllerManager sharedManager].markArray.count; i++) {
            
            NSString *markJson       = [ETTJSonStringDictionaryTransformation getJsonStringWithDictionary:array[i]];
            NSString *submitMarkInfo = [NSString stringWithFormat:@"submitMarkInfo('[%@]')",markJson];
            
            [self.webView evaluateJavaScript:submitMarkInfo completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                
            }];
        }
        
        [[ETTCoursewarePresentViewControllerManager sharedManager].markArray removeAllObjects];
    }
    
    if ([ETTBackToPageManager sharedManager].isPushing) {
        
        if (![self.testPaperId isEqualToString:[ETTBackToPageManager sharedManager].testPaperID]) {
            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
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
 *  页面内容开始返回调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    ETTLog(@"页面内容开始返回");
    [_refreshControll endRefreshing];
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    ETTLog(@"加载完成的时候调用");
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  加载完成1s后从redis获取学生提交的答案
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self getStudentAnswerInfoFromRedis]; 
    });
}

- (void)delayMethod {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self setupNavBar];
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


/**
 内存消耗过大的时候调用
 
 @param webView webView
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView 
{   
    
    if (self.isClickEndPushButton) {
        self.isAppearBlank = YES;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        [self setupNavBar];
    }
    
    ETTLog(@"webView内存消耗过大");
}



#pragma mark- WKUIDelegate alert处理
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    completionHandler();
    
    
    NSDictionary *dict = [ETTJSonStringDictionaryTransformation jsonStringTodictionary:message];
    
    NSNumber *result = [dict objectForKey:@"result"];
    
    NSString *alertType = [NSString stringWithFormat:@"%@",result];
    
    /**
     *  @author LiuChuanan, 17-03-13 19:02:57
     *  
     *  @brief 统一处理后台返回的alert
     *
     *  @since 
     */
    
    [self p_handleTestPaperAlertWithType:alertType andMessage:dict];
    
}


/**
 跳转到查看详情控制器
 
 @param answerData <#answerData description#>
 */
-(void)pushToCheckAnswerDetailsVcWithData:(NSDictionary *)answerData
{
    
    ETTCheckAnswerDetailsViewController *vc = [[ETTCheckAnswerDetailsViewController alloc] initWithAnswerData:answerData classroomDict:self.classroomDict];
    
    vc.title = @"查看详情";
    
    self.answerDetailVc = vc;
    
    [self.navigationController pushViewController:self.answerDetailVc animated:YES];
}


//拼接字典key和value
- (NSString *)getParamsStringWithParams:(NSDictionary *)params {
    
    NSMutableArray *array = [NSMutableArray array];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSString *keyValueString = [NSString stringWithFormat:@"%@=%@",key,value];
        [array addObject:keyValueString];
        
    }];
    
    NSString *string = [array componentsJoinedByString:@"&"];
    
    return string;
}

//设置导航栏
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title                                   = self.navigationTitle;
    
    //左边返回试卷列表按钮 pop上个控制器
    UIButton *backButton                                        = [UIButton new];
    backButton.frame                                            = CGRectMake(15, 0, 80, 44);
    
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.imageEdgeInsets                                  = UIEdgeInsetsMake(5, 0, 5, 50);
    backButton.titleEdgeInsets                                  = UIEdgeInsetsMake(5, -30, 5, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    backButton.titleLabel.font                                  = [UIFont systemFontOfSize:17.0];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem                       = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.backButton                                             = backButton;
    
    //推单道题的返回按钮
    UIButton *pushItemBackButton                                = [UIButton new];
    pushItemBackButton.frame                                    = CGRectMake(15, 0, 80, 44);
    
    [pushItemBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [pushItemBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [pushItemBackButton setTitle:@"返回" forState:UIControlStateNormal];
    pushItemBackButton.imageEdgeInsets                          = UIEdgeInsetsMake(5, 0, 5, 50);
    pushItemBackButton.titleEdgeInsets                          = UIEdgeInsetsMake(5, -30, 5, 0);
    [pushItemBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushItemBackButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    pushItemBackButton.titleLabel.font                          = [UIFont systemFontOfSize:17.0];
    [pushItemBackButton addTarget:self action:@selector(pushItemBackButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.pushItemBackButton                                     = pushItemBackButton;
    
    //试卷统计返回按钮
    UIButton *testPaperStatisticsBackButton                     = [UIButton new];
    testPaperStatisticsBackButton.frame                         = CGRectMake(15, 0, 80, 44);
    
    [testPaperStatisticsBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [testPaperStatisticsBackButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [testPaperStatisticsBackButton setTitle:@"返回" forState:UIControlStateNormal];
    testPaperStatisticsBackButton.imageEdgeInsets               = UIEdgeInsetsMake(5, 0, 5, 50);
    testPaperStatisticsBackButton.titleEdgeInsets               = UIEdgeInsetsMake(5, -30, 5, 0);
    [testPaperStatisticsBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testPaperStatisticsBackButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    testPaperStatisticsBackButton.titleLabel.font               = [UIFont systemFontOfSize:17.0];
    /**
     *  @author LiuChuanan, 17-03-09 10:40:57
     *  
     *  @brief 试卷统计返回按钮的点击 点击后调用后台js方法  导航栏按钮的显示状态通过alert来显示控制
     *
     *  @since 
     */
    testPaperStatisticsBackButton.hidden                        = YES;
    
    
    [testPaperStatisticsBackButton addTarget:self action:@selector(testPaperStatisticsBackButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.testPaperStatisticsBackButton                          = testPaperStatisticsBackButton;
    
    //结束推送按钮
    UIButton *endPushButton                                     = [UIButton new];
    endPushButton.frame                                         = CGRectMake(15, 0, 120, 44);
    
    [endPushButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
    [endPushButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
    [endPushButton setTitle:@"结束推送" forState:UIControlStateNormal];
    endPushButton.imageEdgeInsets                               = UIEdgeInsetsMake(5, 0, 5, 50);
    endPushButton.titleEdgeInsets                               = UIEdgeInsetsMake(5, -10, 5, 0);
    endPushButton.enabled                                       = NO;
    [endPushButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [endPushButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    endPushButton.titleLabel.font                               = [UIFont systemFontOfSize:17.0];
    [endPushButton addTarget:self action:@selector(endPushButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.endPushButton                                          = endPushButton;
    
    //推试卷按钮
    UIButton *pushTestPaperButton                               = [UIButton new];
    CGFloat pushTestPaperButtonWidth                            = 60;
    CGFloat pushTestPaperButtonHeight                           = 44;
    [pushTestPaperButton setTitle:@"推试卷" forState:UIControlStateNormal];
    pushTestPaperButton.frame                                   = CGRectMake(0, 0, pushTestPaperButtonWidth, pushTestPaperButtonHeight);
    [pushTestPaperButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushTestPaperButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    pushTestPaperButton.titleLabel.font                         = [UIFont systemFontOfSize:17.0];
    [pushTestPaperButton addTarget:self action:@selector(pushTestPaperButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.pushTestPaperButton                                    = pushTestPaperButton;
    
    //右边容器 放推试卷 结束作答按钮
    UIView *rightContentView                                    = [[UIView alloc]init];
    rightContentView.frame                                      = CGRectMake(0, 0, 180, 44);
    self.rightContentView                                       = rightContentView;
    
    //试卷统计按钮
    UIButton *testPaperStatisticsButton                         = [[UIButton alloc]init];
    [testPaperStatisticsButton setTitle:@"试卷统计" forState:UIControlStateNormal];
    testPaperStatisticsButton.frame                             = CGRectMake(0, 0, 80, 44);
    [testPaperStatisticsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testPaperStatisticsButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    testPaperStatisticsButton.titleLabel.font                   = [UIFont systemFontOfSize:17.0];
    [testPaperStatisticsButton addTarget:self action:@selector(testPaperStatisticsButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightContentView addSubview:testPaperStatisticsButton];
    self.testPaperStatisticsButton                              = testPaperStatisticsButton;
    
    //结束作答按钮
    UIButton *endAnswerButton                                   = [[UIButton alloc]init];
    [endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
    endAnswerButton.enabled                                     = YES;
    endAnswerButton.frame                                       = CGRectMake(90, 0, 110, 44);
    endAnswerButton.enabled                                     = NO;
    [endAnswerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [endAnswerButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    testPaperStatisticsButton.titleLabel.font                   = [UIFont systemFontOfSize:17.0];
    [endAnswerButton addTarget:self action:@selector(endAnswerButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightContentView addSubview:endAnswerButton];
    self.endAnswerButton                                        = endAnswerButton;
    
}

//返回到试卷列表按钮的事件方法
- (void)backButtonDidClick {
    
    [[ETTScenePorter shareScenePorter]removeGurad:self.EVGuardModel];
    [ETTCoursewarePresentViewControllerManager sharedManager].isPushingTestPaper = YES;
    [ETTCoursewarePresentViewControllerManager sharedManager].commitCount        = self.studentAnswerInfo.count;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)bindingViewReturnCallback
{
    
}

//推单道题返回按钮的点击
- (void)pushItemBackButtonDidClick {
    //隐藏webView
    self.webView.hidden                            = NO;
    self.singItemWebView.hidden                    = YES;
    
    
    self.navigationItem.title                      = self.navigationTitle;
    [self enterRegistrationQuickBack:YES];
    [ETTBackToPageManager sharedManager].isPushing = YES;
    
    self.navigationItem.leftBarButtonItem          = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    self.navigationItem.rightBarButtonItem = nil;
    
    if (self.urlString) {
        
        [ETTBackToPageManager sharedManager].hasHidePushBtnMethod = YES;
        [self.webView evaluateJavaScript:@"hidePushBtn(1)" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
            
        }];
        
    }
    [self bindingViewReturnCallback];
}

//在本页面内的返回
- (void)quickBackButtonAction {
    
    [self.webView setHidden:YES];
    [self.singItemWebView setHidden:NO];
    
    /**
     *  @author LiuChuanan, 17-03-10 17:12:57
     *  
     *  @brief 试卷统计页面隐藏 alert 处理  导航栏已提交的人数通过js返回的结果显示
     *
     *  @since 
     */
    self.navigationItem.title             = [NSString stringWithFormat:@"已提交 %@",self.finishNum];
    [UIView animateWithDuration:0.5 animations:^{
        self.quickBackButton.hidden           = YES;
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pushItemBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.endAnswerButton];
}

//推试卷按钮被点击
- (void)pushTestPaperButtonDidClick {
    
    /**
     *  @author LiuChuanan, 17-03-14 19:02:57
     *  
     *  @brief 推送之前把提交人数先清空
     *
     *  @since 
     */
    self.finishNum = nil;
    
    self.isClickEndPushButton = NO;
    
    self.isWebView            = YES;
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  每次推送时把学生的账号信息清除
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    self.studentLastJid       = nil;
    
    [self showCoverView];
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
    /**
     点击推试卷按钮要处理的事情:
     1.调用js函数,将h5页面更改  隐藏h5上的推题按钮
     2.判断是有几道题
     3.底部快捷返回要弹出
     4.间隔5秒接收学生发过来的交卷信息
     
     处理推单道题的快捷返回
     */
    
    //推试卷不需要传itemIds,推题的时候需要传itemIds
    
    //1.调用js函数,将h5页面更改  隐藏h5上的推题按钮
    self.pushId = [ETTRedisBasisManager getTime];
    
    [ETTCoursewarePresentViewControllerManager sharedManager].pushId = self.pushId;
    self.afterH5UrlStr = [NSString stringWithFormat:@"%@taskTestPager.html",[AXPUserInformation sharedInformation].paperRootUrl];
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"testPaperId":self.testPaperId,
                             @"classroomId":userInformation.classroomId,
                             @"userName":userInformation.userName,
                             @"userPhoto":userInformation.userPhoto,
                             @"userType":@"1",
                             @"pushId":self.pushId,
                             @"courseId":self.courseId
                             };
    [[ETTNetworkManager sharedInstance]GETSign:self.afterH5UrlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.afterH5UrlString = [NSString stringWithFormat:@"%@?%@",self.afterH5UrlStr,[self getParamsStringWithParams:responseDictionary]];
    }];
    
    if (self.afterH5UrlString) {
        [ETTBackToPageManager sharedManager].hasHidePushBtnMethod = NO;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.afterH5UrlString]]];
    }
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    /*
     新增
     */
    self.pushedTestPaperId = [NSString stringWithFormat:@"pushedTestPaperId_%@",[ETTRedisBasisManager getTime]];
    
    
    NSDictionary *userInfo = @{@"CO_04_state":@"CO_04_state1",
                               @"pushId":self.pushId,
                               @"testPaperId":self.testPaperId,
                               @"courseId":self.courseId,
                               @"itemIds":@"1",
                               @"testPaperName":self.testPaperName,
                               @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl,
                               
                               @"pushedTestPaperId":self.pushedTestPaperId  //新增的一个字段  课堂重连的时候会用到
                               };
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_04",
                            @"userInfo":userInfo,
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_04",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    /*
       Epic-KXG-AIXUEPAIOS-1141
    */
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    [task setExtensionData:@"pushPaper" value:[NSNumber numberWithBool:YES]];
    [task setExtensionData:@"title" value:[ETTScenePorter shareScenePorter].EDViewRecordManager.EDTitleRecord];
    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:theUserInfo];
    
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    //NSLog(@"成功发送消息%@",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATESTART];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];

                }else{
                    
                    NSLog(@"发送消息%@失败！",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];

                }
            }];
        }else {
            ETTLog(@"推试卷错误原因:%@",error);
            [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
            [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
        [self.endAnswerButton setEnabled:YES];
        [self.endAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
    [self.navigationItem setTitle:@"已提交 0"];
    
    self.isPushTestPaper                             = YES;
    [self enterRegistrationQuickBack:YES];
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  以推送id为键建立映射表,判断是推试卷还是推试题
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"推试题"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setBool:self.isPushTestPaper forKey:@"推试卷"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //设置推送状态
    [ETTBackToPageManager sharedManager].isPushing   = YES;
    
    [ETTBackToPageManager sharedManager].testPaperID = self.testPaperId;
    
    /*
     新增:
     推试卷的缓存数据
     */
    
    //存储每次试卷推送的数据
    NSString *testPaperId          = self.testPaperId;
    NSString *itemId               = @"";
    NSString *pushedId             = [NSString stringWithFormat:@"pushedId_%@",[ETTNetworkManager currentMsTimeString]];
    ETTPushedTestPaperModel *model = [self pushTestPaperModelWith:itemId testPaperId:testPaperId pushedId:pushedId testPaperUrlString:self.urlString];
    //[[ETTPushedTestPaperDataManager sharedManager]insertData:model];
}

-(void)enterRegistrationQuickBack:(BOOL)isBack
{
    if (isBack)
    {
        [[ETTScenePorter shareScenePorter] enterRegistration:self.EVGuardModel];
        
    }
    else
    {
        [[ETTScenePorter shareScenePorter] cancellationRegistration:self.EVGuardModel];
    }
    
}

#pragma -mark 老师收取学生的作答信息
/**
 老师获取学生作答信息
 
 @param notify 
 */
- (void)teacherGetStudentInfo:(NSNotification *)notify {
    
    /**
     *  @author LiuChuanan, 17-03-10 16:37:57
     *  
     *  @brief 老师收取学生答案两层过滤:第一层判断pushId;第二层判断学生jid
     *
     *  @since 
     */
    
    if (!self.isClickEndPushButton) 
    {
        //如果点击了结束推送按钮,结束本次答案的收取
        NSDictionary *dict          = notify.object;
        NSDictionary *userInfo      = [dict objectForKey:@"userInfo"];
        NSString *pushedTestPaperId = [userInfo objectForKey:@"pushedTestPaperId"];
        
        //第一层过滤 判断每次推送的唯一值
        if ([self.pushedTestPaperId isEqualToString:pushedTestPaperId]) 
        {
            NSString *answerJson     = [userInfo objectForKey:@"answerJson"];
            NSDictionary *answerDict = [ETTJSonStringDictionaryTransformation jsonStringTodictionary:answerJson];
            NSString *jid            = [answerDict objectForKey:@"jid"];
            
            //第二层过滤 判断同一个学生有没有重复提交 这次推送的jid和上次的是否一样 一样的话说明同一个人交了两次 重复数据丢弃
            if (![jid isEqualToString:_studentLastJid]) 
            {       
                //每次提交过来的不是同一个学生,执行下面方法
                self.studentLastJid = jid;
                [self.studentAnswerInfo addObject:answerJson];
                
                if (self.studentAnswerInfo.count > 0) 
                {
                    //向h5提交学生的作答信息
                    NSString *putAnswerJson = [NSString stringWithFormat:@"putAnswerJson(1,'[%@]')",answerJson];
                    
                    //推单道题
                    if (_isPushingItem) 
                    {
                        [self.singItemWebView evaluateJavaScript:putAnswerJson completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                            
                            //调用js方法
                            if (!error) 
                            {
                                
                            } else
                            {
                                NSLog(@"%@",error.description);
                            }
                        }];
                    } else 
                    {
                        //推试卷
                        [self.webView evaluateJavaScript:putAnswerJson completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                            
                            //调用js方法
                            if (!error) 
                            {
                                
                            } else
                            {
                                NSLog(@"%@",error.description);
                            }
                        }];
                    }
                }
            } else 
            {
                NSLog(@"有同学答案重复提交了,丢弃");
            }
        }
    } else
    {
        NSLog(@"本次推送已经结束了,答案不会收取了");
    }
}
#pragma mark 
#pragma mark  -------------快速返回单题推送------------
-(BOOL)donotDisturb
{
    return  !self.singItemWebView.hidden;
}
-(void)returnBindingRoomView: (UIView *)view
{
    [[ETTScenePorter shareScenePorter]donotDisturbBackIntoTheRoom:self.EVGuardModel withView:self.singItemWebView];
    if (view != self.singItemWebView )
    {
        return;
    }
    
    if (!self.singItemWebView.superview)
    {
        [self.view addSubview:self.singItemWebView];
    }
    else
    {
        if (self.singItemWebView.hidden)
        {
            self.singItemWebView.hidden = false;
        }
    }
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.pushItemBackButton];
    [self.endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
    [self.endAnswerButton setEnabled:YES];
    [self.endAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
    
    /**
     *  @author LiuChuanan, 17-03-13 19:12:57
     *  
     *  @brief 试卷统计页面隐藏 alert 处理  导航栏已提交的人数通过js返回的结果显示 页面内的返回
     *
     *  @since 
     */
    
    if (self.finishNum == nil || [self.finishNum isEqualToString:@""]) 
    {
        self.navigationItem.title = @"已提交 0";
    } else
    {
        self.navigationItem.title = [NSString stringWithFormat:@"已提交 %@",self.finishNum];
    }
    
}

#pragma mark -推送试卷数据模型
- (ETTPushedTestPaperModel *)pushTestPaperModelWith:(NSString *)itemId testPaperId:(NSString *)testPaperId pushedId:(NSString *)pushedId testPaperUrlString:(NSString *)testPaperUrlString
{
    ETTPushedTestPaperModel *model = [[ETTPushedTestPaperModel alloc]init];
    model.itemId                   = itemId;
    model.testPaperId              = testPaperId;
    model.pushedId                 = pushedId;
    model.testPaperUrlString       = testPaperUrlString;
    return model;
}


//生成from 到 to的随机数 包括from不包括to
-(int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from + 1)));
}



#pragma mark -弹出浮层
- (void)showCoverView {
    
    int randow                                  = [self getRandomNumber:1 to:2];
    
    coursewarePushAnimationView                 = [[ETTCoursewarePushAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) andTitle:@"正在同步中..." andAnimationTime:randow];
    coursewarePushAnimationView.backgroundColor = [UIColor whiteColor];
    coursewarePushAnimationView.delegate        = self;
    [self.view addSubview:coursewarePushAnimationView];
}

#pragma mark coursewarePushAnimationViewDelegate
- (void)removeCoursewarePushAnimationView {
    [coursewarePushAnimationView removeFromSuperview];
}

#pragma mark 试卷统计按钮的点击
//试卷统计按钮被点击
- (void)testPaperStatisticsButtonDidClick {
    
    /**
     *  @author LiuChuanan, 17-03-09 11:02:57
     *  
     *  @brief 试卷统计按钮的点击 点击后调用后台js方法  导航栏按钮的显示状态通过alert来显示控制
     *
     *  @since 
     */
    NSLog(@"试卷统计按钮的点击  统计页面出现: 调用顺序1");
    
    [self.webView evaluateJavaScript:@"showStatisticsPage(1)" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
        if (error) 
        {
            NSLog(@"%@",error.description);
        } else
        {
            NSLog(@"调用js showStatisticsPage显示成功: 调用顺序3");
            
        }
    }];
}

#pragma mark 试卷统计返回按钮的点击
//试卷统计返回按钮的点击
- (void)testPaperStatisticsBackButtonDidClick {
    
    /**
     *  @author LiuChuanan, 17-03-09 10:32:57
     *  
     *  @brief 试卷统计返回按钮的点击 点击后调用后台js方法  导航栏按钮的显示状态通过alert来显示控制
     *
     *  @since 
     */
    
    NSLog(@"试卷统计返回按钮的点击  统计页面隐藏: 调用顺序1");
    
    [self.webView evaluateJavaScript:@"showStatisticsPage(2)" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
        if (error) 
        {
            NSLog(@"%@",error);
        } else
        {
            NSLog(@"调用js showStatisticsPage隐藏成功: 调用顺序3");
        }
        
    }];
}

#pragma mark 结束作答按钮被点击
//结束作答按钮被点击
- (void)endAnswerButtonDidClick {
    
    self.isClickEndAnswerButton         = YES;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
    NSDictionary *userInfo              = [NSDictionary dictionary];
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    if (self.isPushTestPaper ==YES) {//推试卷
        userInfo = @{@"CO_04_state":@"CO_04_state2",
                     @"jid":userInformation.jid,
                     @"testPaperId":self.testPaperId,
                     @"classroomId":userInformation.classroomId,
                     @"userName":userInformation.userName,
                     @"userPhoto":userInformation.userPhoto,
                     @"userType":@"1",
                     @"pushId":self.pushId,
                     @"courseId":self.courseId,
                     @"itemIds":@"1"
                     };
    } else {//推试题
        userInfo = @{@"CO_04_state":@"CO_04_state2",
                     @"jid":userInformation.jid,
                     @"testPaperId":self.testPaperId,
                     @"classroomId":userInformation.classroomId,
                     @"userName":userInformation.userName,
                     @"userPhoto":userInformation.userPhoto,
                     @"userType":@"1",
                     @"pushId":self.pushId,
                     @"courseId":self.courseId,
                     @"itemIds":self.itemIds
                     };
    }
    
    self.classroomDict = @{@"state":@"13",@"pushId":self.pushId}.mutableCopy;
    
    /**点击结束作答应该做的事情:
     
     1.老师端按钮状态的显示
     2.h5页面变成公布答案状态
     3.老师把结束作答信息推送到学生
     
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.endPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.endPushButton setEnabled:YES];
        
    });
    
    //老师推的是单道题
    if (self.isPushingItem) {
        //2.h5页面变成公布答案状态
        [self.singItemWebView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable handlder, NSError * _Nullable error) {
            
            //1.结束作答点击之后左边变成结束推送
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.endPushButton];
            [self.endAnswerButton setTitle:@"已公布答案" forState:UIControlStateNormal];
            [self.endAnswerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.endAnswerButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
            
        }];
    } else {
        //2.h5页面变成公布答案状态
        [self.webView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable handlder, NSError * _Nullable error) {
            
            //1.结束作答点击之后左边变成结束推送
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.endPushButton];
            [self.endAnswerButton setTitle:@"已公布答案" forState:UIControlStateNormal];
            [self.endAnswerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.endAnswerButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
            
        }];
    }
    
    //3.老师把结束作答信息推送到学生,让学生做出相应操作
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_04",
                            @"userInfo":userInfo
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_04",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    [task setExtensionData:@"pushPaper" value:[NSNumber numberWithBool:self.isPushTestPaper]];
    [task setExtensionData:@"title" value:[ETTScenePorter shareScenePorter].EDViewRecordManager.EDTitleRecord ];
    [task setExtensionData:@"pushTestPaperId" value:self.pushedTestPaperId];
    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:theUserInfo];
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    //NSLog(@"成功发送消息%@",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATESTART];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT];
                }
            }];
            
        }else {
            ETTLog(@"试卷结束作答错误原因%@",error);
            [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
            [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT];
        }
    }];
}

#pragma mark 结束推送按钮的点击
//结束推送按钮被点击
- (void)endPushButtonDidClick {
    
    self.navigationItem.rightBarButtonItem = nil;
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  结束推送后,将是推试卷还是推试题置为NO
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"推试题"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"推试卷"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"pushedTestPaperId" forKey:@""];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /**
     *  @author LiuChuanan, 17-03-10 17:12:57
     *  
     *  @brief 结束推送后把jid清空内容
     *
     *
     *  @since 
     */
    
    self.studentLastJid       = nil;
    
    /**
     *  @author LiuChuanan, 17-03-10 17:12:57
     *  
     *  @brief 导航栏已提交的人数通过js返回的结果显示 结束推送后置为nil
     *
     *  @since 
     */
    self.finishNum            = nil;
    
    /*
     老师这边翻页的时候让pushedTestPaperId置为nil,也是让老师停止收学生的作答信息
     */
    
    self.pushedTestPaperId    = nil;
    
    self.isClickEndPushButton = YES;
    
    [self getUrlString];
    
    
    //上传学生试卷答题信息 归档
    [self updateAnswerInfo];
    
    [ETTBackToPageManager sharedManager].testPaperID                             = nil;
    
    
    [ETTCoursewarePresentViewControllerManager sharedManager].isPushingTestPaper = NO;
    self.isClickEndAnswerButton                                                  = NO;
    
    self.answerDetailVc                                                          = nil;
    
    /**结束推送要做的事情:
     1.试卷置为初始状态 
     2.将这个状态传给学生,让学生端显示返回按钮
     
     */
    
    if (self.isPushingItem) {
        [self.webView setHidden:NO];
        [self.singItemWebView setHidden:YES];
        
    }
    
    self.isPushTestPaper = NO;
    self.isPushingItem   = NO;
    
    [self setupNavBar];
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    NSDictionary *userInfo = @{@"CO_04_state":@"CO_04_state5"};
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_04",
                            @"userInfo":userInfo
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_04",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    
    NSString *messageJSON     = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        
        if (!error) {
            
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    //NSLog(@"成功发送消息%@",dict);
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                }
            }];
            
        } else {
            
            ETTLog(@"老师试卷奖励错误原因:%@",error);
            
        }
    }];
    
    [[ETTScenePorter shareScenePorter] removeTheBindingViewToGuardModel:self.EVGuardModel withView:self.singItemWebView];
    
    [self enterRegistrationQuickBack:false];
    
    //更改结束推送
    [[ETTBackToPageManager sharedManager] endPushing];
    
    NSMutableArray *array = [[ETTPushedTestPaperDataManager sharedManager]selectAllData];
    
    ETTLog(@"%@",array);
    
    [[ETTPushedTestPaperDataManager sharedManager]deleteAllData];
    
    /**
     *  @author LiuChuanan, 17-06-01 10:42:57
     *  
     *  @brief  结束推送后,情况状态
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    ETTGovRestoreWorkTask * task = [[ETTGovRestoreWorkTask alloc]initTask:ETTDELRESTOREACACHIVE];
    [ETTAnouncement reportGovernmentTask:task withType:0 withEntity:self];
    
}


/**
 上传作答信息
 */
- (void)updateAnswerInfo {
    
    if (self.studentAnswerInfo.count > 0) {
        
        NSDictionary *dict    = [NSDictionary dictionary];
        
        NSMutableArray *array = [NSMutableArray array];
        
        if (self.studentAnswerInfo.count > 0) {
            for (NSInteger i = 0; i < self.studentAnswerInfo.count; i++) {
                NSDictionary *dict = [ETTJSonStringDictionaryTransformation jsonStringTodictionary:self.studentAnswerInfo[i]];
                [array addObject:dict];
            }
        }
        
        if (_isPushTestPaper) {
            dict = @{@"jid":[AXPUserInformation sharedInformation].jid,
                     @"userName":[AXPUserInformation sharedInformation].userName,
                     @"classroomId":[AXPUserInformation sharedInformation].classroomId,
                     @"courseId":self.courseId,
                     @"testPaperId":self.testPaperId,
                     @"pushType":@"1",
                     @"answerList":array};
        } else {
            dict = @{@"jid":[AXPUserInformation sharedInformation].jid,
                     @"userName":[AXPUserInformation sharedInformation].userName,
                     @"classroomId":[AXPUserInformation sharedInformation].classroomId,
                     @"courseId":self.courseId,
                     @"testPaperId":self.testPaperId,
                     @"pushType":@"2",
                     @"answerList":array};
        }
        
        if ([NSJSONSerialization isValidJSONObject:dict]) {
            
            NSData *testPaperData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
            
            NSString *urlStr      = [NSString stringWithFormat:@"http://%@/ettschoolmitm/uploadfile.php",[AXPUserInformation sharedInformation].redisIp];
            
            [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:nil fileData:testPaperData mimeType:@"text/json" uploadImageRule:kTeacherTestPaperEncode responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
                
                if (!error &&responseDictionary) {
                    
                    [self.studentAnswerInfo removeAllObjects];
                }
            }];
        }
    }
}


- (NSMutableArray *)studentAnswerInfo {
    if (_studentAnswerInfo == nil) {
        _studentAnswerInfo = [NSMutableArray array];
    }
    return _studentAnswerInfo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


-(void)pushPaperItem
{
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    /**
     *  @author LiuChuanan, 17-03-14 19:02:57
     *
     *  @brief 推送之前把提交人数先清空
     *
     *  @since
     */
    self.finishNum                        = nil;
    
    //是否点击了结束推送按钮
    self.isClickEndPushButton             = NO;
    self.isClickTestPaperStatisticsButton = NO;
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  每次推送时把学生的账号信息清除
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    self.studentLastJid                   = nil;
    
    [self showCoverView];
    /**老师推单道题应该做的事情
     1.首先获取相应题目的itemids
     2.更改老师这边的h5显示 变成单道题统计状态
     3.更改导航栏标题显示
     4.更改右边按钮的显示
     
     */
    //3.更改导航栏标题显示
    self.navigationItem.title              = @"已提交 0";
    //4.更改右边按钮的显示
    self.pushTestPaperButton.hidden        = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
    self.testPaperStatisticsButton.hidden  = YES;
    self.isPushTestPaper                   = NO;
    self.isPushingItem                     = YES;
    
    self.isSingleWebView                   = YES;
    
    
    //1.首先获取相应题目的itemids
 //  self.itemIds                           = [message[@"data"] objectForKey:@"itemIds"];
    
    //redis推送推题 获得单个题的itemIds
    /* 时间戳 精确到秒*/
    NSString *time                         = [ETTRedisBasisManager getTime];
    self.pushId                            = time;
    
    
    /*
     新增
     */
    self.pushedTestPaperId = [NSString stringWithFormat:@"pushedTestPaperId_%@",[ETTRedisBasisManager getTime]];
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  存储每次推送的id,是否结束作答,结束推送以推送id为键建立映射表
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    [[NSUserDefaults standardUserDefaults]setObject:self.pushedTestPaperId forKey:@"pushedTestPaperId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    /**
     *  @author LiuChuanan, 17-05-31 16:42:57
     *  
     *  @brief  以推送id为键建立映射表,判断是推试卷还是推试题
     *
     *  branch  origin/bugfix/TestPaperDataHandle-1141
     *   
     *  Epic    origin/bugfix/Epic-KXG-AIXUEPAIOS-1141
     * 
     *  @since 
     */
    [[NSUserDefaults standardUserDefaults]setBool:self.isPushingItem forKey:@"推试题"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"推试卷"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSDictionary *userInfo = @{@"CO_04_state":@"CO_04_state1",
                               @"pushId":self.pushId,
                               @"testPaperId":self.testPaperId,
                               @"courseId":self.courseId,
                               @"itemIds":self.itemIds,
                               @"testPaperName":self.testPaperName,
                               @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl,
                               @"pushedTestPaperId":self.pushedTestPaperId
                               };
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_04",
                            @"userInfo":userInfo
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_04",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    [task setExtensionData:@"pushPaper" value:[NSNumber numberWithBool:false]];
    [task setExtensionData:@"title" value:[ETTScenePorter shareScenePorter].EDViewRecordManager.EDTitleRecord ];
    [task setExtensionData:@"pushTestPaperId" value:self.pushedTestPaperId];
    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:theUserInfo];
    
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    
    
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    //NSLog(@"成功发送消息%@",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATESTART];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT];
                }
            }];
        }else {
            ETTLog(@"推试卷错误原因:%@",error);
            [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
            [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT];
        }
    }];
    
    [ETTBackToPageManager sharedManager].testPaperID = self.testPaperId;
    
    //2.更改老师这边的h5显示 变成单道题统计状态
    
    self.afterH5UrlStr = [NSString stringWithFormat:@"%@taskTestPager.html",[AXPUserInformation sharedInformation].paperRootUrl];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"testPaperId":self.testPaperId,
                             @"classroomId":userInformation.classroomId,
                             @"userName":userInformation.userName,
                             @"userPhoto":userInformation.userPhoto,
                             @"userType":@"1",
                             @"pushId":self.pushId,
                             @"courseId":self.courseId,
                             @"itemIds":self.itemIds
                             };
    [[ETTNetworkManager sharedInstance]GETSign:self.afterH5UrlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.afterH5UrlString = [NSString stringWithFormat:@"%@?%@",self.afterH5UrlStr,[self getParamsStringWithParams:responseDictionary]];
    }];
    
    if (self.afterH5UrlString) {
        //这个是推单道题
        if (self.isPushingItem) {
            //这个网页没有hidePushBtn这个方法
            [ETTBackToPageManager sharedManager].hasHidePushBtnMethod = NO;
            
            [self.webView setHidden:YES];
            
            [[ETTScenePorter shareScenePorter] bindingViewToGuardModel:self.EVGuardModel withView:self.singItemWebView];
            [self.singItemWebView setHidden:NO];
            
            [self.singItemWebView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.afterH5UrlString]]];
        } else {//推试卷
            [self.webView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.afterH5UrlString]]];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
        [self.endAnswerButton setEnabled:YES];
        [self.endAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    });
    
    //设置推单道题按钮的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pushItemBackButton];
    
    //保存推送单道题数据
    NSString *itemId      = self.itemIds;
    NSString *testPaperId = self.testPaperId;
    NSString *pushedId    = [NSString stringWithFormat:@"pushedId_%@",[ETTNetworkManager currentMsTimeString]];
    //ETTPushedTestPaperModel *model = [self pushTestPaperModelWith:itemId testPaperId:testPaperId pushedId:pushedId];
    //[[ETTPushedTestPaperDataManager sharedManager]insertData:model];
}
/**
 *  @author LiuChuanan, 17-03-13 19:02:57
 *
 *  @brief 统一处理后台返回的alert
 *
 *  @since
 */
- (void)p_handleTestPaperAlertWithType:(NSString *)alertType andMessage:(NSDictionary *)message
{
    //推单道题
    if ([alertType isEqualToString:pushSingleItem])
    {
       self.itemIds                           = [message[@"data"] objectForKey:@"itemIds"];
       [self pushPaperItem];
    }
    
    //老师这边自动翻页页码
    if ([alertType isEqualToString:getCurrentPage]) {
        
        
        NSString *currentPaper = [NSString stringWithFormat:@"%@",[[message objectForKey:@"data"]objectForKey:@"itemIndex"]];
        /**
         *  @author LiuChuanan, 17-03-13 15:55:57
         *  
         *  @brief 老师正在收取答案的过程中,滑动页面  上次滑动的currentPaper不在记录
         *
         *  @since 
         */
        
        /* 时间戳 精确到秒*/
        NSString *time                      = [ETTRedisBasisManager getTime];
        AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
        
        NSDictionary *userInfo              = [NSDictionary dictionary];
        
        if (self.isPushTestPaper == YES) {//推试卷
            userInfo = @{@"CO_04_state":@"CO_04_state3",
                         @"currentPaper":currentPaper,
                         @"jid":userInformation.jid,
                         @"testPaperId":self.testPaperId,
                         @"itemIds":@"1",
                         @"classroomId":userInformation.classroomId,
                         @"userName":userInformation.userName,
                         @"userPhoto":userInformation.userPhoto,
                         @"userType":@"1",
                         @"pushId":self.pushId,
                         @"courseId":self.courseId,
                         @"testPaperName":self.testPaperName,
                         @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl
                         };
        } else {//推试题
            userInfo = @{@"CO_04_state":@"CO_04_state3",
                         @"currentPaper":currentPaper,
                         @"jid":userInformation.jid,
                         @"testPaperId":self.testPaperId,
                         @"itemIds":self.itemIds,
                         @"classroomId":userInformation.classroomId,
                         @"userName":userInformation.userName,
                         @"userPhoto":userInformation.userPhoto,
                         @"userType":@"1",
                         @"pushId":self.pushId,
                         @"courseId":self.courseId,
                         @"testPaperName":self.testPaperName,
                         @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl
                         };
        }
        
        NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                @"to":@"ALL",
                                @"from":[AXPUserInformation sharedInformation].jid,
                                @"type":@"CO_04",
                                @"userInfo":userInfo
                                };
        
        NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
        
        NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
        NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        NSDictionary *theUserInfo = @{
                                      @"type":@"CO_04",
                                      @"theUserInfo":dict
                                      };
        NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
        [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
            if (!error) {
                
                [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                    if (!error) {
                        //NSLog(@"成功发送消息%@",dict);
                    }else{
                        NSLog(@"发送消息%@失败！",dict);
                    }
                }];
                
            }else {
                ETTLog(@"试卷结束作答错误原因%@",error);
            }
        }];
    }
    
    //试卷中主观题查看详情
    if ([alertType isEqualToString:checkAnswerDetail]) {
        
        // 查看详情--跳转到查看详情控制器
        [self pushToCheckAnswerDetailsVcWithData:message];
    }
    
    /**
     *  @author LiuChuanan, 17-03-10 17:32:57
     *  
     *  @brief 每次向h5提交答案后都会弹110 alert  结束推送后 将此变量置为nil
     *
     *  @since 
     */
    
    if ([alertType isEqualToString:getCommitedStudentCount]) {
        
        //已提交的人数
        NSString *finishNum = [[message objectForKey:@"data"]objectForKey:@"finishNum"];
        NSLog(@"%@",finishNum);
        
        /**
         *  @author LiuChuanan, 17-03-13 16:40:57
         *  
         *  @brief 返回的类型 进行类型强转;  判断是否点击了结束推送按钮
         *
         *  @since 
         */
        
        self.finishNum = [NSString stringWithFormat:@"%@",finishNum];
        
        //点击了结束推送按钮
        if (self.isClickEndPushButton == YES) 
        {
            self.navigationItem.title = self.navigationTitle;
            
        } else
        {
            //上传答案成功后 更新导航栏标题
            if (self.isClickTestPaperStatisticsButton == YES) 
            {
                self.navigationItem.title = @"试卷统计";
            } else 
            {
                self.navigationItem.title = [NSString stringWithFormat:@"已提交 %@",self.finishNum];
            }
            
        }
        
    }
    
    //答对奖励
    if ([alertType isEqualToString:rewardToRightAnswer]) 
    {
        if (message && message != nil) 
        {
            [self p_pushRewardcommandWithMessage:message];
            
            // 发送一个通知让studentManagerVC将ETTClasssModel里的ETTUserClassModel的rewardScore++ 更改人:徐梅娜
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeRewardScoreKey object:nil userInfo:[NSDictionary dictionaryWithObject:!isEmptyString([[message objectForKey:@"data"]objectForKey:@"userStr"])?[[message objectForKey:@"data"]objectForKey:@"userStr"]:@"" forKey:@"jid"]]; 
        }
    }
    
    //页面加载完成112
    if ([alertType isEqualToString:finishLoad]) {
        //如果正在推送的话  推试卷按钮要隐藏  推试题按钮要隐藏
        if ([ETTBackToPageManager sharedManager].isPushing )
        {
            
            if (self.isPushingItem || self.isPushTestPaper) {
                
            } else {
                [self.webView evaluateJavaScript:@"hidePushBtn(1)" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                    
                }];
            }
        }
    }
    
    /*
     LiuChuanan 2017.3.7
     新增部分 试卷统计页面是否显示
     */
    //统计页面显示
    if ([alertType isEqualToString:showStatisticsPaper]) {
        NSLog(@"试卷统计页面显示: 调用顺序2");//release 去掉log
        
        /**
         *  @author LiuChuanan, 17-03-09 13:42:57
         *  
         *  @brief 试卷统计页面显示 alert 处理
         *
         *  @since 
         */
        
        self.isClickTestPaperStatisticsButton     = YES;
        self.testPaperStatisticsBackButton.hidden = NO;
        self.navigationItem.title                 = @"试卷统计";
        self.navigationItem.rightBarButtonItem    = nil;
        
        self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc]initWithCustomView:self.testPaperStatisticsBackButton];
        
    }
    
    
    //统计页面隐藏
    if ([alertType isEqualToString:hideStatisticsPaper]) {
        NSLog(@"试卷统计页面隐藏: 调用顺序2");
        
        /**
         *  @author LiuChuanan, 17-03-09 13:02:57
         *  
         *  @brief 试卷统计页面隐藏 alert 处理
         *
         *  @since 
         */
        
        self.isClickTestPaperStatisticsButton  = NO;
        
        if (self.isClickEndAnswerButton == YES) {
            self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.endPushButton];
            
        } else {
            self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
        
        /**
         *  @author LiuChuanan, 17-03-13 17:00:57
         *  
         *  @brief 判断目前有没有人提交
         *
         *  @since 
         */
        
        if (self.finishNum == nil || [self.finishNum isEqualToString:@""]) 
        {
            self.navigationItem.title = @"已提交 0";
        } else
        {
            self.navigationItem.title = [NSString stringWithFormat:@"已提交 %@",self.finishNum];
        }
    }
    
    //只有一道题的时候隐藏推试卷按钮
    if ([alertType isEqualToString:getquestionCount]) {
        
        NSString *questionCount = [NSString stringWithFormat:@"%@",[[message objectForKey:@"data"]objectForKey:@"questionCount"]];
        ETTLog(@"%@",questionCount);
        
        if (![ETTBackToPageManager sharedManager].isPushing) {
            
            if (![questionCount isEqualToString:@"1"]) {
             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pushTestPaperButton];
            } else {
                
                self.navigationItem.rightBarButtonItem = nil;
                
            }
        }
    }
    
}

#pragma -mark 推送答对奖励命令 私有方法
- (void)p_pushRewardcommandWithMessage:(NSDictionary *)message
{
    
    /**
     *  @author LiuChuanan, 17-04-07 16:42:57
     *  
     *  @brief 老师在收取答案的过程中,点击答对奖励按钮,答案停止接收问题解决 
     *
     *  branch origin/bugfix/AIXUEPAIOS-1172
     *   
     *  Epic   origin/bugfix/Epic-0407-AIXUEPAIOS-1175
     * 
     *  @since 
     */
    NSString *msg           = [message objectForKey:@"msg"];
    NSString *rewardUserStr = [[message objectForKey:@"data"]objectForKey:@"userStr"];

    if (rewardUserStr) 
    {
        /* 时间戳 精确到秒*/
        NSString *time                      = [ETTRedisBasisManager getTime];
        NSDictionary *userInfo              = [NSDictionary dictionary];
        
        AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
        
        if (self.isPushTestPaper ==YES) {//推试卷
            userInfo = @{@"CO_04_state":@"CO_04_state4",
                         @"msg":msg,
                         @"rewardUserStr":rewardUserStr,
                         @"jid":userInformation.jid,
                         @"testPaperId":self.testPaperId,
                         @"itemIds":@"1",
                         @"classroomId":userInformation.classroomId,
                         @"userName":userInformation.userName,
                         @"userPhoto":userInformation.userPhoto,
                         @"userType":@"1",
                         @"pushId":self.pushId,
                         @"courseId":self.courseId,
                         @"testPaperName":self.testPaperName,
                         @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl
                         };
        } else {//推试题
            
            userInfo = @{@"CO_04_state":@"CO_04_state4",
                         @"msg":msg,
                         @"rewardUserStr":rewardUserStr,
                         @"jid":userInformation.jid,
                         @"testPaperId":self.testPaperId,
                         @"itemIds":self.itemIds,
                         @"classroomId":userInformation.classroomId,
                         @"userName":userInformation.userName,
                         @"userPhoto":userInformation.userPhoto,
                         @"userType":@"1",
                         @"pushId":self.pushId,
                         @"courseId":self.courseId,
                         @"testPaperName":self.testPaperName,
                         @"paperRootUrl":[AXPUserInformation sharedInformation].paperRootUrl
                         };
        }
        
        NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                                @"to":@"ALL",
                                @"from":[AXPUserInformation sharedInformation].jid,
                                @"type":@"CO_04",
                                @"userInfo":userInfo
                                };
        
        NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
        ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
        
        NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
        NSDictionary *theUserInfo = @{
                                      @"type":@"CO_04",
                                      @"theUserInfo":dict
                                      };
        NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
        
        NSString *messageJSON     = [ETTRedisBasisManager getJSONWithDictionary:dict];
        
        [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
            
            if (!error) {
                [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                }];
            } 
        }];
    }
}

- (void)dealloc {
    
    NSLog(@"------------------推送试卷控制器销毁!-------------------");
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_SCO_01 object:nil];
    
    //移除webview的KVO监听
    [_singItemWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}
#pragma mark
#pragma mark   ------------课堂恢复--------------
-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (commond== nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }

    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
    if ([restoreCommand.EDCommandIdentity isEqualToString:@"CO_04_state1"])
    {
        [self restoreFistSetup:restoreCommand];
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"CO_04_state2"])
    {
        [self restoreSecondSetup:restoreCommand];
    }
    else if ([restoreCommand.EDCommandIdentity isEqualToString:@"CO_06_state1"])
    {
        [self restoreSubTopicSetup:restoreCommand];
    }
    else
    {
        [commond commandPeriodicallyComplete:self];
    }
  
}

#pragma mark
#pragma mark  ----------------针对 CO_04_state1 恢复 ---------------------
-(void)restoreFistSetup:(ETTRestoreCommand *)commond
{
   
    if (commond == nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    ETTBackupOperationState  state =  commond.EDListModel.EDOperationSTate;
    switch (state)
    {
        case ETTBACKOPERATIONSTATECOMPLETE:
        {
             [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATESTART:
        {
            [self distributionPerforamPushingState:commond];
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
//            [self distributionWillPushing:commond];
             [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATEFAILURE:
        {
             [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATEEND:
        {
             [commond commandPeriodicallyComplete:self];
        }
            break;
        default:
            break;
    }

}

/**
 Description 分配 state1 将要开始推送状态（点击了推送，但是没有收到 redis 频道推送成功反馈）

 @param commond 恢复命令  暂不需要
 */
//-(void)distributionWillPushing:(id<ETTCommandInterface>)commond
//{
//    if (commond== nil)
//    {
//        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
//        return;
//    }
//    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
//    self.isPushTestPaper =  restoreCommand.EDListModel.EDIsPushPaper;
//    self.isPushingItem =  !self.isPushTestPaper ;
//    self.pushedTestPaperId   = restoreCommand.EDListModel.EDPushTestPaperId;
//    if (self.isPushTestPaper)
//    {
//        [self pushTestPaperButtonDidClick];
//    }
//    else
//    {
//        NSDictionary * userinfo =[restoreCommand.EDListModel.EDDisasterDic valueForKey:@"userInfo"];
//        self.itemIds        = [userinfo valueForKey:@"itemIds"];
//        [self pushPaperItem];
//    }
//    [commond commandPeriodicallyComplete:self];
//   
//}

/**
 Description 分配 state1 将要推送开始（已经redis 频道推送成功）状态
 
 @param commond 恢复命令
 */
-(void)distributionPerforamPushingState:(id<ETTCommandInterface>)commond
{
    if (commond== nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
//    self.EDActor = [[ETTPaperRestoreActor alloc]initActor:commond withEntity:self];

    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
//    [self.EDActor actorBegain:restoreCommand.EDCommandIdentity command:restoreCommand];
  
    bool pushPaper =restoreCommand.EDListModel.EDIsPushPaper;
    self.isPushTestPaper =  pushPaper;
    self.isPushingItem =  !self.isPushTestPaper ;
    
    self.pushedTestPaperId   = restoreCommand.EDListModel.EDPushTestPaperId;
    NSDictionary * userinfo =[restoreCommand.EDListModel.EDDisasterDic valueForKey:@"userInfo"];
    self.pushedTestPaperId  = [userinfo objectForKey:@"pushedTestPaperId"];
    if (pushPaper)
    {
        [self perforamPushingPaperState:restoreCommand];
    }
    else
    {
      
        self.itemIds        = [userinfo valueForKey:@"itemIds"];
        
       [self perforamPushedPaperItem:restoreCommand];
    }
    
    [commond commandPeriodicallyComplete:self];
//    [self.EDActor actorEnd:restoreCommand.EDCommandIdentity command:restoreCommand];
   
}

/**
 Description  单题恢复
 */
-(void)perforamPushedPaperItem:( ETTRestoreCommand *)commond
{
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    /**
     *  @author LiuChuanan, 17-03-14 19:02:57
     *
     *  @brief 推送之前把提交人数先清空
     *
     *  @since
     */
    self.finishNum = nil;
    
    //是否点击了结束推送按钮
    self.isClickEndPushButton = NO;
    self.isClickTestPaperStatisticsButton = NO;
    
    [self showCoverView];
    /**老师推单道题应该做的事情
     1.首先获取相应题目的itemids
     2.更改老师这边的h5显示 变成单道题统计状态
     3.更改导航栏标题显示
     4.更改右边按钮的显示
     
     */
    //3.更改导航栏标题显示
    self.navigationItem.title              = @"已提交 0";
    //4.更改右边按钮的显示
    self.pushTestPaperButton.hidden        = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
    self.testPaperStatisticsButton.hidden  = YES;
    self.isPushTestPaper                   = NO;
    self.isPushingItem                     = YES;
    
    self.isSingleWebView                   = YES;
    
    //1.首先获取相应题目的itemids
    //  self.itemIds                           = [message[@"data"] objectForKey:@"itemIds"];
    
    //redis推送推题 获得单个题的itemIds
    /* 时间戳 精确到秒*/
    NSDictionary  * dic   = [commond.EDListModel.EDDisasterDic objectForKey:@"userInfo"];
    if (dic)
    {
        self.pushId                            = [dic valueForKey:@"pushId"];

    }
    else
    {
        NSString *time                         = [ETTRedisBasisManager getTime];
        self.pushId                            = time;

    }
    
    
    /*
     新增
     */

    [ETTBackToPageManager sharedManager].testPaperID = self.testPaperId;
    
    //2.更改老师这边的h5显示 变成单道题统计状态
    
    self.afterH5UrlStr = [NSString stringWithFormat:@"%@taskTestPager.html",[AXPUserInformation sharedInformation].paperRootUrl];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];

    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"testPaperId":self.testPaperId,
                             @"classroomId":userInformation.classroomId,
                             @"userName":userInformation.userName,
                             @"userPhoto":userInformation.userPhoto,
                             @"userType":@"1",
                             @"pushId":self.pushId,
                             @"courseId":self.courseId,
                             @"itemIds":self.itemIds
                             };
    [[ETTNetworkManager sharedInstance]GETSign:self.afterH5UrlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.afterH5UrlString = [NSString stringWithFormat:@"%@?%@",self.afterH5UrlStr,[self getParamsStringWithParams:responseDictionary]];
        
        if (self.afterH5UrlString) {
            
            //这个网页没有hidePushBtn这个方法
            [ETTBackToPageManager sharedManager].hasHidePushBtnMethod = NO;
            
            [self.webView setHidden:YES];
            
            [[ETTScenePorter shareScenePorter] bindingViewToGuardModel:self.EVGuardModel withView:self.singItemWebView];
            [self.singItemWebView setHidden:NO];
            
            [self.singItemWebView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.afterH5UrlString]]];
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
            [self.endAnswerButton setEnabled:YES];
            [self.endAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
            
            
        });
        
        
        
        //设置推单道题按钮的返回
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pushItemBackButton];

    }];
    

}

/**
 Description 试卷恢复
 */
-(void)perforamPushingPaperState:( ETTRestoreCommand  *)commond
{
    
    self.finishNum = nil;
    
    self.isClickEndPushButton = NO;
    
    self.isWebView            = YES;
    
    [self showCoverView];
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.endAnswerButton setTitle:@"结束作答" forState:UIControlStateNormal];
        [self.endAnswerButton setEnabled:YES];
        [self.endAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    });
    
    
    NSDictionary  * dic   = [commond.EDListModel.EDDisasterDic objectForKey:@"userInfo"];
    if (dic)
    {
        self.pushId                            = [dic valueForKey:@"pushId"];
        
    }
    else
    {
        NSString *time                         = [ETTRedisBasisManager getTime];
        self.pushId                            = time;
        
    }
    
    [ETTCoursewarePresentViewControllerManager sharedManager].pushId = self.pushId;
    self.afterH5UrlStr = [NSString stringWithFormat:@"%@taskTestPager.html",[AXPUserInformation sharedInformation].paperRootUrl];
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"testPaperId":self.testPaperId,
                             @"classroomId":userInformation.classroomId,
                             @"userName":userInformation.userName,
                             @"userPhoto":userInformation.userPhoto,
                             @"userType":@"1",
                             @"pushId":self.pushId,
                             @"courseId":self.courseId
                             };
    [[ETTNetworkManager sharedInstance]GETSign:self.afterH5UrlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        self.afterH5UrlString = [NSString stringWithFormat:@"%@?%@",self.afterH5UrlStr,[self getParamsStringWithParams:responseDictionary]];
    }];
    
    if (self.afterH5UrlString) {
        [ETTBackToPageManager sharedManager].hasHidePushBtnMethod = NO;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[ETTURLUTF8Encoder urlUTF8EncoderWithString:self.afterH5UrlString]]];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
    [self.navigationItem setTitle:@"已提交 0"];
    
    self.isPushTestPaper                             = YES;
    [self enterRegistrationQuickBack:YES];
    
    //设置推送状态
    [ETTBackToPageManager sharedManager].isPushing   = YES;
    
    [ETTBackToPageManager sharedManager].testPaperID = self.testPaperId;
    
    /*
     新增:
     推试卷的缓存数据
     */
    
    //存储每次试卷推送的数据
//    NSString *testPaperId          = self.testPaperId;
//    NSString *itemId               = @"";
//    NSString *pushedId             = [NSString stringWithFormat:@"pushedId_%@",[ETTNetworkManager currentMsTimeString]];
//    ETTPushedTestPaperModel *model = [self pushTestPaperModelWith:itemId testPaperId:testPaperId pushedId:pushedId testPaperUrlString:self.urlString];
}

#pragma mark
#pragma mark  ----------------针对 CO_04_state2 恢复 ---------------------

-(void)restoreSecondSetup:(ETTRestoreCommand *)commond
{
    
    if (commond == nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    ETTBackupOperationState  state =  commond.EDListModel.EDOperationSTate;
    switch (state)
    {
        case ETTBACKOPERATIONSTATECOMPLETE:
        {
             [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATESTART:
        {
//            [self distributionPerforamPushingState:commond];
            [self distributionEndAnser:commond];
//
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
//            [self distributionWillPushing:commond];
            [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATEFAILURE:
        {
            
        }
            break;
        case ETTBACKOPERATIONSTATEEND:
        {
            
        }
            break;
        default:
            break;
    }
    
}

-(void)distributionEndAnser:(id<ETTCommandInterface>)commond
{
    
    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
//     [self.EDActor actorBegain:restoreCommand.EDCommandIdentity];
//    self.pushedTestPaperId && self.pushedTestPaperId != nil
    self.pushedTestPaperId  = restoreCommand.EDListModel.EDPushTestPaperId;;
    bool pushPaper =restoreCommand.EDListModel.EDIsPushPaper;
 
    self.isPushTestPaper =  pushPaper;
    self.isPushingItem =  !self.isPushTestPaper ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
         [self restoreEndAnser];
         [commond commandPeriodicallyComplete:self];
        
    });
   
}

-(void)restoreEndAnser
{
    self.isClickEndAnswerButton         = YES;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
      
   
    
    /**点击结束作答应该做的事情:
     
     1.老师端按钮状态的显示
     2.h5页面变成公布答案状态
     3.老师把结束作答信息推送到学生
     
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.endPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.endPushButton setEnabled:YES];
        
    });
    
    //老师推的是单道题
    if (self.isPushingItem) {
        //2.h5页面变成公布答案状态
        [self.singItemWebView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable handlder, NSError * _Nullable error) {
            
            //1.结束作答点击之后左边变成结束推送
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.endPushButton];
            [self.endAnswerButton setTitle:@"已公布答案" forState:UIControlStateNormal];
            [self.endAnswerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.endAnswerButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
            
        }];
    } else {
        //2.h5页面变成公布答案状态
        [self.webView evaluateJavaScript:@"showAnswer()" completionHandler:^(id _Nullable handlder, NSError * _Nullable error) {
            
            //1.结束作答点击之后左边变成结束推送
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.endPushButton];
            [self.endAnswerButton setTitle:@"已公布答案" forState:UIControlStateNormal];
            [self.endAnswerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.endAnswerButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightContentView];
            
        }];
    }
    self.classroomDict = @{@"state":@"13",@"pushId":self.pushId}.mutableCopy;
    //3.老师把结束作答信息推送到学生,让学生做出相应操作
    

   
}
/*
 每次重新进来以后获取所有学生提交的答案
 结束推送后把学生答案表里面的数据清空
 */

#pragma mark 教师试卷恢复:数据恢复处理
- (void)getStudentAnswerInfoFromRedis
{
    //self.pushedTestPaperId = [[NSUserDefaults standardUserDefaults]objectForKey:@"pushedTestPaperId"];
    NSString *key = [NSString stringWithFormat:@"%@%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL,self.pushedTestPaperId];
    ETTRedisBasisManager *basisManager = [ETTRedisBasisManager sharedRedisManager];
    [basisManager redisHGETALL:key respondHandler:^(id value, id error) {
        if (!error) 
        {
            NSLog(@"获取学生作答:%@",value);
            
            NSDictionary *dict = (NSDictionary *)value;
            
            if (value && self.pushedTestPaperId && self.pushedTestPaperId != nil) 
            {
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString   * _Nonnull obj, BOOL * _Nonnull stop) {
                    NSDictionary *dicts = [ETTRedisBasisManager getDictionaryWithJSON:obj];
                    NSLog(@"学生提交的答案:%@",dicts);
                    [self handleStudentAnswerInfoWithDict:dicts];
                }];
            }
        }
    }];
}


- (void)handleStudentAnswerInfoWithDict:(NSDictionary *)dictionary
{
    //如果点击了结束推送按钮,结束本次答案的收取
    NSDictionary *dict          = dictionary;
    NSDictionary *userInfo      = [dict objectForKey:@"userInfo"];
    NSString *pushedTestPaperId = [userInfo objectForKey:@"pushedTestPaperId"];
    
    //第一层过滤 判断每次推送的唯一值
    if ([self.pushedTestPaperId isEqualToString:pushedTestPaperId]) 
    {
        NSString *answerJson     = [userInfo objectForKey:@"answerJson"];
        NSDictionary *answerDict = [ETTJSonStringDictionaryTransformation jsonStringTodictionary:answerJson];
        NSString *jid            = [answerDict objectForKey:@"jid"];
        
        //第二层过滤 判断同一个学生有没有重复提交 这次推送的jid和上次的是否一样 一样的话说明同一个人交了两次 重复数据丢弃
        if (![jid isEqualToString:_studentLastJid]) 
        {       
            //每次提交过来的不是同一个学生,执行下面方法
            self.studentLastJid = jid;
            [self.studentAnswerInfo addObject:answerJson];
            
            if (self.studentAnswerInfo.count > 0) 
            {
                //向h5提交学生的作答信息
                NSString *putAnswerJson = [NSString stringWithFormat:@"putAnswerJson(1,'[%@]')",answerJson];
                
                //推试卷
                //self.isPushTestPaper = [[NSUserDefaults standardUserDefaults]boolForKey:@"推试卷"];
                
                //推单道题
                //self.isPushingItem = [[NSUserDefaults standardUserDefaults]boolForKey:@"推试题"];
                
                //推单道题
                if (_isPushingItem) 
                {
                    [self.singItemWebView evaluateJavaScript:putAnswerJson completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                        if (error) 
                        {
                            NSLog(@"%@",error.description); 
                        }
                    }];
                } 
                
                //推试卷
                if (self.isPushTestPaper) 
                {
                    //推试卷
                    [self.webView evaluateJavaScript:putAnswerJson completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                        
                        if (error) 
                        {
                            NSLog(@"%@",error.description); 
                        }
                    }];
                    
                }
                
            }
        } else 
        {
            NSLog(@"有同学答案重复提交了,丢弃");
        }
    }
    
}

//-(void)performActorResponse:(id<ETTActorInterface> )actor withInfo:(id)info
//{
//    
//    if (info == nil)
//    {
//        if (self.EDActor)
//        {
//             [self.EDActor actorEnd:@"close" ];
//        }
//       
//        return;
//    }
//    NSDictionary * dic = info;
//    NSInteger state = [[dic valueForKey:@"state"] integerValue];
//    switch (state) {
//        case ETTPAPERRESTOREENDANSEREND:
//        {
//            [self performChectOriginalSubject];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

-(void)performChectOriginalSubject
{
    WS(weakSelf);
   


//    NSString *key = [NSString stringWithFormat:@"%@%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL,self.pushedTestPaperId];
//    ETTRedisBasisManager *basisManager = [ETTRedisBasisManager sharedRedisManager];
//    [basisManager redisHGETALL:key respondHandler:^(id value, id error) {
//        if (!error)
//        {
//            NSLog(@"获取学生作答:%@",value);
//            
//            NSDictionary *dict = (NSDictionary *)value;
//            if (dict)
//            {
//                [self encapsulationChectOriginalSubject:dict];
////
//            }
//            else
//            {
//                [self.EDActor actorEnd:@"close"];
//            }
//
//        }
//        else
//        {
//            [self.EDActor actorEnd:@"close"];
//        }
//    }];

}
#pragma mark
#pragma mark  ----------------针对 CO_04_state6 恢复 ---------------------
-(void)restoreSubTopicSetup:(ETTRestoreCommand *)commond
{
    if (commond == nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    ETTBackupOperationState  state =  commond.EDListModel.EDOperationSTate;
    switch (state)
    {
        case ETTBACKOPERATIONSTATECOMPLETE:
        {
            [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATESTART:
        {
            //            [self distributionPerforamPushingState:commond];
            [self performSubTopicPushed:commond];
            //
        }
            break;
        case ETTBACKOPERATIONSTATEWILLBEGAIN:
        {
            //            [self distributionWillPushing:commond];
            [commond commandPeriodicallyComplete:self];
        }
            break;
        case ETTBACKOPERATIONSTATEFAILURE:
        {
            
        }
            break;
        case ETTBACKOPERATIONSTATEEND:
        {
            
        }
            break;
        default:
            break;
    }

}

-(void)performSubTopicPushed:(ETTRestoreCommand *)commond
{
    ETTRestoreCommand * restoreCommand = commond;
    
    NSDictionary * dict = restoreCommand.EDListModel.EDLastDic[@"userInfo"];
    
    if ([[dict valueForKey:@"state"] integerValue] != 23)
    {
        AXPPaperStudentSubjectViewController *vc = [[AXPPaperStudentSubjectViewController  alloc] init];
        [self.classroomDict setObject:[dict valueForKey:@"state"] forKey:@"state"];
        vc.classroomDict = self.classroomDict;
        
        
        
        if (dict)
        {
            vc.title = [dict valueForKey:@"userName"];;
        }
        [vc.imageView sd_setImageWithURL:[NSURL URLWithString:dict[kPaperAnswerImg]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            UIImage *smallImage = [ETTImageManager drawSmallImageWithOriginImage:image maxSize:CGSizeMake(kWIDTH, kHEIGHT-64)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGFloat X          = (kWIDTH - smallImage.size.width)/2;
                CGFloat Y          = (kHEIGHT - 64 - smallImage.size.height)/2;
                
                vc.imageView.frame = CGRectMake(X, Y, smallImage.size.width, smallImage.size.height);
                vc.imageView.image = smallImage;
            });
        }];
        vc.imageUrlStr = dict[kPaperAnswerImg];
        vc.answerJid   = dict[kuserId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    [restoreCommand commandPeriodicallyComplete:self];
    

    
}
-(void)performChectOriginalSubject:(NSDictionary *)stateDic
{
    
}
-(void)encapsulationChectOriginalSubject:(NSDictionary *)data
{
    
    NSMutableArray       * anserlist = [[NSMutableArray alloc]init];
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString   * _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *dicts = [ETTRedisBasisManager getDictionaryWithJSON:obj];
        NSDictionary * userinfo = [dicts valueForKey:@"userInfo"];
        NSDictionary * anserDic = [ETTRedisBasisManager getDictionaryWithJSON:[userinfo valueForKey:@"answerJson"]];
        NSArray * arr = [anserDic valueForKey:@"answerList"];
        NSDictionary * choicedic = nil;
        for (int i = 0; i< arr.count; i++)
        {
           NSDictionary * choicedictemp = arr[i];
            if (choicedictemp)
            {
                NSString * url = [choicedictemp valueForKey:@"imgAnswerUrl"];
                if (url && url.length>0)
                {
                    choicedic = choicedictemp;
                    break;
                }
            }
            
        }
        if (choicedic)
        {
            
            NSDictionary * userdic = @{@"userName":[anserDic valueForKey:@"userName"],@"userPhoto":[anserDic valueForKey:@"userPhoto"],@"answerImgUrl":[choicedic valueForKey:@"imgAnswerUrl" ],@"userId":[anserDic valueForKey:@"jid"]};
            [anserlist addObject:userdic];
            NSLog(@"学生提交的答案:%@",dicts);
        }
        
//        }
        
    }];
    NSDictionary * dicts = @{@"data":@{@"anserlist":anserlist}};
    [self pushToCheckAnswerDetailsVcWithData:dicts];
}

@end
