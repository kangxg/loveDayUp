//
//  ETTLoginViewController.m
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
//  Created by zhaiyingwei on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLoginViewController.h"
#import "ETTUSERDefaultManager.h"  

@interface ETTLoginViewController()
@property(nonatomic,assign)ETTLoginType type;
@end

@implementation ETTLoginViewController

-(instancetype)initWithType:(ETTLoginType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setupLoginBackgroundView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onJumpViewHandler:) name:kNotificationForJumpType object:nil];
}

#pragma mark - 登录后判断身份选择进入页面。
-(void)onJumpViewHandler:(NSNotification *)notification
{
    NSString *typeStr = [NSString stringWithFormat:@"%@",notification.object];
    if ([typeStr isEqualToString:@"All"]) {
        ETTSelectIdentityViewController *selectVC = [[ETTSelectIdentityViewController alloc]init];
        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        CGRect rect = [UIScreen mainScreen].bounds;
        [appWindow setRootViewController:selectVC];
        [selectVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
        [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
            selectVC.view.frame = rect;
        } completion:^(BOOL finished) {
            NSLog(@"studentSelectTeacher~~~~~~加载结束！！");
        }];

    }
    
    if ([typeStr isEqualToString:@"Student"]) {
        NSLog(@"Student!");

        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        CGRect rect = [UIScreen mainScreen].bounds;
        ETTStudentSelectTeacherVC *studentSelectTeacherVC = [[ETTStudentSelectTeacherVC alloc]init];
        [appWindow setRootViewController:studentSelectTeacherVC];
        [studentSelectTeacherVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
        [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
            studentSelectTeacherVC.view.frame = rect;
        } completion:^(BOOL finished) {
            NSLog(@"studentSelectTeacher~~~~~~加载结束！！");
        }];

    }
    
    if ([typeStr isEqualToString:@"Teacher"]) {
        UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
        CGRect rect = [UIScreen mainScreen].bounds;
        ETTTeacherChooseClassVC *teacherChooseClass = [[ETTTeacherChooseClassVC alloc]init];
        [appWindow setRootViewController:teacherChooseClass];
        [teacherChooseClass.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
        [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
            teacherChooseClass.view.frame = rect;
        } completion:^(BOOL finished) {
            NSLog(@"studentSelectTeacher~~~~~~加载结束！！");
        }];
    }
    
    ///发送创建学校频道监听需求
//    [[NSNotificationCenter defaultCenter]postNotificationName:kREDIS_MONITOR_SCHOOL_NOTIFICATION object:nil];
}

-(instancetype)setupLoginBackgroundView
{
    ETTLoginBackgroundView *backgroundView = [[ETTLoginBackgroundView alloc]initWithType:_type];
    [self.view addSubview:backgroundView];
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationForJumpType object:nil];
}

/**
 *  @author LiuChuanan, 17-03-20 16:32:57
 *  
 *  @brief 登录视图即将出现的时候,让老师在线列表开始刷新
 *
 *
 *  @since 
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /***************************************************
     此功能只有学生使用，赋值修改之前需要判断身份。
     Johnny
     2017.03.27
     ***************************************************/
    if (![[ETTUSERDefaultManager getCurrentIdentity]isEqualToString:@"teacher"]) {
        
        [ETTBackToPageManager sharedManager].isEnterSideNav = NO;
        
    }
}

@end
