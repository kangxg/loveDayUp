//
//  ETTStudentCoursewareViewController.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/**
 Description 学生课件

 */
#import "ETTStudentCoursewareViewController.h"
#import "ETTStudentCoursewareTextTypeCell.h"
#import "ETTStudentCoursewareMediaTypeCell.h"
#import "ETTCoursewareTitleHeader.h"
#import "ETTCoursewareLineHeader.h"
#import "ETTDownloadManager.h"
#import "ETTDownloadUtility.h"
#import "DACircularProgressView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CoursewareTextTypeModel.h"
#import "CoursewareMediaTypeModel.h"
#import "MJRefresh.h"

#import "ETTStudentVideoAudioViewController.h"
#import "ETTStudentImageDetailViewController.h"

#import "ReaderViewController.h"
#import "ETTBackToPageManager.h"
#import "ETTRememberCourseIDManager.h"

#import "ETTStudentCourseContentViewController.h"
#import "ETTSideNavigationViewController.h"
#import "ETTJudgeIdentity.h"
#import "ETTCoursewarePresentViewControllerManager.h"



#define EDGE_INSETS_MARGIN_WIDTH ((27.000 / 1024) * kSCREEN_WIDTH)
#define EDGE_INSETS_MARGIN_HEIGHT ((27.000 / 768) * kSCREEN_HEIGHT)

typedef NS_ENUM(NSInteger, TeacherCoursewareType) {
    Word = 1,
    Pdf = 2,
    Img = 3,
    Video = 4,
    Audio = 5,
    Ppt = 6,
    Excel = 7,
    Txt = 8
};

@interface ETTStudentCoursewareViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,ETTDownloadDelegate,ETTCollectionViewCellDelegate>

@property (strong, nonatomic) UIImageView         *imageView;

@property (strong, nonatomic) UILabel             *firstLabel;

@property (strong, nonatomic) UILabel             *secondLabel;

@property (strong, nonatomic) UICollectionView    *coursewareCollectionView;

@property (strong, nonatomic) UIImageView         *contentView;

@property (strong, nonatomic) ETTDownloadManager  *downloadManager;

@property (strong, nonatomic) NSMutableDictionary *dict;

@property (strong, nonatomic) ETTDownloadModel    *currentDownloadModel;

@property (strong, nonatomic) NSMutableArray      *wordArray;//word数据源

@property (strong, nonatomic) NSMutableArray      *PDFArray;//PDF数据源

@property (strong, nonatomic) NSMutableArray      *imgArray;//img数据源

@property (strong, nonatomic) NSMutableArray      *videoArray;//video数据源

@property (strong, nonatomic) NSMutableArray      *audioArray;//audio数据源

@property (strong, nonatomic) NSMutableArray      *pptArray;//ppt数据源

@property (strong, nonatomic) NSMutableArray      *excelArray;//excel数据源

@property (strong, nonatomic) NSMutableArray      *txtArray;//txt数据源

@property (strong, nonatomic) NSMutableArray      *coursewareArray;//课件总数据源

@property (strong, nonatomic) NSString            *ETTDownloadCache;//文件缓存路径


@property (nonatomic,retain)NSCache          *  MVCellCache;

@end



//cell重用id
static NSString * const textTypeReuseIdentifier     = @"textTypeReuseIdentifier";
static NSString * const mediaTypeReuseIdentifier    = @"mediaTypeReuseIdentifier";

//组头重用id
static NSString * const sectionTitleReuseIdentifier = @"sectionTitleReuseIdentifier";
static NSString * const sectionLineReuseIdentifier  = @"sectionLineReuseIdentifier";


@implementation ETTStudentCoursewareViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _MVCellCache               = [[NSCache alloc]init];
    self.view.backgroundColor  = kETTRANDOM_COLOR;

    [self initDownLoad];
    
    [self setupSubview];

    [self setupRefresh];

    [self initWithSubviewWithoutCourse];

    NSString *cachePath        = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];

    NSString *ETTDownloadCache = [cachePath stringByAppendingPathComponent:@"ETTDownloadCache"];

    self.ETTDownloadCache      = ETTDownloadCache;
    
}

-(void)initDownLoad
{
    ETTDownloadManager * manager = [ETTDownloadManager manager];
    [manager resetTasks];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/**
 *  初始化子控件
 */
- (void)setupSubview {
    
    //容器
    _contentView                                           = [[UIImageView alloc]init];
    _contentView.image                                     = [UIImage imageNamed:@"course_list_background"];
    _contentView.userInteractionEnabled                    = YES;
    _contentView.frame                                     = self.view.frame;
    [self.view addSubview:_contentView];

    //CollectionView
    UICollectionViewFlowLayout *flowLayout                 = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection                             = UICollectionViewScrollDirectionVertical;
    _coursewareCollectionView                              = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height - 64 - EDGE_INSETS_MARGIN_HEIGHT - 20) collectionViewLayout:flowLayout];
    _coursewareCollectionView.backgroundColor              = [UIColor clearColor];
    _coursewareCollectionView.scrollsToTop                 = YES;
    _coursewareCollectionView.showsVerticalScrollIndicator = NO;
    _coursewareCollectionView.delegate                     = self;
    _coursewareCollectionView.dataSource                   = self;

    //注册cell
    [_coursewareCollectionView registerClass:[ETTStudentCoursewareTextTypeCell class] forCellWithReuseIdentifier:textTypeReuseIdentifier];
    [_coursewareCollectionView registerClass:[ETTStudentCoursewareMediaTypeCell class] forCellWithReuseIdentifier:mediaTypeReuseIdentifier];

    //注册组头
    [_coursewareCollectionView registerClass:[ETTCoursewareTitleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionTitleReuseIdentifier];
    [_coursewareCollectionView registerClass:[ETTCoursewareLineHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionLineReuseIdentifier];

    [_contentView addSubview:_coursewareCollectionView];
    
}

/**
 *  没有课件
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


- (NSMutableArray *)wordArray {
    
    if (_wordArray == nil) {
        _wordArray = [NSMutableArray array];
    }
    return _wordArray;
}

- (NSMutableArray *)PDFArray {
    
    if (_PDFArray == nil) {
        _PDFArray = [NSMutableArray array];
    }
    return _PDFArray;
}

- (NSMutableArray *)imgArray {
    
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray *)videoArray {
    
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (NSMutableArray *)audioArray {
    
    if (_audioArray == nil) {
        _audioArray = [NSMutableArray array];
    }
    return _audioArray;
}

- (NSMutableArray *)pptArray {
    
    if (_pptArray == nil) {
        _pptArray = [NSMutableArray array];
    }
    return _pptArray;
}

- (NSMutableArray *)excelArray {
    if (_excelArray == nil) {
        _excelArray = [NSMutableArray array];
    }
    
    return _excelArray;
}

- (NSMutableArray *)txtArray {
    if (_txtArray == nil) {
        _txtArray = [NSMutableArray array];
    }
    return _txtArray;
}

- (NSMutableArray *)coursewareArray {
    
    if (!_coursewareArray) {
        _coursewareArray = [NSMutableArray arrayWithObjects:self.wordArray,self.txtArray,self.excelArray,self.PDFArray,self.pptArray,self.videoArray,self.audioArray,self.imgArray, nil];
    }
    return _coursewareArray;
}



/**
 *  设置刷新
 */
- (void)setupRefresh {
    
    //下拉header
    MJRefreshNormalHeader *header           = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden      = YES;

    //设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateFinish];

    //设置字体
    header.stateLabel.font                  = [UIFont systemFontOfSize:13.0];
    header.stateLabel.textColor             = kF2_COLOR;

    //马上进入刷新状态
    [header beginRefreshing];

    //设置刷新控件
    self.coursewareCollectionView.mj_header = header;
    
}

//下拉刷新
- (void)loadNewData {
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.4.18  15:30
     modifier : 康晓光
     version  ：bugfix/Epic-0417-AIXUEPAIOS-1218
     branch   ：bugfix/Epic-0417-AIXUEPAIOS-1218／AIXUEPAIOS-1183
     prolem   : 课件下载时，切换到其他课时，下载被取消
     describe : 原来是延迟2秒自动结束，现在改为网络请求返回后结束动画
     
     */
    [self getCoursewareData];
    /////////////////////////////////////////////////////

}

/**
 *  获取课件列表
 */
- (void)getCoursewareData {
    
    NSString *listUrlString             = [NSString stringWithFormat:@"%@%@",SERVER_HOST,getCoursewareListForTeacher];

    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"classroomId":userInformation.classroomId,
                             @"courseId":self.courseId
                             };
    
    [[ETTNetworkManager sharedInstance]GET:listUrlString Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        if (error) {
            
            NSLog(@"获取课件列表错误原因:%@",error);
            
            [self.view toast:@"糟糕,网络连接出错"];
            [self.coursewareCollectionView.mj_header endRefreshing];
            
        } else {
            
            NSInteger result = [[responseDictionary objectForKey:@"result"] integerValue];
            
            
            if (result == 1) {
                
                //文档类型
                NSArray *docList = [[responseDictionary objectForKey:@"data"]objectForKey:@"docList"];
                
                [self.coursewareArray enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
                    [array removeAllObjects];
                }];
                
                
                for (NSDictionary *dict in docList) {
                    
                    CoursewareTextTypeModel *textTypeModel = [CoursewareTextTypeModel mj_objectWithKeyValues:dict];
                    
                    if (textTypeModel.visible == 1) {
                        
                        switch (textTypeModel.coursewareType) {
                            case Word:
                                [self.wordArray addObject:textTypeModel];
                                
                                break;
                            case Pdf:
                                [self.PDFArray addObject:textTypeModel];
                                
                                break;
                            case Excel:
                                [self.excelArray addObject:textTypeModel];
                                break;
                            case Ppt:
                                [self.pptArray addObject:textTypeModel];
                                break;
                            case Txt:
                                [self.txtArray addObject:textTypeModel];
                                break;
                            default:
                                break;
                        }
                    }
                }
                
                
                //多媒体类型
                NSArray *mediaList = [[responseDictionary objectForKey:@"data"]objectForKey:@"mediaList"];
                
                
                for (NSDictionary *dict in mediaList) {
                    CoursewareMediaTypeModel *mediaTypeModel = [CoursewareMediaTypeModel mj_objectWithKeyValues:dict];
                    
                    if (mediaTypeModel.visible == 1) {
                        switch (mediaTypeModel.coursewareType) {
                            case Img:
                                [self.imgArray addObject:mediaTypeModel];
                                break;
                            case Video:
                                [self.videoArray addObject:mediaTypeModel];
                                break;
                            case Audio:
                                [self.audioArray addObject:mediaTypeModel];
                                break;
                                
                            default:
                                break;
                        }

                    }
                }
                
                __block BOOL isCount = NO;
                
                [self.coursewareArray enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull AAstop) {
                        
                        if (obj) {
                            isCount = YES;
                            *stop = YES;
                        }
                    }];
                }];
                
                if (!isCount) {
                    
                    self.imageView.hidden   = NO;
                    self.contentView.hidden = YES;
                    self.firstLabel.hidden  = NO;
                    self.secondLabel.hidden = NO;
                    
                } else {
                    
                    [self.coursewareCollectionView reloadData];
                    
                }
            }
            [self.coursewareCollectionView reloadData];
            [self.coursewareCollectionView.mj_header endRefreshing];
            if (result == 2) {//课堂已关闭
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:kCLASS_CLOSED object:nil];
                [ETTUserInformationProcessingUtils notifyTeacherExit];
            }
            
        }
        
    }];
}

/**
 *  返回有多少组
 *
 *  @param collectionView ;
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _coursewareArray.count;
}

/**
 *  返回每组有多少个
 *
 *  @param collectionView <#collectionView description#>
 *  @param section        <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_coursewareArray objectAtIndex:section]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section <= 4) {
        
        CoursewareTextTypeModel *coursewareTextTypeModel = _coursewareArray[indexPath.section][indexPath.item];
        ETTStudentCoursewareTextTypeCell *cell = [self getCollectionView:collectionView preparedCellForIndexPath:indexPath withData:coursewareTextTypeModel];
        return cell;
        
        
    } else {//音视频大组
        ETTStudentCoursewareMediaTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mediaTypeReuseIdentifier forIndexPath:indexPath];
        cell.coursewareMediaTypeModel           = _coursewareArray[indexPath.section][indexPath.item];

        cell.coursewareButton.tag               = indexPath.section * 10000 + indexPath.item * 10;

        [cell.coursewareButton addTarget:self action:@selector(coursewareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
}
- (ETTStudentCoursewareTextTypeCell *)getCollectionView:(UICollectionView *)collectionView  preparedCellForIndexPath:(NSIndexPath *)indexPath withData:(id)data
{
    
    CoursewareTextTypeModel *coursewareTextTypeModel = data;
    ETTStudentCoursewareTextTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:textTypeReuseIdentifier forIndexPath:indexPath];
    cell.coursewareTextTypeModel        = coursewareTextTypeModel;
    
    
    ETTDownloadManager *manager                  = [ETTDownloadManager manager];
    
    NSString *str                                    = coursewareTextTypeModel.coursewareUrl.lastPathComponent;
    
    NSString *beforeFileName                         = [coursewareTextTypeModel.coursewareUrl substringToIndex:coursewareTextTypeModel.coursewareUrl.length - str.length-1].lastPathComponent;
    
    NSString *fileName                               = [NSString stringWithFormat:@"%@%@",beforeFileName,str];
    
    ETTDownloadModel *downloadModel = [manager getDownloadModel:coursewareTextTypeModel.coursewareUrl];
        //[cell updateDownLoadView:downloadModel];
        
    [manager     resumeDownloadTask:coursewareTextTypeModel.coursewareUrl
                               fileName:fileName downModel:downloadModel
                               progress:^(NSProgress *downloadProgress)
         {
             CGFloat  pro =  1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
             [downloadModel setDownloadState:ETTDownloadStateRunning];
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 // 设置进度条的百分比
                 [downloadModel setDownloadProgress:pro];
                 
                 [cell updateDownLoadView:downloadModel];
             });
         }
                      completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                          if (error)
                          {
                              [downloadModel setDownloadState:ETTDownloadStateFailed];
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  // 设置进度条的百分比
                                  [cell updateDownLoadView:downloadModel];
                                  
                                  [ETTDownLoadProcessingState processingCreateDownloadstate:ETTDOWNLOADTASKSTATEFAILURE];
                                  
                              });
                              
                              
                          }
                          else
                          {
                              
                              [downloadModel setDownloadState:ETTDownloadStateCompleted];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  // 设置进度条的百分比
                                  
                                  
                                  [cell updateDownLoadView:downloadModel];
                                  
                              });
                              
                          }
                          
                      }];
    

    [cell updateDownLoadView:downloadModel];
    cell.EVDelegate = self;
    return cell;
}

/**
 视频播放按钮被点击了

 @param button <#button description#>
 */
- (void)coursewareButtonClick:(UIButton *)button {
    
    ETTStudentVideoAudioViewController *videoVCs                          = [[ETTStudentVideoAudioViewController alloc]init];

    NSIndexPath *indexPath                                                = [NSIndexPath indexPathForItem:(button.tag-(button.tag/10000)*10000)/10 inSection:button.tag/10000];

    CoursewareMediaTypeModel *mediaTypeModel                              = _coursewareArray[indexPath.section][indexPath.item];

    videoVCs.urlString                                                    = mediaTypeModel.coursewareUrl;
    videoVCs.navigationTitle                                              = mediaTypeModel.coursewareName;
    videoVCs.coursewareImg                                                = mediaTypeModel.coursewareImg;
    [ETTCoursewarePresentViewControllerManager sharedManager].isOpenVideo = YES;

    [self.delegate.navigationController pushViewController:videoVCs animated:YES];
}

#pragma mark - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section <= 4) {//文档类型的只需要判断需要不需要下载
        
        CoursewareTextTypeModel *coursewareTextTypeModel = _coursewareArray[indexPath.section][indexPath.item];

        NSString *str                                    = coursewareTextTypeModel.coursewareUrl.lastPathComponent;

        NSString *beforeFileName                         = [coursewareTextTypeModel.coursewareUrl substringToIndex:coursewareTextTypeModel.coursewareUrl.length - str.length-1].lastPathComponent;

        NSString *fileName                               = [NSString stringWithFormat:@"%@%@",beforeFileName,str];

        NSString *filePath                               = [self.ETTDownloadCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];

        BOOL fileIsExist                                 = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (fileIsExist) { //文件存在直接打开课件
            
            ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
            
            if (document) {
                
                ETTSideNavigationViewController *sideNav                = [ETTJudgeIdentity getSideNavigationViewController];
                [sideNav openPDFCoursewareWhitCoverView];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                    //pdf阅读控制器
                ReaderViewController *readerVC                          = [[ReaderViewController alloc]initWithReaderDocument:document];
                [ETTBackToPageManager sharedManager].pushingVc          = readerVC;
                readerVC.navigationTitle                                = coursewareTextTypeModel.coursewareName;

                    //课件id
                readerVC.coursewareID                                   = coursewareTextTypeModel.coursewareId;
                readerVC.coursewareUrl                                  = coursewareTextTypeModel.coursewareUrl;

                [ETTRememberCourseIDManager sharedManager].coursewareID = coursewareTextTypeModel.coursewareId;

                readerVC.modalTransitionStyle                           = UIModalTransitionStyleCrossDissolve;
                    readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.delegate presentViewController:readerVC animated:YES completion:^{
                            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;;
                        }];
                        
                    });
                });
            }
            
        } else { //课件不存在则下载
            
            ETTDownloadManager *manager                  = [ETTDownloadManager manager];
            ETTStudentCoursewareTextTypeCell *cell       = (ETTStudentCoursewareTextTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            ETTDownloadModel *downloadModel = [manager getDownloadModel:coursewareTextTypeModel.coursewareUrl];
            
            ETTDownLoadTaskState  state= [self createCellDownloadTask:downloadModel url:coursewareTextTypeModel.coursewareUrl fileName:fileName withCell:cell];
          
            [cell updateDownLoadView:downloadModel];
//            [cell noticeDownLoadTaskState:state];
            
            [ETTDownLoadProcessingState processingCreateDownloadstate:state];
        }
        
    } else if (indexPath.section == 7){//跳转到图片类型
        
        ETTStudentImageDetailViewController *imageDetailVC = [[ETTStudentImageDetailViewController alloc]init];

        CoursewareMediaTypeModel *mediaTypeModel           = self.coursewareArray[indexPath.section][indexPath.item];
        imageDetailVC.imageURLString                       = mediaTypeModel.coursewareUrl;

        imageDetailVC.navigationTitle                      = mediaTypeModel.coursewareName;
        [self.delegate.navigationController pushViewController:imageDetailVC animated:YES];
        
        
    } else {//跳转到音视频详情
        
        ETTStudentVideoAudioViewController *videoVCs = [[ETTStudentVideoAudioViewController alloc]init];
        CoursewareMediaTypeModel *mediaTypeModel     = self.coursewareArray[indexPath.section][indexPath.item];

        videoVCs.urlString                           = mediaTypeModel.coursewareUrl;
        videoVCs.navigationTitle                     = mediaTypeModel.coursewareName;
        videoVCs.coursewareImg                       = mediaTypeModel.coursewareImg;

        //这个用来标记是否是学生自己手动打开的音视频
        [ETTCoursewarePresentViewControllerManager sharedManager].isOpenVideo = YES;
        
        [self.delegate.navigationController pushViewController:videoVCs animated:YES];
        
    }
    
}
////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 点击cell c创建下载任务
 */
-(ETTDownLoadTaskState )createCellDownloadTask:( ETTDownloadModel *) downloadModel url:(NSString *)url fileName:(NSString *)fileName withCell:( ETTStudentCoursewareTextTypeCell *)cell
{
    ETTDownLoadTaskState  state  = ETTDOWNLOADTASKSTATENONE;
    if (downloadModel == nil)
    {
        return state;
    }
    
    ETTDownloadManager *manager                  = [ETTDownloadManager manager];

    state = [manager downloadTaskWithRequest:url
                                    fileName:fileName
                                   downModel:downloadModel
                                    progress:^(NSProgress *downloadProgress)
             {
                 [downloadModel setDownloadProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
                 [downloadModel setDownloadState:ETTDownloadStateRunning];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // 设置进度条的百分比
                     [cell updateDownLoadView:downloadModel];
                     
                 });
                 
             }
                           completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
             {
                 if (error)
                 {
                     if (downloadModel)
                     {
                         [downloadModel setDownloadState:ETTDownloadStateFailed];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             // 设置进度条的百分比
                             [cell updateDownLoadView:downloadModel];
                             [ETTDownLoadProcessingState processingCreateDownloadstate:ETTDOWNLOADTASKSTATEFAILURE];
                         });
                         
                     }
                     
                 }
                 else
                 {
                     if (downloadModel)
                     {
                         [downloadModel setDownloadState:ETTDownloadStateCompleted];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             // 设置进度条的百分比
                             [cell updateDownLoadView:downloadModel];
                             
                         });
                     }
                     
                 }
             }];
    
    return state;
    
}

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169

 describe : 学生端课件下载更换成AFN
 introduce: cell 上的事件回调
 */

-(void)pCellEventHandle:(UICollectionViewCell *)cell withEvenType:(NSInteger)evenType withInfo:(id)info
{
    switch (evenType)
    {
        case ETTCELLEVENTYPEDOWNCANNEL:
        {
            ETTStudentCoursewareTextTypeCell * couCell = (ETTStudentCoursewareTextTypeCell *)cell;
            if (cell)
            {
                ETTDownloadManager * manager = [ETTDownloadManager manager];
                ETTDownloadModel *model = [manager getDownloadModel:couCell.coursewareTextTypeModel.coursewareUrl];
                [manager cancleWithDownloadModel:model];
                [couCell updateDownLoadView:model];
            }
        }
            break;
            
        default:
            break;
    }
    
}


//取消按钮的点击
- (void)cancelButtonDidClick:(ETTDownloadButton *)button {
    
    NSIndexPath *indexPath                           = button.indexPath;

    CoursewareTextTypeModel *coursewareTextTypeModel = _coursewareArray[indexPath.section][indexPath.item];

    coursewareTextTypeModel.isShowDownloadButton     = NO;

    ETTStudentCoursewareTextTypeCell *cell           = (ETTStudentCoursewareTextTypeCell *)[_coursewareCollectionView cellForItemAtIndexPath:indexPath];

    cell.coursewareTextTypeModel                     = coursewareTextTypeModel;

    ETTDownloadManager *manager                      = [ETTDownloadManager manager];
    ETTDownloadModel *model                          = button.downloadModel;
    [manager cancleWithDownloadModel:model];
}

//课件按钮被点击了
- (void)coursewareButtonDidClick:(ETTDownloadButton *)button
{
    
    ETTDownloadManager *manager = [ETTDownloadManager manager];
    ETTDownloadModel *model     = button.downloadModel;
    [manager cancleWithDownloadModel:model];
}

#pragma mark - ReaderViewController Delegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    
    [self.delegate dismissViewControllerAnimated:YES completion:NULL];
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

//设置组头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([[_coursewareArray objectAtIndex:0] count] == 0 && [[_coursewareArray objectAtIndex:1] count] == 0 && [[_coursewareArray objectAtIndex:2] count] == 0 && [[_coursewareArray objectAtIndex:3] count] == 0&&[[_coursewareArray objectAtIndex:4] count] == 0) {//1-5组都为空的话
        
        if (section == 5) {
            
            return CGSizeMake(kSCREEN_WIDTH, 40);
            
        } else {
            
            return CGSizeMake(kSCREEN_WIDTH, 0.01);
        }
        
    } else if ([[_coursewareArray objectAtIndex:5] count] == 0&& [[_coursewareArray objectAtIndex:6] count] == 0&& [[_coursewareArray objectAtIndex:7] count] == 0){//6-8组
        
        if (section == 0) {
            return CGSizeMake(kSCREEN_WIDTH, 35);
        }
        else {
            return CGSizeMake(kSCREEN_WIDTH, 0.01);
        }
        
    } else {
        if (section == 0) {
            return CGSizeMake(kSCREEN_WIDTH, 35);
        } else if (section == 5) {
            return CGSizeMake(kSCREEN_WIDTH, 40);
        } else {
            return CGSizeMake(kSCREEN_WIDTH, 0.01);
        }
    }
}

//设置header/footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (UICollectionElementKindSectionHeader == kind) {//组头
        
        if ([[_coursewareArray objectAtIndex:0] count] == 0 && [[_coursewareArray objectAtIndex:1] count] == 0 && [[_coursewareArray objectAtIndex:2] count] == 0 && [[_coursewareArray objectAtIndex:3] count] == 0&&[[_coursewareArray objectAtIndex:4] count] == 0) {//1-5组都为空的话
            
            if (indexPath.section == 5) {
                
                ETTCoursewareTitleHeader *titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionTitleReuseIdentifier forIndexPath:indexPath];
                titleHeader.sectionTitleLabel.frame   = CGRectMake(EDGE_INSETS_MARGIN_WIDTH, 12, 80, 40);
                titleHeader.sectionTitleLabel.text    = @"多媒体";
                return titleHeader;
                
            } else {
                
                ETTCoursewareLineHeader *lineHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionLineReuseIdentifier forIndexPath:indexPath];
                return lineHeader;
            }
            
            
        } else if ([[_coursewareArray objectAtIndex:5] count] == 0&& [[_coursewareArray objectAtIndex:6] count] == 0&& [[_coursewareArray objectAtIndex:7] count] == 0){//6-8组全为空
            
            if (indexPath.section == 0) {//0和5组
                
                ETTCoursewareTitleHeader *titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionTitleReuseIdentifier forIndexPath:indexPath];
                titleHeader.sectionTitleLabel.frame   = CGRectMake(EDGE_INSETS_MARGIN_WIDTH, 12, 60, 40);
                titleHeader.sectionTitleLabel.text = @"文档";
                return titleHeader;
                
            }
            else {
                
                ETTCoursewareLineHeader *lineHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionLineReuseIdentifier forIndexPath:indexPath];
                return lineHeader;
            }
            
        } else {
            if (indexPath.section == 0) {//0和5组
                
                ETTCoursewareTitleHeader *titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionTitleReuseIdentifier forIndexPath:indexPath];
                titleHeader.sectionTitleLabel.frame   = CGRectMake(EDGE_INSETS_MARGIN_WIDTH, 12, 60, 40);
                titleHeader.sectionTitleLabel.text = @"文档";
                return titleHeader;
                
            } else if (indexPath.section == 5) {
                
                ETTCoursewareTitleHeader *titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionTitleReuseIdentifier forIndexPath:indexPath];
                titleHeader.sectionTitleLabel.frame   = CGRectMake(EDGE_INSETS_MARGIN_WIDTH, -5, 80, 40);
                titleHeader.sectionTitleLabel.text = @"多媒体";
                return titleHeader;
                
            }
            else {
                
                ETTCoursewareLineHeader *lineHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionLineReuseIdentifier forIndexPath:indexPath];
                return lineHeader;
            }
        }
        
    } else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if ([[_coursewareArray objectAtIndex:0] count] == 0 && [[_coursewareArray objectAtIndex:1] count] == 0 && [[_coursewareArray objectAtIndex:2] count] == 0 && [[_coursewareArray objectAtIndex:3] count] == 0 &&[[_coursewareArray objectAtIndex:4] count] == 0) {//1-5组都为空的话
        
        if (section == 5) {
            
            return UIEdgeInsetsMake(EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
            
        } else {
            if ([[_coursewareArray objectAtIndex:section]count] == 0) {
                
                return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, 0, EDGE_INSETS_MARGIN_WIDTH);
            }
            
            return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
        }
        
    } else if ([[_coursewareArray objectAtIndex:5] count] == 0&& [[_coursewareArray objectAtIndex:6] count] == 0&& [[_coursewareArray objectAtIndex:7] count] == 0){//6-8组全为空
        
        if (section == 0) {
            
            return UIEdgeInsetsMake(EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
        }
        else {
            
            if ([[_coursewareArray objectAtIndex:section]count] == 0) {
                
                return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, 0, EDGE_INSETS_MARGIN_WIDTH);
            }
            
            return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
        }
    } else {
        
        if (section == 0) {
            
            return UIEdgeInsetsMake(EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
            
        } else if (section == 5) {
            
            return UIEdgeInsetsMake(EDGE_INSETS_MARGIN_HEIGHT - 5, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
            
        } else if (section == 4) {
            
            return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT - 5, EDGE_INSETS_MARGIN_WIDTH);
            
        } else {
            
            if ([[_coursewareArray objectAtIndex:section]count] == 0) {
                
                return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, 0, EDGE_INSETS_MARGIN_WIDTH);
            }
            
            return UIEdgeInsetsMake(0, EDGE_INSETS_MARGIN_WIDTH, EDGE_INSETS_MARGIN_HEIGHT, EDGE_INSETS_MARGIN_WIDTH);
        }
    }
}


@end

