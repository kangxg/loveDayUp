//
//  ETTCourseViewController.m
//  ettAiXuePaiNextGen
/*
 1.课程控制器,展示课程列表
 
 
 */
//  Created by Liu Chuanan on 16/9/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//



#import "ETTTeacherCourseViewController.h"
#import "ETTCourseCell.h"
#import "MJRefresh.h"
#import "CourseViewModel.h"
#import <MJExtension.h>
#import "ETTSideNavigationManager.h"
#import "ETTNetStatusManager.h"
#import "ETTBackToPageManager.h"
#import "ETTOpenClassroomDoBackModel.h"
#import "AXPUserInformation.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "AXPRedisManager.h"
#import "ETTRedisBasisManager.h"
#import "ETTScenePorter.h"

#import "ETTTeacherTestPaperViewController.h"

#import "ETTPushedTestPaperDataManager.h"
#import "ETTPushedTestPaperModel.h"

#import "ETTRestoreCommand.h"
#define kCOURSE_ITEM_MARGIN (kSCREEN_WIDTH / 34)
#define kCOURSE_ITEM_WIDTH (kCOURSE_ITEM_MARGIN * 10)
#define kHEIGHR_WIDTH_SCALE (113.000 / 300)
#define kCOURSE_ITEM_HEIGHT (kCOURSE_ITEM_WIDTH * kHEIGHR_WIDTH_SCALE)

@interface ETTTeacherCourseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIImageView      *contentView;//容器 里面放的是courseCollectionView

@property (strong, nonatomic) NSMutableArray   *courseDataArray;//课程数据源

@property (strong, nonatomic) UICollectionView *courseCollectionView;

@property (assign, nonatomic) NSUInteger       count;//一页显示item的个数

@property (strong, nonatomic) UIImageView      *imageView;//没有课程的时候中间的imageView

@property (strong, nonatomic) UILabel          *firstLabel;//没有课程的时候第一个label

@property (strong, nonatomic) UILabel          *secondLabel;//没有课程的时候第二个label

/**
 *  @author LiuChuanan, 17-03-21 18:45:57
 *  
 *  @brief 新增容器
 *
 *  @since 
 */
@property (strong, nonatomic) UIView           *theView;//没有课程的容器

/**
 *  @author LiuChuanan, 17-03-22 14:34:57
 *  
 *  @brief 下拉刷新header
 *
 *  @since 
 */
@property (strong, nonatomic) MJRefreshNormalHeader *freshHeader;


@end


static NSString * const reuseIdentifier = @"reuseIdentifier";

@implementation ETTTeacherCourseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = kC1_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    
    self.count = 30;
    
    [self setupSubview];
    
    [self setupRefresh];
    
    [self initWithSubviewWithoutCourse];
    
    [self setupNavBar];
    
    //查询所有数据
    //    NSMutableArray *array = [[ETTPushedTestPaperDataManager sharedManager]selectAllData];
    //    
    //    if (array.count > 0) 
    //    {
    //        
    //        ETTPushedTestPaperModel *model = [array lastObject];
    //        
    //        NSString *itemId = model.itemId;
    //        NSString *testPaperId  = model.testPaperId;
    //        NSString *pushedId = model.pushedId;
    //        
    //        //如果缓存数据存在,itemId存在,说明上次断开之前推送的是单道题
    //        if (![itemId isEqualToString: @""]&& itemId && testPaperId) 
    //        {
    //            ETTLog(@"上次推送的是单道题");
    //        } else
    //        {
    //            ETTLog(@"上次推送的是试卷");  
    //            //ETTTeacherTestPaperViewController *testPaperDetailViewController = [[ETTTeacherTestPaperViewController alloc]init];
    //            //[self.navigationController pushViewController:testPaperDetailViewController animated:YES];
    //        }
    //    }
    
    
}


/**
 设置导航栏
 */
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(42+5-10, 7, 75, 30);
    label.text = @"我的课程";
    
    //左侧菜单按钮
    UIButton *menuButton = [UIButton new];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_default"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"navbar_menu_pressed"] forState:UIControlStateHighlighted];
    menuButton.frame = CGRectMake(-10, 2, 42, 41);
    
    [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [leftView addSubview:label];
        [leftView addSubview:menuButton];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    });
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}

/**
 *  没有课程
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
    [self.theView addSubview:secondLabel];
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
    
}

/**
 *  获取列表数据
 */
- (void)getCourseData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,getCourseListForTeacher];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"schoolId":userInformation.schoolId,
                             @"gradeId":userInformation.gradeId,
                             @"subjectId":userInformation.subjectId
                             };
    
    [[ETTNetworkManager sharedInstance] GET:urlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        [self.courseCollectionView.mj_header endRefreshing];
        
        if (error) {
            [self.view toast:@"糟糕,网络连接出错"];
        } else {
            
            NSDictionary *dataDict = [responseDictionary objectForKey:@"data"];
            
            self.navigationItem.title = [dataDict objectForKey:@"coursesTag"];
            
            NSArray *courseList = [dataDict objectForKey:@"courseList"];
            
            [self.courseDataArray removeAllObjects];
            
            for (NSDictionary *dict in courseList) {
                
                CourseModel *courseModel = [CourseModel mj_objectWithKeyValues:dict];
                
                [self.courseDataArray addObject:courseModel];
                
            }
            
            if (!self.courseDataArray.count) {
                
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
                
                [self.courseCollectionView reloadData];
                
            }
        }
    }];
}

/**
 *  初始化子控件
 */
- (void)setupSubview {
    
    _contentView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _contentView.userInteractionEnabled = YES;
    _contentView.image = [UIImage imageNamed:@"course_list_background"];
    [self.view addSubview:_contentView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN, kCOURSE_ITEM_MARGIN);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _courseCollectionView = [[UICollectionView alloc]initWithFrame:_contentView.frame collectionViewLayout:flowLayout];
    _courseCollectionView.backgroundColor = [UIColor clearColor];
    _courseCollectionView.scrollsToTop = YES;//滚动到顶部
    _courseCollectionView.delegate = self;
    _courseCollectionView.dataSource = self;
    [_courseCollectionView registerClass:[ETTCourseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [_contentView addSubview:_courseCollectionView];
    
}

/**
 *  设置刷新
 */
- (void)setupRefresh {
    
    //下拉header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateFinish];
    
    //设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:13.0];
    header.stateLabel.textColor = kF2_COLOR;
    
    //马上进入刷新状态
    [header beginRefreshing];
    
    //设置刷新控件
    self.courseCollectionView.mj_header = header;
    
    /**
     *  @author LiuChuanan, 17-03-22 14:34:57
     *  
     *  @brief 下拉刷新header赋值
     *
     *  @since 
     */
    self.freshHeader = header;
    
    
    //上拉footer
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //设置文字
    [footer setTitle:@"上拉显示更多内容" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"松手加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"所有数据加载完毕" forState:MJRefreshStateNoMoreData];
    
    //设置字体
    footer.stateLabel.textColor = kF2_COLOR;
    footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
    
    //设置footer
    self.courseCollectionView.mj_footer = footer;
    
    // 设置了底部inset
    self.courseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    
    // 忽略掉底部inset
    self.courseCollectionView.mj_footer.ignoredScrollViewContentInsetBottom = 10;
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /**
         *  @author LiuChuanan, 17-03-22 14:45:57
         *  
         *  @brief 当老师的刷新状态处于加载中的时候,才把老师的刷新状态传给给学生
         *
         *  @since 
         */
        
        NSLog(@"%@",self.freshHeader.stateLabel.text); 
        
        if ([self.freshHeader.stateLabel.text isEqualToString:@"加载中 ..."]) 
        {
            
            [self teacherRefreshControlStudentRefresh];
        }
        
        //网络加载课程数据
        [self getCourseData];
        
        
        NSInteger loadCount = self.courseDataArray.count - self.count;
        
        self.count = loadCount > 30 ? 30 : self.courseDataArray.count;
        
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [collectionView.mj_header endRefreshing];
    });
}


//老师控制学生刷新
- (void)teacherRefreshControlStudentRefresh {
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_05"
                            };
    
    NSString *key = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_05",
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
            ETTLog(@"老师同步刷新错误原因:%@",error);
        }
    }];
    
}

//上拉刷新
- (void)loadMoreData {
    
    
    // 1.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UICollectionView *collectionView = self.courseCollectionView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSInteger loadCount = self.courseDataArray.count - self.count;
        
        if (loadCount > 0) {
            
            if (loadCount > 30) {
                
                
                self.count += 30;
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                [collectionView.mj_footer endRefreshing];
                
            } else {
                
                self.count += loadCount;
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                [collectionView.mj_footer endRefreshing];
            }
            
        } else {
            
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.courseDataArray.count < 30) {
        
        return self.courseDataArray.count;
        
    } else {
        
        return self.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ETTCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    cell.courseModel = self.courseDataArray[indexPath.item];
    
    cell.coursewareButton.tag = 10000 + indexPath.item;
    cell.testPaperButton.tag = 10001 + indexPath.item;
    
    //课件的点击
    [cell.coursewareButton addTarget:self action:@selector(coursewareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //试卷的点击 学生那边没有
    [cell.testPaperButton addTarget:self action:@selector(testPaperButtonButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

#pragma mark - 选中当前item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseModel *courseModel = self.courseDataArray[indexPath.item];
    
    
    
    /**
     *  @author LiuChuanan, 17-03-09 17:05:57
     *  
     *  @brief 在选中某个课程新加一个参数,courseId,把课程id通过redis传给学生
     *
     *  @since 
     */
    [self teacherClickCourseItemWithIndex:indexPath andCourseId:courseModel.courseId];
    [ETTScenePorter shareScenePorter].EDViewRecordManager.EDTitleRecord =courseModel.courseName;
    [self jumpPageToCourseView:courseModel.courseName withName:courseModel.courseId];
   
//    self.courseContentViewController = [[ETTTeacherCourseContentViewController alloc]init];
//    
//    self.courseContentViewController.navigationTitle = courseModel.courseName;
//    
//    self.courseContentViewController.courseID = courseModel.courseId;
//    
//    [[ETTScenePorter shareScenePorter] registerGurad:self.courseContentViewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
//    [self.navigationController pushViewController:self.courseContentViewController animated:YES];
    
}

-(void)jumpPageToCourseView:(NSString * )title withName:(NSString *)courseId
{
    if (courseId)
    {
        self.courseContentViewController = [[ETTTeacherCourseContentViewController alloc]init];
        
        self.courseContentViewController.navigationTitle = title;
        
        self.courseContentViewController.courseID = courseId;
        
        [[ETTScenePorter shareScenePorter] registerGurad:self.courseContentViewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
        [self.navigationController pushViewController:self.courseContentViewController animated:YES];

    }
}
//课件按钮的点击
- (void)coursewareButtonDidClick:(UIButton *)button {
    
    self.courseContentViewController = [[ETTTeacherCourseContentViewController alloc]init];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.tag - 10000 inSection:0];
    
    CourseModel *courseModel = self.courseDataArray[indexPath.item];
    
    /**
     *  @author LiuChuanan, 17-03-09 17:05:57
     *  
     *  @brief 在选中某个课程的按钮时新加一个参数,courseId,把课程id通过redis传给学生
     *
     *  @since 
     */
    [self teacherClickCourseItemWithIndex:indexPath andCourseId:courseModel.courseId];
    
    NSInteger currentIndex = button.tag - indexPath.item - 10000;
    
    if (currentIndex == 0) {
        
        self.courseContentViewController.navigationTitle = courseModel.courseName;
        
        self.courseContentViewController.courseID = courseModel.courseId;
        
        self.courseContentViewController.currentIndex = currentIndex;
    }
    
    [[ETTScenePorter shareScenePorter] registerGurad:self.courseContentViewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
    [self pushViewController:self.courseContentViewController];
}

//老师点击了课程item
- (void)teacherClickCourseItemWithIndex:(NSIndexPath *)indexPath andCourseId:(NSString *)courseId {
    
    /**
     *  @author LiuChuanan, 17-03-09 17:35:57
     *  
     *  @brief userInfo 增加courseId
     *
     *  @since 
     */
    
    NSDictionary *userInfo = @{
                               @"indexPathItem":[NSString stringWithFormat:@"%ld",(long)indexPath.item],
                               @"courseId":courseId
                               };
    
    /**老师点击了课程item要做的事情
     1.把老师的indexPath传给学生
     
     */
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    NSDictionary  *dict = @{
                            @"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_01",
                            @"userInfo":userInfo
                            };
    
    NSString *key                      = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON              = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    
    NSString *redisKey                 = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_01",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        
        if (!error) {
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    NSLog(@"成功发送消息%@",dict);
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                }
            }];
        }else {
            ETTLog(@"老师同步进课错误原因:%@",error);
        }
    }];
}

//试卷按钮的点击
- (void)testPaperButtonButtonDidClick:(UIButton *)button {
    
    self.courseContentViewController = [[ETTTeacherCourseContentViewController alloc]init];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:button.tag - 10001 inSection:0];
    
    CourseModel *courseModel = self.courseDataArray[indexPath.item];
    
    NSInteger currentIndex = button.tag - indexPath.item - 10000;
    
    if (currentIndex == 1) {
        
        self.courseContentViewController.navigationTitle = courseModel.courseName;
        
        self.courseContentViewController.courseID = courseModel.courseId;
        
        self.courseContentViewController.currentIndex = currentIndex;
    }
    [[ETTScenePorter shareScenePorter] registerGurad:self.courseContentViewController withGuard:self.EVGuardModel withHandle:ETTVCHANDLEPUSH];
    [self pushViewController:self.courseContentViewController];
}


- (void)pushViewController:(UIViewController *)viewController {
    
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


- (void)dealloc {
    
    ETTLog(@"课程控制器销毁了");
}

#pragma  mark
#pragma  mark -- 课堂恢复-----
-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (commond == nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
    switch (restoreCommand.EDCommandType) {
        case ETTCOMMANDTYPECOURSEWARE:
        {
            [self restoreCourse:restoreCommand];
        }
            break;
        case ETTCOMMANDTYPEPAPER:
        {
            [self restorePaper:restoreCommand];
        }
            break;
        default:
            break;
    }
    
    
}
-(void)restoreCourse:(ETTRestoreCommand *)command
{
    NSDictionary * dic = command.EDListModel.EDExpDic;
    if (dic )
    {
        
            [self jumpPageToCourseView:command.EDListModel.EDTitle withName:[dic valueForKey:@"courseId"]];
            command.EDEntity = self.courseContentViewController ;
            command.EDCommandState = ETTTASKOPERATIONSTATELOADDING;
            [command.EDCommandManager commandFeedbackSteps:command];
            //            [self.courseContentViewController performTask:commond];
        
    }

}
-(void)restorePaper:(ETTRestoreCommand *)command
{
    NSDictionary * dic = command.EDListModel.EDDisasterDic;
    if (dic )
    {
        NSDictionary * userinfoDic = [dic valueForKey:@"userInfo"];
        if (userinfoDic)
        {
            [self jumpPageToCourseView:command.EDListModel.EDTitle withName:[userinfoDic valueForKey:@"courseId"]];
            command.EDEntity = self.courseContentViewController ;
            command.EDCommandState = ETTTASKOPERATIONSTATELOADDING;
            [command.EDCommandManager commandFeedbackSteps:command];
            //            [self.courseContentViewController performTask:commond];
        }
    }

}

@end
