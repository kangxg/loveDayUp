//
//  ETTStudentSelectTeacherView.h
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

#import <UIKit/UIKit.h>
#import "ETTKit.h"
#import "ExternMacros.pch"
#import "ETTStudentSelectTeacherModel.h"
#import "ETTSelectClassroomButtonCell.h"
#import "ETTStudentSelectTeacherViewModel.h"
#import "ETTSelectClassroomConfirmButton.h"
#import "ETTRedisManagerConst.h"
#import "ETTUSERDefaultManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SidNavigationConst.h"
////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.3.17  18:17
 modifier : 康晓光
 version  ：Epic-0315-AIXUEPAIOS-1077
 branch   ：Epic-0315-AIXUEPAIOS-1077/AIXUEPAIOS-0315-984
 describe :学生在爱学派应用内按ipad的开关锁屏后，教师发起指令（推送或者同步进课）时，学生解锁，学生的应用黑屏后退出
 operation: 导入父类头文件
 */
#import "ETTChooseView.h"
/////////////////////////////////////////////////////

@protocol ETTStudentSelectTeacherViewDelegate <NSObject>

@optional
-(void)onClickExitButton;

-(void)onLoginClassroom:(ETTStudentSelectTeacherModel *)model;

@end
////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.3.17  18:17
 modifier : 康晓光
 version  ：Epic-0315-AIXUEPAIOS-1077
 branch   ：Epic-0315-AIXUEPAIOS-1077/AIXUEPAIOS-0315-984
 describe :学生在爱学派应用内按ipad的开关锁屏后，教师发起指令（推送或者同步进课）时，学生解锁，学生的应用黑屏后退出
 operation: 改为继承
 */

/////////////////////////////////////////////////////
@interface ETTStudentSelectTeacherView : ETTChooseView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ETTSelectClassroomConfirmButtonDelegate>

@property (nonatomic,weak)id<ETTStudentSelectTeacherViewDelegate> MDelegate;

@end
