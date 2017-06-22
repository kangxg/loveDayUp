//
//  ETTReconnectionViewController.m
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

#import "ETTReconnectionViewController.h"
#import "ETTTeacherChooseClassVC.h"

@interface ETTReconnectionViewController ()

/**
 *  @author LiuChuanan, 17-05-08 15:45:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 14
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTReconnectionBackgroundView    *backView;

@end

@implementation ETTReconnectionViewController

-(instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    
    ETTReconnectionBackgroundView *backView = [[ETTReconnectionBackgroundView alloc]initRemindView:nil];
    backView.EVDelegate                     = self;
    [self.view addSubview:backView];
    _backView                               = backView;
}

-(void)pEvenHandler:(id)object withCommandType:(NSInteger)commandType
{
    NSLog(@"pEvenHandler is %@  is %ld",object,commandType);
    if (1 == commandType) {
        NSLog(@"重建课堂!");
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

    }else if(2 == commandType){
        NSLog(@"重新加载!");
        self.view.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadApp" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
