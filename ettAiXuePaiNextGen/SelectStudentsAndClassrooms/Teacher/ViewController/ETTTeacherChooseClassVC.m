//
//  ETTTeacherChooseClassVC.m
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
//  Created by zhaiyingwei on 2016/10/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassVC.h"
#import "UIViewController+RootViewController.h"

@interface ETTTeacherChooseClassVC ()

/**
 *  @author LiuChuanan, 17-05-08 15:30:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 13
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong)  NSArray                   *userClassList;
@property (nonatomic,strong)ETTTeacherChooseClassView *teacherChooseClassView;

/**
 *  @author LiuChuanan, 17-03-10 15:03:57
 *  
 *  @brief 临时变量,调试sideNav加载的此时
 *
 *  @since 
 */
@property (nonatomic,assign)int                       times;

@end

@implementation ETTTeacherChooseClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ETTTeacherChooseClassView *teacherChooseClassView = [[ETTTeacherChooseClassView alloc]initWithFrame:self.view.bounds];
    teacherChooseClassView.MDelegate                  = self;
    [self.view addSubview:teacherChooseClassView];
    _teacherChooseClassView = teacherChooseClassView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ETTUSERDefaultManager setCurrentIdentity:@"teacher"];
    
    /**
     *  @author LiuChuanan, 17-03-10 15:05:57
     *  
     *  @brief 每次视图出现的时候 变量设置为起始值
     *
     *  @since 
     */
    self.times = 0;
}

-(void)returnViewController
{
    [[ETTRedisBasisManager sharedRedisManager] endWorker];
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

-(NSArray *)setClassList
{
    return [ETTUSERDefaultManager getUserClassTagListForUserType:ETTUSERDefaultTypeTeacher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ETTTeacherChooseClassViewDelegate
-(void)onClickExitButton
{
    [self returnViewController];
}

-(void)teacherChooseClassroom:(ETTOpenClassroomDoBackModel *)model
{
    /**
     *  @author LiuChuanan, 17-03-10 14:55:57
     *  
     *  @brief 老师创建课堂页面. 如果sideNav已经实例化了一次,返回true
     *
     *  @since 
     */
     
    NSLog(@"这个方法调用次数  %d",self.times++);
    
    [ETTUSERDefaultManager setStartPageState:@"start"];
    
    CGRect rect                                       = [UIScreen mainScreen].bounds;
    UIApplication *app                                = [UIApplication sharedApplication];
    if (app.keyWindow.rootViewController == nil ||[app.keyWindow.rootViewController haveInitView] == NO)
    {
        NSLog(@"当前时间 %@",[NSDate date]);
        ETTSideNavigationViewController *sideNavigationVC = [[ETTSideNavigationViewController alloc]initWithModel:model forIdentity:ETTSideNavigationViewIdentityTeacher];
        [app.keyWindow setRootViewController:sideNavigationVC];
        [sideNavigationVC.view setFrame:CGRectMake(0, rect.size.height, rect.size.width, rect.size.height)];
        [UIView animateWithDuration:kLOGIN_VIEW_DURATION animations:^{
            sideNavigationVC.view.frame                       = rect;
        } completion:^(BOOL finished) {
            NSLog(@"~~~~~~加载结束！！");
        }];
    }
}

-(void)dealloc
{
    _teacherChooseClassView = nil;
}

@end
