//
//  ETTCourseContentViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherCourseContentViewController.h"
#import "ETTTeacherCoursewareViewController.h"
#import "ETTTeacherTestPaperViewController.h"
#import "ETTTeacherClassNoteViewController.h"
#import "ETTBackToPageManager.h"
#import "ETTScenePorter.h"
#import "ETTDownloadManager.h"
#import "ETTRestoreCommand.h"
#import "ETTAnouncement.h"
#import "ETTTeacherTestPaperDetailViewController.h"
@interface ETTTeacherCourseContentViewController ()<UIScrollViewDelegate>


@property (strong, nonatomic) UIScrollView                       *titleScrollView;//标题上的scrollView
@property (strong, nonatomic) UIScrollView                       *middleScrollView;//中间的scrollView

@property (strong, nonatomic) UIView                             *btnBackgroundView;//按钮的背景View

@property (strong, nonatomic) NSMutableArray                     *btnsArray;//按钮数组

@property (strong, nonatomic) NSArray                            *titleArray;//按钮标题

@property (strong, nonatomic) ETTTeacherCoursewareViewController *coursewareViewController;//课件

@property (strong, nonatomic) ETTTeacherTestPaperViewController  *testPaperViewController;//试卷

@property (strong, nonatomic) ETTTeacherClassNoteViewController *classNoteViewController;//课中笔记


@end

@implementation ETTTeacherCourseContentViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //初始化标题部分
    [self initSubViewsInTitleView];
    
    //初始化中间部分
    [self initMiddleView];
    
    [self setupNavBar];
    self.middleScrollView.contentOffset = CGPointMake(self.middleScrollView.frame.size.width*self.currentIndex, self.middleScrollView.frame.origin.y);
    
    UIButton *button = self.btnsArray[self.currentIndex];
    
    button.selected = YES;
    
    [ETTAnouncement reportGovernmentRestoreTask:self withState:ETTTASKOPERATIONSTATELOADCOMPLETE];
    
}

- (void)dealloc {
    ETTLog(@"CourseContent 容器控制器");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

//设置导航栏
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationItem.title = self.navigationTitle;
    
    //左边返回按钮
    UIButton *backButton = [UIButton new];
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
}

//返回按钮的事件方法
- (void)backButtonDidClick {
    
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.4.18  15:30
     modifier : 康晓光
     version  ：bugfix/Epic-0417-AIXUEPAIOS-1218
     branch   ：bugfix/Epic-0417-AIXUEPAIOS-1218／AIXUEPAIOS-1183
     prolem   : 课件下载时，切换到其他课时，下载被取消
     describe : 将下载任务缓存到后台下载
     
     */
     [[ETTDownloadManager manager]cacheTasks];
    /////////////////////////////////////////////////////
    [[ETTScenePorter shareScenePorter]removeGurad:self.EVGuardModel];
   
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 *  初始化顶部滚动
 */
//初始化titleView上子控件
- (void)initSubViewsInTitleView {
    
    //title容器
    UIView *titleContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (44.000 / 768) * kSCREEN_HEIGHT)];
    titleContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleContentView];
    
    //标题数组
    NSArray *titleArray = @[@"课件",@"试卷"];
    self.titleArray = titleArray;
    
    //上面的scrollView
    UIScrollView *titleScrollView   = [[UIScrollView alloc]init];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.layer.borderColor = kC2_COLOR.CGColor;
    titleScrollView.layer.borderWidth = 1.0;
    titleScrollView.clipsToBounds = YES;
    titleScrollView.layer.cornerRadius = 5;
    CGFloat titleScrollViewX        = 0;
    CGFloat titleScrollViewY        = 0;
    CGFloat titleScrollViewW        = (270.000 / 1024) * kSCREEN_WIDTH;
    CGFloat titleScrollViewH        = (30.000 / 768) * kSCREEN_HEIGHT;
    titleScrollView.contentSize     = CGSizeMake(titleScrollViewW, 0);
    titleScrollView.frame           = CGRectMake(titleScrollViewX, titleScrollViewY, titleScrollViewW, titleScrollViewH);
    titleScrollView.centerX = self.view.centerX;
    titleScrollView.centerY = titleContentView.centerY;
    [titleContentView addSubview:titleScrollView];
    
    //初始化标题按钮的背景View
    UIView *btnBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, titleScrollView.width / 2, titleScrollViewH)];
    btnBackgroundView.backgroundColor = kC2_COLOR;
    [titleScrollView addSubview:btnBackgroundView];
    
    //第一条分割线
    UIView *firstLine = [[UIView alloc]init];
    firstLine.frame = CGRectMake(titleScrollViewW / 2, 0, 1.0, titleScrollViewH);
    firstLine.backgroundColor = kC2_COLOR;
    [titleScrollView addSubview:firstLine];
    
    //初始化三个标题按钮
    self.btnsArray = [NSMutableArray array];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        //三个标题按钮
        UIButton *titleBtn = [[UIButton alloc]init];
        CGFloat titleBtnW  = titleScrollView.width / 2;
        CGFloat titleBtnH  = titleScrollViewH;
        CGFloat titleBtnX  = i * titleBtnW;
        CGFloat titleBtnY  = 0;
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [titleBtn setTitleColor:kC1_COLOR forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        titleBtn.tag       = i;
        titleBtn.frame     = CGRectMake(titleBtnX, titleBtnY, titleBtnW, titleBtnH);
        [titleBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView addSubview:titleBtn];
        [self.btnsArray addObject:titleBtn];
    }
    self.btnBackgroundView = btnBackgroundView;
    self.titleScrollView = titleScrollView;
}

/**
 *  初始化中间滚动
 */
//标题按钮的点击监听方法
- (void)titleBtnDidClick:(UIButton *)btn{
    
    btn.selected = YES;
    UIView *subViewsInMidScr = self.middleScrollView.subviews[btn.tag];
    self.middleScrollView.contentOffset = CGPointMake(subViewsInMidScr.x, subViewsInMidScr.y);
    
    //其他按钮的选中状态
    for (UIButton *temBtn in self.btnsArray) {
        if (temBtn.tag != btn.tag) {
            temBtn.selected = NO;
        }
    }
}

//初始化中间的scrollView
- (void)initMiddleView {
    
    UIImageView *contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44.000 / 768) * kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - (44.000 / 768) * kSCREEN_HEIGHT)];
    contentImageView.backgroundColor = [UIColor redColor];
    contentImageView.userInteractionEnabled = YES;
    [self.view addSubview:contentImageView];
    
    UIScrollView *middleScrollView = [[UIScrollView alloc]initWithFrame:contentImageView.bounds];
    middleScrollView.delegate      = self;
    middleScrollView.pagingEnabled = YES;
    middleScrollView.contentSize   = CGSizeMake(self.titleArray.count * self.view.width, 0);
    middleScrollView.bounces = NO;
    middleScrollView.showsHorizontalScrollIndicator = NO;
    
    //初始化middleScrollView中的view
    for (int i = 0; i < self.titleArray.count; i++) {
        UIView *viewsInMidScrollView = [[UIView alloc]initWithFrame:CGRectMake(middleScrollView.width * i, 0, self.view.width, middleScrollView.height)];
        [middleScrollView addSubview:viewsInMidScrollView];
    }
    
    [contentImageView addSubview:middleScrollView];
    
    self.middleScrollView = middleScrollView;
    [self reloadViewsInMiddleScrollView];
}

//加载子控制器视图
- (void)reloadViewsInMiddleScrollView {
    
    for (int i = 0; i < self.btnsArray.count; i++) {
        if (i == 0) {//课件
            
            
            self.coursewareViewController = [[ETTTeacherCoursewareViewController alloc]init];
            self.coursewareViewController.EVManagerVCTR = self;
            self.coursewareViewController.courseId = self.courseID;
            self.coursewareViewController.view.frame = self.middleScrollView.frame;
            
            self.coursewareViewController.delegate = self;
            UIView *subViewInMidScr = (UIView *)[self.middleScrollView subviews][i];
            [subViewInMidScr addSubview:self.coursewareViewController.view];
          }
        
        if (i == 1) {//试卷
            
            self.testPaperViewController = [[ETTTeacherTestPaperViewController alloc]init];
            self.testPaperViewController.EVManagerVCTR = self;
            self.testPaperViewController.view.frame = self.middleScrollView.frame;
            self.testPaperViewController.delegate = self;
            self.testPaperViewController.courseId = self.courseID;
            self.testPaperViewController.EVManagerVCTR  = self;
            UIView *subViewsInMidScr = (UIView *)[self.middleScrollView subviews][i];
            [subViewsInMidScr addSubview:self.testPaperViewController.view];
         
         
        }
        
        if (i == 2) {//课中笔记
            
            self.classNoteViewController = [[ETTTeacherClassNoteViewController alloc]init];
            self.classNoteViewController.view.frame = self.middleScrollView.frame;
            self.classNoteViewController.delegate = self;
            self.classNoteViewController.EVManagerVCTR = self;
            UIView *subViewsInMidScr = (UIView *)[self.middleScrollView subviews][i];
            [subViewsInMidScr addSubview:self.classNoteViewController.view];
            
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //当前在第几页
    NSInteger pageIndex = scrollView.contentOffset.x / scrollView.width + 0.5;
    for (int i = 0; i < self.btnsArray.count; i++) {
        
        if (i == pageIndex) {
            UIButton *btn = self.btnsArray[i];
            btn.selected = YES;
            
            //滚动动画
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.btnBackgroundView.frame = btn.frame;
                CGFloat toRight              = btn.x + btn.width;
                CGFloat toLeft               = btn.x;
                CGFloat minX                 = self.titleScrollView.contentOffset.x;
                CGFloat maxX                 = self.titleScrollView.contentOffset.x + self.titleScrollView.width;
                
                if (toRight > maxX) {
                    [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentOffset.x + (toRight - maxX), self.titleScrollView.contentOffset.y) animated:YES];
                }
                
                if (toLeft < minX) {
                    [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentOffset.x + (toLeft - minX), self.titleScrollView.contentOffset.y) animated:YES];
                }
                
            } completion:^(BOOL finished) {
                
            }];
            
        }else {
            
            UIButton *btn = self.btnsArray[i];
            btn.selected = NO;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)managePushViewController:(ETTViewController *)viewController animated:(BOOL)animated
{
    if (viewController)
    {
        [[ETTScenePorter shareScenePorter] registerGurad:viewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
        [self.navigationController pushViewController:viewController animated:animated];
    }
}
-(void)managePresentViewController:(ETTViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (viewController)
    {
        [[ETTScenePorter shareScenePorter] registerGurad:viewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPRESENT];
        [self presentViewController:viewController animated:animated completion:completion];
    }
    
}
-(void)managePresentViewController:(ETTViewController *)viewController animated:(BOOL)animated
{
    if (viewController)
    {
        [[ETTScenePorter shareScenePorter] registerGurad:viewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPRESENT];
        
        [self presentViewController:viewController animated:animated completion:nil];
        
    }
}
-(void)managePopViewController:(ETTViewController *)viewController animated:(BOOL)animated
{
    
}

-(void)manageDimissViewController:(ETTViewController *)viewController animated:(BOOL)animated
{
    
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
    if (restoreCommand.EDCommandType ==ETTCOMMANDTYPEPAPER)
    {
        UIButton * btn = self.btnsArray[1];
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];

        [self.testPaperViewController performTask:commond];
        
    }
    else
    {
        UIButton * btn = self.btnsArray[0];
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self.coursewareViewController performTask:commond];
    }
    

}
@end
