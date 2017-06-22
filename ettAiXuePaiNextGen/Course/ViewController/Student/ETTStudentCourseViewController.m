//
//  ETTStudentCourseViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentCourseViewController.h"
#import "MJRefresh.h"
#import "CourseViewModel.h"
#import <MJExtension.h>
#import "ETTStudentCourseCell.h"
#import "ETTSideNavigationManager.h"
#import "ETTSideNavigationViewController.h"
#import "ReaderViewController.h"
#import "ETTStudentCourseContentViewController.h"
#import "ETTStudentVideoAudioViewController.h"
#import "ETTStudentImageDetailViewController.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTJudgeIdentity.h"
#import "ETTStudentTestPaperDetailViewController.h"
#import "ETTDownloadManager.h"
#import "ETTCoursewareStackManager.h"
#import "AXPCheckOriginalSubjectView.h"

#define kCOURSE_ITEM_MARGIN (kSCREEN_WIDTH / 34)
#define kCOURSE_ITEM_WIDTH (kCOURSE_ITEM_MARGIN * 10)
#define kHEIGHR_WIDTH_SCALE (113.000 / 300)
#define kCOURSE_ITEM_HEIGHT (kCOURSE_ITEM_WIDTH * kHEIGHR_WIDTH_SCALE)
@interface ETTStudentCourseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIImageView                           *contentView;//容器 里面放的是courseCollectionView

@property (strong, nonatomic) UICollectionView                      *courseCollectionView;

@property (strong, nonatomic) NSMutableArray                        *courseDataArray;//课程数据源

@property (assign, nonatomic) NSUInteger                            count;//一页显示item的个数

@property (strong, nonatomic) UIImageView                           *imageView;//没有课程的时候中间的imageView

@property (strong, nonatomic) UILabel                               *firstLabel;//没有课程的时候第一个label

@property (strong, nonatomic) UILabel                               *secondLabel;//没有课程的时候第二个label

@property (strong, nonatomic) NSMutableDictionary                   *lastDict;

@property (strong, nonatomic) ETTStudentCourseContentViewController *courseContentViewController;

@property (copy, nonatomic  ) NSString                              *lastMid;

@property (copy,nonatomic   ) NSString                              *lastRefreshMid;//上次刷新的mid

/**
 *  @author LiuChuanan, 17-03-09 18:02:57
 *  
 *  @brief 新增两个属性变量
 *
 *  @since 
 */

@property (nonatomic, strong) NSMutableSet                          *set;//集合 用来装载indexPath对应的courseId

@property (nonatomic, copy)   NSString                              *lastCourseId;//上次的课程id

/**
 *  @author LiuChuanan, 17-03-21 18:45:57
 *  
 *  @brief 新增容器
 *
 *  @since 
 */
@property (strong, nonatomic) UIView                                *theView;//没有课程的容器


@end

static NSString * const reuseIdentifier = @"studentReuseIdentifier";

@implementation ETTStudentCourseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = kC1_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    self.count = 30;
    
    [self setupSubview];
    
    [self setupRefresh];
    
    [self initWithSubviewWithoutCourse];
    
    [self setupNavBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherSynchronizedIntoClassInfo:) name:kREDIS_COMMAND_TYPE_CO_01 object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentGetTeacherRefreshInfo:) name:kREDIS_COMMAND_TYPE_CO_05 object:nil];
}

//学生获得老师刷新信息
- (void)studentGetTeacherRefreshInfo:(NSNotification *)notify {
    
    NSDictionary *dict = notify.object;
    NSString *mid = [dict objectForKey:@"mid"];
    if ([mid isEqualToString:self.lastRefreshMid]) {
        return;
    } else {
        self.lastRefreshMid = mid;
        
        /**
         *  @author LiuChuanan, 17-03-22 15:10:57
         *  
         *  @brief 学生获得老师的刷新命令后,不管本课程有没有课,也要同步刷新一下
         *
         *  @since 
         */
        self.theView.hidden = YES;
        self.contentView.hidden = NO;
        [self setupRefresh];
    }
}

/**
 *  @author LiuChuanan, 17-03-09 18:52:57
 *  
 *  @brief 实例化集合
 *
 *  @since 
 */
- (NSMutableSet *)set
{
    if (!_set) {
        _set = [NSMutableSet set];
    }
    return _set;
}

//老师点击某个课程,学生同步打开某个课程
- (void)studentGetTeacherSynchronizedIntoClassInfo:(NSNotification *)notify 
{
    /**
     *  @author LiuChuanan, 17-03-09 18:22:57
     *  
     *  @brief 学生收到老师同步进课命令后,学生先做出相应判断,是否跟随老师一起进入相应课程
     *
     *  @since 
     */
    NSDictionary *dict = notify.object;
    
    NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
    
    NSDictionary *userInfo = [dict objectForKey:@"userInfo"];
    
    NSInteger item = [[userInfo objectForKey:@"indexPathItem"] integerValue];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    NSString *courseId = [userInfo objectForKey:@"courseId"];
    
    NSString *mid = [dict objectForKey:@"mid"];
    
    if ([type isEqualToString:@"CO_01"]) {
        
        if ([ETTBackToPageManager sharedManager].isPushing == NO) 
        {
            ///相同的课程不需要修改
            if ([self.lastMid isEqualToString:mid])
            {
                return;
            } else {
                self.lastMid = mid;
                //当前是否是课件页面  如果正在看pdf课件
                if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[ReaderViewController class]]) 
                {
                    return ;
                }
                ETTSideNavigationViewController *rootVc = [ETTJudgeIdentity getSideNavigationViewController];
                
                /**
                 *  @author LiuChuanan, 17-04-12 16:42:57
                 *  
                 *  @brief  学生处于白板查看原题/查看批阅页面,老师点击同步进课,让学生同步进课. 应该在白板中处理的业务拿到课程模块来处理(首先熟悉白板里面的逻辑)
                 *
                 *  branch  origin/bugfix/AIXUEPAIOS-1205
                 *   
                 *  Epic    origin/bugfix/Epic-0411-AIXUEPAIOS-1176
                 * 
                 *  @since 
                 */
                AXPCheckOriginalSubjectView *originView = [rootVc.view viewWithTag:2018];
                
                if (originView && originView!= nil) 
                {
                    [originView removeFromSuperview];
                }
                
                //判断当前是否在课程页面
                //不在课程页面
                if (!(rootVc.index == 0)) 
                {
                    [[ETTCoursewareStackManager new]removeAllCildViewController:rootVc];
                    [rootVc presentViewControllerToIndex:0 title:nil];
                    
                    [self enterCourseWithCourseId:courseId];
                    
                } else 
                {//在课程页面 判断当前是哪个页面
                    ETTNavigationController *currentVc = rootVc.childViewControllers[0];
                    UIViewController *rootVC = currentVc.topViewController;
                    
                    if ([rootVC isKindOfClass:[ETTStudentCourseViewController class]]) {
                        
                        //学生当前处于课程控制器,直接进入相应课程
                        
                        [self enterCourseWithCourseId:courseId];
                        
                        
                    }else if ([rootVC isKindOfClass:[ETTStudentCourseContentViewController class]])
                    {
                        //先判断老师推过来的课程学生这边有没有
                        NSIndexPath *theIndexPath;
                        
                        //新增 滚动到
                        for (NSDictionary *dict in self.set) {
                            indexPath = dict[courseId];
                            
                            if (indexPath) {
                                theIndexPath = indexPath;
                            }
                        }
                        
                        //如果theIndexPath不存在,直接返回
                        if (!theIndexPath) 
                        {
                            return;
                        } else 
                        {
                            //如果学生端有老师推送的课件
                            if ([self.lastCourseId isEqualToString:courseId]) 
                            {
                                return;
                            } else 
                            {
                                [rootVC.navigationController popViewControllerAnimated:YES];
                                [self enterCourseWithCourseId:courseId];
                            }
                        }
                        
                    } else if ([rootVC isKindOfClass:[ETTStudentImageDetailViewController class]]) 
                    {
                        //rootVC是图片详情控制器
                        return;
                    } else if ( [rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) 
                    {
                        //如果学生当前处于音视频控制,不做操作
                        return;
                    }
                }
            }
        }
        
    }
}

/**
 *  @author LiuChuanan, 17-03-09 18:42:57
 *  
 *  @brief 集合中数据无序且不重复,满足要求
 *
 *  @since 
 */
- (void)enterCourseWithCourseId:(NSString *)courseId
{
    NSIndexPath *theIndexPath;
    NSIndexPath *indexPath;
    
    //创建一个集合,集合里面存的都是课程与位置的映射表
    for (NSDictionary *dict in self.set) {
        indexPath = dict[courseId];
        
        if (indexPath) {
            //保存一下indexPath
            theIndexPath = indexPath;
        }
    }
    
    if (theIndexPath) 
    {
        [self collectionView:self.courseCollectionView didSelectItemAtIndexPath:theIndexPath];
    }
    self.lastCourseId = courseId;
}


- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    
    UIView *leftView                                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label                                              = [[UILabel alloc]init];
    label.textColor                                             = [UIColor whiteColor];
    label.font                                                  = [UIFont systemFontOfSize:17];
    label.textAlignment                                         = NSTextAlignmentCenter;
    label.frame                                                 = CGRectMake(42+5-10, 7, 75, 30);
    label.text = @"我的课程";
    
    //左侧菜单按钮
    UIButton *menuButton = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
    menuButton.frame     = CGRectMake(-10, 2, 42, 41);
    
    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:label];
    [leftView addSubview:menuButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    
}

//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}

/**
 *  没有课件
 */
- (void)initWithSubviewWithoutCourse {
    
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     *  @author LiuChuanan, 17-03-21 18:25:57
     *  
     *  @brief 新增容器控制器
     *
     *  @since 
     */
    UIView *theView = [[UIView alloc]initWithFrame:self.view.bounds];
    theView.backgroundColor = [UIColor whiteColor];
    theView.hidden = YES;
    [self.view addSubview:theView];
    self.theView = theView;
    
    CGFloat imageViewX = (212.000 / 1024) * kSCREEN_WIDTH;
    CGFloat imageViewY = (133.000 / 768) * kSCREEN_HEIGHT;
    CGFloat imageViewWidth = (600.000 / 1024) * kSCREEN_WIDTH;
    CGFloat imageViewHeight = (400.000 / 768) * kSCREEN_HEIGHT;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    imageView.centerX = self.theView.centerX;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"course_without"];
    /**
     *  @author LiuChuanan, 17-03-21 18:05:57
     *  
     *  @brief 添加到容器中
     *
     *  @since 
     */
    [self.theView addSubview:imageView];
    self.imageView = imageView;
    
    /**
     *  @author LiuChuanan, 17-03-21 18:05:57
     *  
     *  @brief 给容器增加一个手势,当点击容器任意位置的时候进行刷新
     *
     *  @since 
     */
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidTap:)];
    [self.theView addGestureRecognizer:tapGes];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    
    /**
     *  @author LiuChuanan, 17-03-21 18:05:57
     *  
     *  @brief 修改没有课程提示语
     *
     *  @since 
     */
    firstLabel.text = @"您暂时还没有添加任何课程资料,如果您已经添加了,请轻点任意位置进行课程刷新!";
    firstLabel.textColor = kF8_COLOR;
    firstLabel.font = [UIFont systemFontOfSize:20.0];
    firstLabel.y = CGRectGetMaxY(imageView.frame) + (70.000 / 768) * kSCREEN_HEIGHT;
    [firstLabel sizeToFit];
    
    /**
     *  @author LiuChuanan, 17-03-21 18:05:57
     *  
     *  @brief 添加到容器中
     *
     *  @since 
     */
    firstLabel.centerX = self.theView.centerX;
    [self.theView addSubview:firstLabel];
    self.firstLabel = firstLabel;
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.text = @"请通过电脑pc端登录\"爱学课堂\"对班级课件资料进行添加";
    secondLabel.textColor = kF8_COLOR;
    secondLabel.font = [UIFont systemFontOfSize:15.0];
    secondLabel.y = CGRectGetMaxY(firstLabel.frame) + (25.000 / 768) * kSCREEN_HEIGHT;
    [secondLabel sizeToFit];
    
    /**
     *  @author LiuChuanan, 17-03-21 18:05:57
     *  
     *  @brief 添加到容器中
     *
     *  @since 
     */
    secondLabel.centerX = self.theView.centerX;
    self.secondLabel = secondLabel;
}

/**
 *  @author LiuChuanan, 17-03-21 18:05:57
 *  
 *  @brief 如果是没有课程页面,点击任意位置进行刷新
 *
 *  @since 
 */
- (void)imageViewDidTap:(UITapGestureRecognizer *)tap
{
    self.theView.hidden = YES;
    self.contentView.hidden = NO;
    [self setupRefresh];
}

- (NSMutableArray *)courseDataArray {
    
    if (_courseDataArray == nil) {
        _courseDataArray = [NSMutableArray array];
    }
    
    return _courseDataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupRefresh];
    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/**
 *  获取课程列表数据
 */
- (void)getCourseData
{
    NSString *urlString                 = [NSString stringWithFormat:@"%@%@",SERVER_HOST,getCourseListForStu];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    NSMutableDictionary * paramsDic     = [[NSMutableDictionary alloc]init];
    if (userInformation.jid.length)
    {
        [paramsDic setValue:userInformation.jid forKey:@"jid"];
    }
    if (userInformation.schoolId.length)
    {
        [paramsDic setValue:userInformation.schoolId forKey:@"schoolId"];
    }
    if (userInformation.classroomId.length)
    {
        [paramsDic setValue:userInformation.classroomId forKey:@"classroomId"];
    }
    
    
    [[ETTNetworkManager sharedInstance] GET:urlString Parameters:paramsDic responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        [self.courseCollectionView.mj_header endRefreshing];
        
        if (error)
        {
            [self.view toast:@"糟糕,网络连接出错"];
        } else {
            
            NSDictionary *dataDict    = [responseDictionary objectForKey:@"data"];
            
            self.navigationItem.title = [dataDict objectForKey:@"coursesTag"];
            
            NSArray *courseList       = [dataDict objectForKey:@"courseList"];
            
            [self.courseDataArray removeAllObjects];
            
            for (NSDictionary *dict in courseList) {
                
                CourseModel *courseModel = [CourseModel mj_objectWithKeyValues:dict];
                
                [self.courseDataArray addObject:courseModel];
            }
            
            if (!self.courseDataArray.count) 
            {
                /**
                 *  @author LiuChuanan, 17-03-21 18:15:57
                 *  
                 *  @brief 把没有课程页面的控件放到一个容器里面,没有课程隐藏contentView(这个是有课程的容器).显示没有课程容器theView
                 *
                 *  @since 
                 */
                self.contentView.hidden = YES;
                self.theView.hidden = NO;
                
            } else {
                
                /**
                 *  @author LiuChuanan, 17-03-09 18:35:57
                 *  
                 *  @brief 每次刷新要先清空集合中的所有元素,然后在添加
                 *
                 *  @since 
                 */
                
                [self.set removeAllObjects];
                
                //往集合里面添加元素
                [self insertCourseIdIntoSet];
                
                [self.courseCollectionView reloadData];
            }
        }
    }];
}

/**
 *  @author LiuChuanan, 17-03-09 18:35:57
 *  
 *  @brief 添加元素,课程id与位置的映射表
 *
 *  @since 
 */
- (void)insertCourseIdIntoSet
{
    if (self.courseDataArray.count > 0) 
    {
        for (NSInteger i = 0; i < self.courseDataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CourseModel *courseModel = self.courseDataArray[i];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:indexPath forKey:courseModel.courseId];
            [self.set addObject:dict];
        }
    }
}

/**
 *  初始化子控件
 */
- (void)setupSubview 
{
    _contentView                           = [[UIImageView alloc]initWithFrame:self.view.frame];
    _contentView.userInteractionEnabled    = YES;
    _contentView.image                     = [UIImage imageNamed:@"course_list_background"];
    [self.view addSubview:_contentView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset                = UIEdgeInsetsMake(kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN);
    flowLayout.scrollDirection             = UICollectionViewScrollDirectionVertical;
    _courseCollectionView                  = [[UICollectionView alloc]initWithFrame:_contentView.frame collectionViewLayout:flowLayout];
    _courseCollectionView.backgroundColor  = [UIColor clearColor];
    _courseCollectionView.scrollsToTop     = YES;
    _courseCollectionView.delegate         = self;
    _courseCollectionView.dataSource       = self;
    [_courseCollectionView registerClass:[ETTStudentCourseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [_contentView addSubview:_courseCollectionView];
    
}

/**
 *  设置刷新
 */
- (void)setupRefresh 
{
    //下拉header
    MJRefreshNormalHeader *header                                           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden                                      = YES;
    
    //设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateFinish];
    
    //设置字体
    header.stateLabel.font                                                  = [UIFont systemFontOfSize:13.0];
    header.stateLabel.textColor                                             = kF2_COLOR;
    
    //马上进入刷新状态
    [header beginRefreshing];
    
    //设置刷新控件
    self.courseCollectionView.mj_header                                     = header;
    
    //上拉footer
    MJRefreshBackNormalFooter *footer                                       = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //设置文字
    [footer setTitle:@"上拉显示更多内容" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"松手加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"所有数据加载完毕" forState:MJRefreshStateNoMoreData];
    
    //设置字体
    footer.stateLabel.textColor                                             = kF2_COLOR;
    footer.stateLabel.font                                                  = [UIFont systemFontOfSize:13.0];
    
    //设置footer
    self.courseCollectionView.mj_footer                                     = footer;
    
    // 设置了底部inset
    self.courseCollectionView.contentInset                                  = UIEdgeInsetsMake(0, 0, 80, 0);
    
    // 忽略掉底部inset
    self.courseCollectionView.mj_footer.ignoredScrollViewContentInsetBottom = 10;
    
}

//下拉刷新
- (void)loadNewData {
    
    // 1 .模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UICollectionView *collectionView = self.courseCollectionView;
    
    /**
     *  @author LiuChuanan, 17-03-22 14:45:57
     *  
     *  @brief 设置刷新时间间隔,原来2秒改成1秒
     *
     *  @since 
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getCourseData];
        NSInteger loadCount = self.courseDataArray.count - self.count;
        
        self.count = loadCount > 30 ? 30 : self.courseDataArray.count;
        // 拿到当前的下拉刷新控件，结束刷新状态
        [collectionView.mj_header endRefreshing];
    });
}


//上拉刷新
- (void)loadMoreData {
    // 1.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UICollectionView *collectionView = self.courseCollectionView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSInteger loadCount = self.courseDataArray.count - self.count;
        
        if (loadCount > 0) 
        {
            if (loadCount > 30) 
            {
                self.count += 30;
                // 拿到当前的上拉刷新控件，结束刷新状态
                [collectionView.mj_footer endRefreshing];
                
            } else 
            {
                self.count += loadCount;
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                [collectionView.mj_footer endRefreshing];
            }
        } else 
        {
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        // 刷新表格
        [collectionView reloadData];
    });
}


#pragma _courseCollectionView Data
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 
{
    
    if (self.courseDataArray.count < 30) 
    {
        return self.courseDataArray.count;
    } else 
    {
        return self.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ETTStudentCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.courseModel           = self.courseDataArray[indexPath.item];
    cell.coursewareButton.tag  = 10000 + indexPath.item;
    cell.classNoteButton.tag   = 10001 + indexPath.item;
    cell.myNoteButton.tag      = 10002 + indexPath.item;
    
    //课件的点击
    [cell.coursewareButton addTarget:self action:@selector(coursewareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //课中笔记的点击
    [cell.classNoteButton addTarget:self action:@selector(classNoteButtonButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //我的笔记的点击
    [cell.myNoteButton addTarget:self action:@selector(myNoteButtonButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.courseDataArray.count) {
        CourseModel *courseModel                                            = self.courseDataArray[indexPath.item];
        self.courseContentViewController                                    = [[ETTStudentCourseContentViewController alloc]init];
        self.courseContentViewController.navigationTitle                    = courseModel.courseName;
        self.courseContentViewController.courseID                           = courseModel.courseId;
        [ETTCoursewarePresentViewControllerManager sharedManager].indexPath = indexPath;
        [self.navigationController pushViewController:self.courseContentViewController animated:YES];
    }
}

#pragma mark -课程上三个按钮的点击 课件 课中笔记 我的笔记
//课件按钮的点击
- (void)coursewareButtonDidClick:(UIButton *)button {
    
    self.courseContentViewController = [[ETTStudentCourseContentViewController alloc]init];
    
    NSIndexPath *indexPath           = [NSIndexPath indexPathForItem:button.tag - 10000 inSection:0];
    
    CourseModel *courseModel         = self.courseDataArray[indexPath.item];
    
    NSInteger currentIndex           = button.tag - indexPath.item - 10000;
    
    if (currentIndex == 0)
    {
        self.courseContentViewController.navigationTitle = courseModel.courseName;
        self.courseContentViewController.courseID        = courseModel.courseId;
        self.courseContentViewController.currentIndex = currentIndex;
    }
    
    [self pushViewController:self.courseContentViewController];
}

//课中笔记的点击
- (void)classNoteButtonButtonDidClick:(UIButton *)button {
    
    self.courseContentViewController = [[ETTStudentCourseContentViewController alloc]init];
    
    NSIndexPath *indexPath           = [NSIndexPath indexPathForItem:button.tag - 10001 inSection:0];
    
    CourseModel *courseModel         = self.courseDataArray[indexPath.item];
    
    NSInteger currentIndex           = button.tag - indexPath.item - 10000;
    
    if (currentIndex == 1) {
        
        self.courseContentViewController.navigationTitle = courseModel.courseName;
        self.courseContentViewController.courseID        = courseModel.courseId;
        self.courseContentViewController.currentIndex = currentIndex;
    }
    
    [self pushViewController:self.courseContentViewController];
}

//我的笔记按钮的点击
- (void)myNoteButtonButtonDidClick:(UIButton *)button 
{
    self.courseContentViewController = [[ETTStudentCourseContentViewController alloc]init];
    
    NSIndexPath *indexPath           = [NSIndexPath indexPathForItem:button.tag - 10002 inSection:0];
    
    CourseModel *courseModel         = self.courseDataArray[indexPath.item];
    
    NSInteger currentIndex           = button.tag - indexPath.item - 10000;
    
    if (currentIndex == 2) 
    {
        self.courseContentViewController.navigationTitle = courseModel.courseName;
        self.courseContentViewController.courseID        = courseModel.courseId;
        self.courseContentViewController.currentIndex    = currentIndex;
    }
    
    [self pushViewController:self.courseContentViewController];
}


- (void)pushViewController:(UIViewController *)viewController 
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCOURSE_ITEM_WIDTH, kCOURSE_ITEM_HEIGHT);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCOURSE_ITEM_MARGIN;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCOURSE_ITEM_MARGIN;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CO_01 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CO_05 object:nil];
    ETTLog(@"课程控制器销毁了");
}

@end


