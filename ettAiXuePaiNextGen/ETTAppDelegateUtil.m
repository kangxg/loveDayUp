
//
//  ETTAppDelegateUtil.m
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
//  Created by zhaiyingwei on 2016/12/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTAppDelegateUtil.h"

@interface ETTAppDelegateUtil ()

@property (nonatomic,weak) UIApplication    *application;
@property (nonatomic,weak) ETTReconnectionBackgroundView    *reconnectionBView;

@end

@implementation ETTAppDelegateUtil

-(instancetype)init
{
    if (self = [super init]) {
        UIApplication *application = [UIApplication sharedApplication];
        _application = application;
    }
    return self;
}

-(void)teacherRestartAPP:(UIApplication *)application lastClassroomMessageDic:(NSDictionary *)messDic
{
    NSString *urlBody = @"axpad/classroom/openClassroomAgain.do";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];
    NSDictionary *lastClassroomDic = messDic[@"userInfo"];
    
    NSDictionary *param = @{@"jid":lastClassroomDic[@"jid"],
                            @"classroomId":messDic[@"classroomId"]};
    [[ETTNetworkManager sharedInstance]GET:urlString Parameters:param responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        
        NSLog(@"responseDictionary===%@",responseDictionary);
        
        if (error) {
            NSLog(@"重连课堂%@发生错误!",messDic[@"classroomId"]);
        }else{
            NSLog(@"返回结果~~~%@",responseDictionary);
            if ([responseDictionary[@"result"]intValue]==1) {
                NSLog(@"课堂重连成功!");
                [self teacherLoginToClassRoom:application withMessage:messDic];
            }else{
                NSLog(@"课堂已关闭!");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                               message:@"课堂已关闭请重新登录"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self teacherCreateNewClassroom:application];
                                                                      }];
                
                [alert addAction:defaultAction];
                [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}

-(void)teacherLoginToClassRoom:(UIApplication *)application withMessage:(NSDictionary *)messDic
{
    [ETTUSERDefaultManager setStartPageState:@"start"];
    CGRect rect = [UIScreen mainScreen].bounds;
    ETTOpenClassroomDoBackModel *model = [[ETTOpenClassroomDoBackModel alloc]initWithDictionary:messDic[@"userInfo"]];
    ETTSideNavigationViewController *sideNavigationVC = [[ETTSideNavigationViewController alloc]initWithModel:model forIdentity:ETTSideNavigationViewIdentityTeacher];
    [application.keyWindow setRootViewController:sideNavigationVC];
    [sideNavigationVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
    [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
        sideNavigationVC.view.frame = rect;
    } completion:^(BOOL finished) {
        NSLog(@"~~~~~~加载结束！！");
    }];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadApp" object:nil];
}

-(void)teacherCreateNewClassroom:(UIApplication *)application
{
    NSLog(@"显示登录页！");
    CGRect rect = [UIScreen mainScreen].bounds;
    ETTLoginViewController *loginVC = [[ETTLoginViewController alloc]initWithType:ETTLoginAfterUsing];
    [application.keyWindow setRootViewController:loginVC];
    [loginVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
    [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
        loginVC.view.frame = rect;
    } completion:^(BOOL finished) {
        NSLog(@"~~~~~~加载结束！！");
    }];
}

-(void)studentRestartAPP:(UIApplication *)application lastClassroomMessageDic:(NSDictionary *)messDic
{
    NSLog(@"学生重连！");
    UIWindow *appWindow = [application.delegate window];
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

@end
