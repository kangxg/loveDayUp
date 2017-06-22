//
//  ETTStudentClassPerformanceVCTR.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentClassPerformanceVCTR.h"
#import "AXPUserInformation.h"
#import "ETTStudentClassSelectView.h"
#import "ETTRedisBasisManager.h"
#import "ETTStudentManageViewModel.h"
#import "ETTSideNavigationManager.h"
#import "ETTLeftTitleButton.h"
#import "iToast.h"

@interface ETTStudentClassPerformanceVCTR ()
{
    ETTStudentManageViewModel * _mModel;
}
@property (nonatomic,retain)ETTLeftTitleButton    * MVSelectBtn;
@property (nonatomic,retain)ETTStudentClassSelectView *  MVClassListView;
@end

@implementation ETTStudentClassPerformanceVCTR
@synthesize EVBackButton = _EVBackButton;
-(void)initData
{
    [super initData];
    self.EVModel  = [[ETTStuClassPerformanceModel alloc]init];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createClassListView];
    [self updateStuedentList];
//    [self requestNetWork];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNotificationWithCP01:) name:kREDIS_COMMAND_TYPE_CP_01 object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ////////////////////////////////////////////////////////
    /*
     new      : add
     time     : 2017.4.20 11:30
     modifier : 康晓光
     version  ：Epic-0410-AIXUEPAIOS-1190
     branch   ：Epic-0410-AIXUEPAIOS-1190/AIXUEPAIOS-1241
     problem  : 教师账号互挤后，学生账号切换学生账号后，学生的课堂表现数据为空
     describe :  每次页面显示都要请求一次，防止出现请求失败页面无显示问题，原来在父类viewdidload中调用请求，老师端保持原来请求顺序
     */
    /////////////////////////////////////////////////////
    [self requestNetWork];

}

-(void)processNotificationWithCP01:(NSNotification *)notificaiton
{
    NSDictionary *messageDic = notificaiton.object;
    [self reciveClassPeformacneMsg:messageDic];
}

#pragma mark ----- 学生端更新学生课堂表现 ------
-(void)updateStuedentList
{

    NSString * key = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_INTEGRAL,[[AXPUserInformation sharedInformation] classroomId]];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    WS(weakSelf);
    [redisManager redisGet:key respondHandler:^(id value, id error) {
        if (!error) {
            NSLog(@"学生刷新课堂表现，成功拉取数据  %@",value);
            NSDictionary * dic = [ETTRedisBasisManager getDictionaryWithJSON:value];
            [weakSelf reciveClassPeformacneMsg:dic];
        } else {
            NSLog(@"学生刷新课堂表现，拉取数据失败!");
        }
    }];
 
}

-(void)creatBackBtn
{
    if (_EVBackButton ==nil)
    {
        //左侧菜单按钮
        UIButton *menuButton = [UIButton new];
        [menuButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
        [menuButton setTitle:@"课堂表现" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 100);//image距离button边框的距离
        menuButton.titleEdgeInsets = UIEdgeInsetsMake(2, -15, 2, 15);
        [menuButton addTarget:self action:@selector(menuButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        menuButton.frame = CGRectMake(15, 12, 120, 20);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
        
        _EVBackButton = menuButton;
        
    }
}

//左边我的课程菜单
- (void)menuButtonDidClick {
    
    [[ETTSideNavigationManager sharedSideNavigationManager]changeNavigaitonsStatus];
}
-(ETTLeftTitleButton *)MVSelectBtn
{
    if (_MVSelectBtn == nil)
    {
        _MVSelectBtn = [[ETTLeftTitleButton alloc]initWithFrame:CGRectZero];
        _MVSelectBtn.EVDelegate = self;
      
    }
    return _MVSelectBtn;
}
-(void)selectClass
{
    
    if (!_MVSelectBtn.EVViewSelected)
    {
        [_MVClassListView hidenView];
    }
    else
    {
        [_MVClassListView show];
    }
}
-(ETTStudentClassSelectView *)MVClassListView
{
    if (_MVClassListView == nil)
    {
        _MVClassListView  = [[ETTStudentClassSelectView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88)];
        _MVClassListView.EVDelegate = self;
        _MVClassListView.EVModel = self.EVModel;
    }
    return _MVClassListView;
}

-(void)createClassListView
{
    [self.view addSubview:self.MVClassListView];
    [self.view bringSubviewToFront:self.MVClassListView];
    
}
-(void)reciveClassPeformacneMsg:(NSDictionary *)dic
{

    WS(weakSelf);
    [self.EVModel processingDataClassMap:[dic valueForKey:@"userInfo"] withComplete:^(ETTProcessingDataState state) {
        [weakSelf.EVCurrentPerView reloadView];
        [weakSelf.EVAccumulativePerView reloadView];
    }];


}
#pragma mark ----------创建头部班级选择视图------------
/**
 Description  创建头部班级选择视图
 */
-(void)createTitleView
{
     self.navigationItem.titleView= self.MVSelectBtn;
}
#pragma mark ----------获取列表视图需要的班级ID------------

/**
 Description  列表 视图 获取数据源 班级id

 @param object 当前列表视图或者 累计列表视图

 @return 班级id
 */
-(NSString *)pGetDataMark:(id)object
{
    if ([object isKindOfClass:[ETTCurrentClassPerformanceView class]])
    {
        if ([self.EVModel getClassCount])
        {
            
            return   [self.EVModel getClassId:_MVClassListView.EVSelectIndex];
        }
    }
    return @"";
}

#pragma mark ----------刷新 头部班级选择按钮 ------------
-(void)resetSelectView
{
    if ([_MVSelectBtn.EVTitleLabe.text isEqualToString:@"选择班级"])
    {
       
        
            NSString * name = [self.EVModel getClassName:_MVClassListView.EVSelectIndex];
            [_MVSelectBtn setEVTitle:name];
            [_MVSelectBtn resetViewCanSelect:[self.EVModel getClassCount]];
            _MVClassListView.EVSelectIndex = 0;

            [self.EVCurrentPerView reloadView];
    
        
    }
    else
    {
        
         [self.EVCurrentPerView reloadView];
    }
}

#pragma mark ---------- 视图选择后回调------------

/**
 Description    视图选择后回调

 @param object
 */
-(void)pViewSelected:(id)object
{
    if ([object isKindOfClass:[ETTStudentClassSelectView class]] )
    {
        if (_MVClassListView.EVSelectIndex<[self.EVModel getClassCount])
        {
            [_MVSelectBtn setEVTitle:[self.EVModel getClassName:_MVClassListView.EVSelectIndex]];

            _MVSelectBtn.EVViewSelected =  !_MVSelectBtn.EVViewSelected;
            
             [self.EVCurrentPerView reloadView];
            [self changeToView:[self getPageIndex]];
            
        }
      
    }
    else if ([object isKindOfClass:[ETTLeftTitleButton class]])
    {
        [self selectClass];
    }
}

#pragma mark ---------- 网络请求 ------------
-(void)requestNetWork
{
   
    NSString * classroomId =   [[AXPUserInformation sharedInformation] classroomId];
    //    NSDictionary * dic = tarr.firstObject;
    NSString * jid = [[AXPUserInformation sharedInformation] jid];
    NSString *urlBody = @"axpad/classroom/getAllPerformanceInClassroom.do";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];
    NSMutableDictionary  *param = [[NSMutableDictionary alloc]init];
    [param setValue:jid forKey:@"jid"];
    [param setValue:classroomId forKey:@"classroomId"];
//    [param setValue:self.EVModel.EDClassroomId forKey:@"classroomId"];
    WS(weakSelf);
    [[ETTNetworkManager sharedInstance]GET:urlString Parameters:param responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        NSInteger state = [[responseDictionary valueForKey:@"result"] integerValue] ;
        if (state == 1)
        {
            NSDictionary * dataDic = [responseDictionary valueForKey:@"data"];
            NSArray * classArr = [dataDic valueForKey:@"classList"];
            
            [weakSelf.EVModel setAccumulativeClassUser:classArr];
            
          
            weakSelf.EVCurrentPerView.EVModel = self.EVModel;
            weakSelf.EVAccumulativePerView.EVModel = self.EVModel;
            
           [weakSelf resetSelectView];
            
            
        }
        else
        {
            [[iToast makeText:[responseDictionary valueForKey:@"msg"]] show];
            [weakSelf.EVCurrentPerView endRefreshView];
            [weakSelf.EVAccumulativePerView endRefreshView];
        }
    }];
    
    
}

#pragma mark ---------- 活动 或者 点击页面切换后回调 ------------
-(void)changeToView:(NSInteger)index
{
  
    if (index == 1)
    {
         [self.EVAccumulativePerView reloadView];
    }
}

#pragma mark ----------  获取 列表视图 显示数据源 ------------

/**
 Description  获取 列表视图 显示数据源 现在主要用于累计视图

 @param object 列表视图

 @return 显示的数据源
 */
-(NSArray *)pGetDataSource:(id)object
{
    if ([object isKindOfClass:[ETTAccumulativePerformanceView class]])
    {
        NSString * cid = [self.EVModel getClassId:_MVClassListView.EVSelectIndex];
        NSArray * arr = [self.EVModel getAccumulativeClassSession:cid];
        return arr;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kREDIS_COMMAND_TYPE_CP_01 object:nil];
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
