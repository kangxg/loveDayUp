//
//  ETTSelectIdentityViewController.m
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
//  Created by zhaiyingwei on 2016/10/10.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTSelectIdentityViewController.h"

/**
 *  @author LiuChuanan, 17-05-08 16:30:57
 *  
 *  @brief  指定代理对象以及代理回调方法的实现,要遵守代理协议
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@interface ETTSelectIdentityViewController ()<ETTSelectIdentityBackgroundViewDelegate>

@end

@implementation ETTSelectIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(instancetype)createUI
{
    ETTSelectIdentityBackgroundView *backgroundView = [[ETTSelectIdentityBackgroundView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    backgroundView.MDelegate = self;
    [self.view addSubview:backgroundView];
    
    return self;
}

#pragma mark - ETTSelectIdentityBackgroundViewDelegate
-(void)clickItemForButton:(ETTSelectIdentityButtonView *)sender
{
    ETTSelectIdentityButtonView *button =(ETTSelectIdentityButtonView *)sender;
    if (ETTSelectIdentityButtonTypeStudent == [button getType]) {
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
    }else if(ETTSelectIdentityButtonTypeTeacher == [button getType])
    {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
