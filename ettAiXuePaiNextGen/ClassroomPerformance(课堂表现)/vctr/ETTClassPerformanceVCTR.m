//
//  ETTClassPerformanceVCTR.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassPerformanceVCTR.h"
#import "GlobelDefine.h"
#import "ETTUSERDefaultManager.h"
#import "ETTScenePorter.h"
@interface ETTClassPerformanceVCTR ()<UIScrollViewDelegate>
@property(nonatomic,retain)UISegmentedControl * MVSegMentView;
@property(nonatomic,retain)UIScrollView       * MVScrollView;
@end

@implementation ETTClassPerformanceVCTR
@dynamic EVBackButton;
-(id)init
{
    if (self = [super init])
    {
        [self initData];
       
    }
    return self;
}
-(void)initData
{
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#fafafa"];
    
    [self setupNavBar];
    [self createTitleView];
    [self createSegmentedView];
    [self createScrollView];
    [self createPagesView];
//    [self requestNetWork];
    
    // Do any additional setup after loading the view.
}
-(void)requestNetWork
{

    
}
- (void)setupNavBar {
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    
    [self creatBackBtn];

    
   
}

-(void)creatBackBtn
{
}

-(void)createTitleView
{
    
}

-(void)createSegmentedView
{
    if (_MVSegMentView == nil)
    {
        _MVSegMentView = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"本节",@"累计", nil]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: kC1_COLOR,NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
        [_MVSegMentView setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
        [_MVSegMentView setTitleTextAttributes:dic1 forState:UIControlStateSelected];
        _MVSegMentView.frame=CGRectMake((kSCREEN_WIDTH -(270.000 / 1024) * kSCREEN_WIDTH)/2,10, (270.000 / 1024) * kSCREEN_WIDTH, (29.000 / 768) * kSCREEN_HEIGHT);
        [_MVSegMentView setSelectedSegmentIndex:0];
        [_MVSegMentView setTintColor:kC1_T80_COLOR];
       
        [_MVSegMentView addTarget:self action:@selector(changeSegControl:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_MVSegMentView];
        
        
    }
}
-(void)createPagesView
{
    [self.MVScrollView addSubview:self.EVCurrentPerView];
    [self.MVScrollView addSubview:self.EVAccumulativePerView];
}



-(ETTCurrentClassPerformanceView *)EVCurrentPerView
{
    if (_EVCurrentPerView == nil)
    {
        _EVCurrentPerView = [[ETTCurrentClassPerformanceView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.MVScrollView.height)];
        _EVCurrentPerView.EVDelegate = self;
        
        
    }
    return _EVCurrentPerView;
}

-(ETTAccumulativePerformanceView *)EVAccumulativePerView
{
    if (_EVAccumulativePerView == nil)
    {
        _EVAccumulativePerView = [[ETTAccumulativePerformanceView alloc]initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.MVScrollView.height)];
        _EVAccumulativePerView.EVDelegate = self;
        
        
        
    }
    return _EVAccumulativePerView;
}

-(void)pEvenHandler:(id)object withCommandType:(NSInteger)commandType
{
    if (commandType == ETTTEACHERMOMMANDENDREFRESHVIEW)
    {
        if ([self.EVModel haveClassPerformace] == false)
        {
            [self requestNetWork];
        }
        else
        {
            [(ETTPerformanceView *)object  endRefreshView];
        }
    }
}
#pragma -------- 状态栏分段按钮选择回调 --------
-(void)changeSegControl:(UISegmentedControl*)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    [_MVScrollView setContentOffset:CGPointMake(kSCREEN_WIDTH*index,0 ) animated:YES];
    [self changeToView:index];
    
}


-(void)createScrollView
{
    if (_MVScrollView == nil)
    {
       _MVScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.MVSegMentView.v_bottom +12, kSCREEN_WIDTH, self.view.height-(self.MVSegMentView.v_bottom +12+20))];
        
        _MVScrollView.pagingEnabled = YES;
        _MVScrollView.delegate      = self;
        //取消scrollView滚动到边缘的弹簧效果
        _MVScrollView.bounces = YES;
        //隐藏水平滚动条
        _MVScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_MVScrollView];

        [_MVScrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * 2, _MVScrollView.frame.size.height)];
        [_MVScrollView setContentOffset:CGPointMake(0,0) animated:false];

    }
}
-(void)changeToView:(NSInteger )index
{
    
}

-(NSInteger )getPageIndex
{
    return  _MVScrollView.contentOffset.x/kSCREEN_WIDTH;
}
#pragma mark
#pragma mark ------ ScrollView 回调 ---------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSUInteger page = [self pageCalWithScrollView:scrollView];
//    self.MSelectIndex = page;
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  page  = scrollView.contentOffset.x/kSCREEN_WIDTH;
    [_MVSegMentView setSelectedSegmentIndex:page];
    [self changeToView:page];

}

-(NSUInteger)pageCalWithScrollView:(UIScrollView *)scrollView{
    
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    return page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
