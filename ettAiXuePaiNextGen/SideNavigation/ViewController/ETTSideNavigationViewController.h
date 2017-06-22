//
//  ETTSideNavigationViewController.h
//  ettAiXuePaiNextGen
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

#import <UIKit/UIKit.h>
#import "ETTKit.h"
#import "ETTTabBarDelegate.h"
#import "ETTDockView.h"
#import "ExternMacros.pch"
#import "SidNavigationConst.h"
#import "UIView+Frame.h"
#import "ETTBottomMenuDelegate.h"
#import "ETTSideNavigationManagerDelegate.h"
#import "ETTMaskingView.h"
#import "SidNavigationConst.h"
#import "ETTSideNavigationManager.h"
#import "ETTOpenClassroomDoBackModel.h"
#import "ETTBackToPageManager.h"
#import "ETTRedisBasisManager.h"
#import "ETTUserIDForLoginModel.h"
#import "ETTRedisBasisManager.h"
#import "ETTStudentSelectTeacherModel.h"
#import "ETTSideNavigationViewModel.h"
#import "ETTCoverView.h"
#import "ETTPushCoverView.h"
#import "ETTCoursewarePushAnimationView.h"
#import "ETTPerformEntityInterface.h"

@interface ETTSideNavigationViewController : ETTViewController<ETTTabBarDelegate,ETTBottomMenuDelegate,ETTSideNavigationManagerDelegate,ETTSideNavigationRedisChannelDelegate,ETTPerformEntityInterface>

@property (nonatomic,assign) NSInteger index;

@property (strong, nonatomic) ETTBackToPageManager          *backToPageManager;

@property (nonatomic,assign ) ETTSideNavigationViewIdentity identity;

@property (nonatomic,strong ) ETTOpenClassroomDoBackModel   *openClassroomModel;

@property (nonatomic, strong) ETTCoverView                  *coverView;
@property (nonatomic, strong) ETTCoverView                  *synchronizeCoverView;
@property (nonatomic, strong) ETTPushCoverView              *pushCoverView;
@property (nonatomic, strong) ETTCoursewarePushAnimationView *coursewarePushAnimationView;

- (void)presentViewControllerToIndex:(NSInteger)toIndex title:(NSString *)title;

-(instancetype)initWithModel:(ETTOpenClassroomDoBackModel *)model;

-(instancetype)initWithModel:(id)model forIdentity:(ETTSideNavigationViewIdentity)identity;

- (void)keepLeft;//收起左侧栏

- (void)openPDFCoursewareWhitCoverView;//pdf课件打开之前的蒙版
- (void)removePdfCoverView;

- (void)addSynchronizeCoverView;
- (void)removeSynchronizeCoverView;

- (void)addPsuhCoverView;
- (void)removePushCoverView;

- (void)addCoursewarePushAnimationWithTitle:(NSString *)title;
- (void)removeCoursewarePushAnimation;

@end
