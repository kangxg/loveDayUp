//
//  ETTTeacherClassPerformanceVCTR.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherClassPerformanceVCTR.h"
#import "ETTUSERDefaultManager.h"
#import "UIView+Toast.h"
#import "ETTScenePorter.h"
@interface ETTTeacherClassPerformanceVCTR ()

@end

@implementation ETTTeacherClassPerformanceVCTR
@synthesize EVBackButton = _EVBackButton;
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self requestNetWork];
    self.EVCurrentPerView.EVModel =self.EVModel;
}

-(void)creatBackBtn
{
    if (_EVBackButton ==nil)
    {
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
        [backButton addTarget:self action:@selector(clickBackHandle) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        _EVBackButton = backButton;
        
    }
}
-(void)clickBackHandle
{
    [[ETTScenePorter shareScenePorter]removeGurad:self.EVGuardModel];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData
{
    [super initData];
    
}
-(void)requestNetWork
{
    NSArray * arr =  [ETTUSERDefaultManager getIdentityArray];
    NSDictionary * dic = [arr firstObject];
    if (!dic)
    {
        return;
    }
    NSString * jid = [dic valueForKey:@"jid"];
    NSString *urlBody = @"axpad/classroom/getAllPerformanceInClassroom.do";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];
    NSMutableDictionary  *param = [[NSMutableDictionary alloc]init];
    [param setValue:jid forKey:@"jid"];
    [param setValue:self.EVModel.EDClassroomId forKey:@"classroomId"];
    WS(weakSelf);
    [[ETTNetworkManager sharedInstance]GET:urlString Parameters:param responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        if ([[responseDictionary valueForKey:@"result"] integerValue] == 1)
        {
            NSDictionary * dataDic = [responseDictionary valueForKey:@"data"];
            NSArray * classArr = [dataDic valueForKey:@"classList"];
            [weakSelf.EVModel setAccumulativeClassUser:classArr];
            weakSelf.EVAccumulativePerView.EVModel = weakSelf.EVModel;
            [weakSelf.EVCurrentPerView endRefreshView];
            [weakSelf.EVAccumulativePerView endRefreshView];
        }
        else
        {
            [weakSelf.view showToast:[responseDictionary valueForKey:@"msg"]];
            [weakSelf.EVCurrentPerView endRefreshView];
            [weakSelf.EVAccumulativePerView endRefreshView];
        }
    }];
 }

-(void)changeToView:(NSInteger)index
{
    
    if (index == 1)
    {
        [self.EVAccumulativePerView reloadView];
    }
}
-(NSString *)pGetDataMark:(id)object
{
    if ([object isKindOfClass:[ETTCurrentClassPerformanceView class]])
    {
      return   self.EVModel.EDClassModelArr.firstObject.classId;
    }
    return @"";
}
-(NSArray *)pGetDataSource:(id)object
{
    if ([object isKindOfClass:[ETTAccumulativePerformanceView class]])
    {
        return [self.EVModel getAccumulativeClassSession:nil];
    }
    return nil;
}
-(void)createTitleView
{
     self.navigationItem.title = @"课堂表现";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
