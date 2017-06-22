//
//  ETTStudentSelectTeacherVC.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/11.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTStudentSelectTeacherVC.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTRadarIndictorView.h"


@interface ETTStudentSelectTeacherVC ()
@property(nullable, nonatomic,strong) ETTRadarIndictorView *indicatorView;   // 扫描指针
@end

@implementation ETTStudentSelectTeacherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [ETTUSERDefaultManager setCurrentIdentity:@"student"];
    
    [self createUI];
    
//    [self setupRadarView];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kREDIS_MONITOR_SCHOOL_NOTIFICATION object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(instancetype)createUI
{
    ETTStudentSelectTeacherView *studentSelectTeacherView = [[ETTStudentSelectTeacherView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    studentSelectTeacherView.MDelegate = self;
    [self.view addSubview:studentSelectTeacherView];
    
    return self;
}

-(void)returnViewController
{
    [[ETTRedisBasisManager sharedRedisManager]endWorker];
    CGRect rect = [UIScreen mainScreen].bounds;
    ETTLoginViewController *loginVC = [[ETTLoginViewController alloc]initWithType:ETTLoginAfterUsing];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
    [loginVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
    [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
        loginVC.view.frame = rect;
    } completion:^(BOOL finished) {
        NSLog(@"~~~~~~加载结束！！");
    }];
}

#pragma mark - ETTStudentSelectTeacherViewDelegate
-(void)onClickExitButton
{
    [self returnViewController];
}

-(void)onLoginClassroom:(ETTStudentSelectTeacherModel *)model
{
    NSDictionary *identityDic = [ETTUSERDefaultManager getUserTypeDictionaryPro];
    ETTUserIDForLoginModel *studentModel;
    if ([[identityDic allKeys]containsObject:@"student"]) {
        studentModel = identityDic[@"student"];
    }
    ETTSideNavigationViewIdentity identity                       = [ETTUserInformationProcessingUtils determineStudentIdentity:studentModel.jid inClassList:model.classList];
    dispatch_async(dispatch_get_main_queue(), ^{
        ETTSideNavigationViewController *sideNavigationViewControler = [[ETTSideNavigationViewController alloc]initWithModel:model forIdentity:identity];
        UIApplication *app                                           = [UIApplication sharedApplication];
        CGRect rect = [UIScreen mainScreen].bounds;
        [app.keyWindow setRootViewController:sideNavigationViewControler];
        [sideNavigationViewControler.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
        [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
            sideNavigationViewControler.view.frame = rect;
        } completion:^(BOOL finished) {
            NSLog(@"~~~~~~加载结束！！");
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 扇形
- (void)setupRadarView
{
    if (!self.indicatorView) {
        ETTRadarIndictorView *indicatorView = [[ETTRadarIndictorView alloc] initWithFrame:self.view.bounds];
        indicatorView.radius = 180;
        indicatorView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:indicatorView];
        self.indicatorView = indicatorView;
        [self.indicatorView startScan];
    }
}

@end
