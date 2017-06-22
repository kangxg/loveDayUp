//
//  ETTViewController.m
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
//  Created by zhaiyingwei on 16/9/13.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import "ETTBackToPageManager.h"
#import "AXPWhiteboardViewController.h"

@interface ETTViewController ()

@end

@implementation ETTViewController
@synthesize EVManagerVCTR = _EVManagerVCTR;
@synthesize EVGuardModel  = _EVGuardModel;
@synthesize EDActor       = _EDActor;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)performTask:(id<ETTCommandInterface>)commond
{
    
}
-(void)removeNotify
{
    
}
- (void)closeDocument
{
    
}

//
//  刷新学生管理学生信息
//
-(void)refreshClassOnlinePersonnelInformation:(NSDictionary *)dict;
{
    
}


//刷新旁听人数
-(void)refreshClassEattendPersonnelInformation:(NSDictionary *)dict;
{
    
}


-(void)putInOpenClassroomDoBackModel:(ETTOpenClassroomDoBackModel *)model
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pEvenHandler:(id)object withCommandType:(NSInteger)commandType
{
    
}
-(void)bindingViewReturnCallback
{
    
}
-(void)pEvenHandler:(id)object
{
    
}
-(void)returnBindingRoomView: (UIView *)view
{
    
}

-(BOOL)donotDisturb
{
    return false;
}
-(void)resetViewController
{
    
}

-(void)performActorResponse:(id<ETTActorInterface> )actor withInfo:(id)info
{
    
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
