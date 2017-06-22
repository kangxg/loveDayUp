//
//  ETTExaminationPaperViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherTestPaperViewController.h"
#import "ETTTestPaperCell.h"
#import "MJRefresh.h"
#import <MJExtension.h>
#import "TestPaperModel.h"
#import "ETTTeacherTestPaperDetailViewController.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTRestoreCommand.h"
#import "ETTAnouncement.h"
#define EDGE_INSETS_MARGIN_WIDTH ((27.000 / 1024) * kSCREEN_WIDTH)
#define EDGE_INSETS_MARGIN_HEIGHT ((44.000 / 768) * kSCREEN_HEIGHT)


@interface ETTTeacherTestPaperViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (strong, nonatomic) UIImageView      *imageView;

@property (strong, nonatomic) UILabel          *firstLabel;

@property (strong, nonatomic) UILabel          *secondLabel;

@property (strong, nonatomic) UIImageView      *contentView;

@property (strong, nonatomic) UICollectionView *testPaperCollectionView;

@property (strong, nonatomic) NSMutableArray   *testPaperArray;

@end

static NSString * const testPaperCellReuseIdentifier = @"testPaperCellReuseIdentifier";

@implementation ETTTeacherTestPaperViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setupSubview];
    
    self.view.backgroundColor = kETTRANDOM_COLOR;
    
    [self setupRefresh];
    [self initWithSubviewWithoutCourse];
    
    
//    [ETTAnouncement reportGovernmentRestoreTask:self withState:ETTTASKOPERATIONSTATELOADCOMPLETE];
}

- (NSMutableArray *)testPaperArray {
    if (!_testPaperArray) {
        _testPaperArray = [NSMutableArray array];
    }
    return _testPaperArray;
}

- (void)setupSubview {
    
    //容器
    _contentView                                          = [[UIImageView alloc]init];
    _contentView.image                                    = [UIImage imageNamed:@"course_list_background"];
    _contentView.userInteractionEnabled                   = YES;
    _contentView.frame                                    = self.view.frame;
    [self.view addSubview:_contentView];

    //CollectionView
    UICollectionViewFlowLayout *flowLayout                = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection                            = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset                               = UIEdgeInsetsMake(EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT - 20, EDGE_INSETS_MARGIN_WIDTH);
    _testPaperCollectionView                              = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height - 64 - EDGE_INSETS_MARGIN_HEIGHT) collectionViewLayout:flowLayout];
    _testPaperCollectionView.backgroundColor              = [UIColor clearColor];
    _testPaperCollectionView.scrollsToTop                 = YES;
    _testPaperCollectionView.showsVerticalScrollIndicator = NO;
    _testPaperCollectionView.delegate                     = self;
    _testPaperCollectionView.dataSource                   = self;

    //注册cell
    [_testPaperCollectionView registerClass:[ETTTestPaperCell class] forCellWithReuseIdentifier:testPaperCellReuseIdentifier];

    [_contentView addSubview:_testPaperCollectionView];

    
}

/**
 *  没有试卷
 */
- (void)initWithSubviewWithoutCourse {
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat imageViewX        = (212.000 / 1024) * kSCREEN_WIDTH;
    CGFloat imageViewY        = ((133.000 - 64) / 768) * kSCREEN_HEIGHT;
    CGFloat imageViewWidth    = (600.000 / 1024) * kSCREEN_WIDTH;
    CGFloat imageViewHeight   = (400.000 / 768) * kSCREEN_HEIGHT;

    UIImageView *imageView    = [[UIImageView alloc]init];
    imageView.frame           = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    imageView.centerX         = self.view.centerX;
    imageView.hidden          = YES;
    imageView.image           = [UIImage imageNamed:@"course_without"];
    [self.view addSubview:imageView];
    self.imageView            = imageView;

    UILabel *firstLabel       = [[UILabel alloc]init];
    firstLabel.text           = @"您暂时还没有添加任何课程资料";
    firstLabel.hidden         = YES;
    firstLabel.textColor      = kF8_COLOR;
    firstLabel.font           = [UIFont systemFontOfSize:20.0];
    firstLabel.y              = CGRectGetMaxY(imageView.frame) + (70.000 / 768) * kSCREEN_HEIGHT;
    [firstLabel sizeToFit];
    firstLabel.centerX        = self.view.centerX;
    [self.view addSubview:firstLabel];
    self.firstLabel           = firstLabel;

    UILabel *secondLabel      = [[UILabel alloc]init];
    secondLabel.text          = @"请通过电脑pc端登录\"爱学课堂\"对班级课件资料进行添加";
    secondLabel.textColor     = kF8_COLOR;
    secondLabel.hidden        = YES;
    secondLabel.font          = [UIFont systemFontOfSize:15.0];
    secondLabel.y             = CGRectGetMaxY(firstLabel.frame) + (25.000 / 768) * kSCREEN_HEIGHT;
    [secondLabel sizeToFit];
    secondLabel.centerX       = self.view.centerX;
    [self.view addSubview:secondLabel];
    self.secondLabel          = secondLabel;
}

/**
 *  设置刷新
 */
- (void)setupRefresh {
    
    //下拉header
    MJRefreshNormalHeader *header          = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden     = YES;

    //设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateFinish];

    //设置字体
    header.stateLabel.font                 = [UIFont systemFontOfSize:13.0];
    header.stateLabel.textColor            = kF2_COLOR;

    //马上进入刷新状态
    [header beginRefreshing];

    //设置刷新控件
    self.testPaperCollectionView.mj_header = header;

}

//下拉刷新
- (void)loadNewData {
    
    
    // 1 .模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UICollectionView *collectionView = self.testPaperCollectionView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getCoursewareData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [collectionView.mj_header endRefreshing];
    });
}

/**
 *  获取课件列表
 */
- (void)getCoursewareData {
    
    NSString *listUrlString             = [NSString stringWithFormat:@"%@%@",SERVER_HOST,getTestPageList];

    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"classroomId":userInformation.classroomId,
                             @"courseId":self.courseId
                             };
    
    [[ETTNetworkManager sharedInstance]GET:listUrlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        if (error) {
            
            NSLog(@"获取课件列表错误原因:%@",error);
            
            [self.view toast:@"糟糕,网络连接出错"];
            
        } else {
            
            NSInteger result = [[responseDictionary objectForKey:@"result"] integerValue];
            
            if (result == 1) {
                
                NSArray *testPaperList = [[responseDictionary objectForKey:@"data"]objectForKey:@"testPaperList"];

                [self.testPaperArray removeAllObjects];
                
                for (NSDictionary *dict in testPaperList) {
                    TestPaperModel *testPaperModel = [TestPaperModel mj_objectWithKeyValues:dict];
                    [self.testPaperArray addObject:testPaperModel];
                }
                
                if (!self.testPaperArray.count) {
                    self.imageView.hidden   = NO;
                    self.contentView.hidden = YES;
                    self.firstLabel.hidden  = NO;
                    self.secondLabel.hidden = NO;
                } else {
                    [self.testPaperCollectionView reloadData];
                }
                
            }
            
            if (result == 2) {//课堂已关闭
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:kCLASS_CLOSED object:nil];
                [ETTUserInformationProcessingUtils notifyTeacherExit];
            }

        
        }
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.testPaperArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ETTTestPaperCell *cell                = [collectionView dequeueReusableCellWithReuseIdentifier:testPaperCellReuseIdentifier forIndexPath:indexPath];
    cell.testPaperModel                   = self.testPaperArray[indexPath.item];
    cell.testPaperNameLabel.textAlignment = NSTextAlignmentCenter;

    [cell.subjectiveItemNumButton addTarget:self action:@selector(subjectiveItemNumButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)subjectiveItemNumButtonDidClick {
    
    NSLog(@"按钮点击了=======");
    
}

//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((220.000 / 1024) * kSCREEN_WIDTH, (166.000 / 768) * kSCREEN_HEIGHT);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (30.000 / 1024) * kSCREEN_WIDTH;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return (30.000 / 1024) * kSCREEN_WIDTH;;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了");
    
    ETTTeacherTestPaperDetailViewController *testPaperDetail = [[ETTTeacherTestPaperDetailViewController alloc]init];
    TestPaperModel *testPaperModel                           = self.testPaperArray[indexPath.item];

    testPaperDetail.navigationTitle                          = testPaperModel.testPaperName;

    testPaperDetail.courseId                                 = self.courseId;

    testPaperDetail.testPaperId                              = testPaperModel.testPaperId;

    testPaperDetail.testPaperName                            = testPaperModel.testPaperName;
    /*
     @time:2016.12.12 修改
     @auth:康晓光
     @describe:用于集中处理 门卫系统  等此类对ETTBackToPageManager 操作更改完成后
     */
    if (self.EVManagerVCTR)
    {
        //1 等此类对ETTBackToPageManager 操作更改完成后 使用此方法 注释 2
        //  详细参考 ETTTeacherCoursewareViewController  collectionView:didSelectItemAtIndexPath: 方法中615-687 行
//        ETTViewController * vctr =[ETTBackToPageManager sharedManager].pushingVc;
        //2 等此类对ETTBackToPageManager 操作更改完成后 使用 1方法 注释 此方法
        ETTViewController * vctr = testPaperDetail;
        [self.EVManagerVCTR managePushViewController:vctr animated:YES];
    }
    
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

    NSDictionary * dic = restoreCommand.EDListModel.EDDisasterDic;
    if (dic )
    {
        
        NSDictionary * userinfoDic = [dic valueForKey:@"userInfo"];
        if (userinfoDic)
        {
            ETTTeacherTestPaperDetailViewController *testPaperDetail = [[ETTTeacherTestPaperDetailViewController alloc]init];
            testPaperDetail.navigationTitle                          = [userinfoDic valueForKey:@"testPaperName"];
       
            testPaperDetail.EDSuperiorTitle = self.EDSuperiorTitle;
            
            testPaperDetail.courseId = [userinfoDic valueForKey:@"courseId"];
            testPaperDetail.testPaperId = [userinfoDic valueForKey:@"testPaperId"];
            testPaperDetail.testPaperName  = [userinfoDic valueForKey:@"testPaperName"];

            commond.EDEntity = testPaperDetail;
            commond.EDCommandState = ETTTASKOPERATIONSTATELOADDING;
            [commond.EDCommandManager commandFeedbackSteps:commond];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.EVManagerVCTR)
                {
                    ETTViewController * vctr = testPaperDetail;
                    [self.EVManagerVCTR managePushViewController:vctr animated:false];
                }
            });


        }
    }
   
}
@end
