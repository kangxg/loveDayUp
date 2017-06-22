//
//  ETTCoursewareStackManager.m
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
//  Created by zhaiyingwei on 2017/3/8.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTCoursewareStackManager.h"
#import "ETTSideNavigationViewController.h"
#import "AppDelegate.h"
#import "ETTStudentCourseViewController.h"
#import "ETTStudentCourseContentViewController.h"
#import "ETTNavigationController.h"
#import "AXPWhiteboardViewController.h"
#import "ETTStudentClassPerformanceVCTR.h"
#import "ETTMoreViewController.h"
#import "ETTStudentVideoAudioViewController.h"
#import "ETTStudentTestPaperDetailViewController.h"
#import "ReaderViewController.h"
#import "ETTTeacherVideoAudioViewController.h"

@implementation ETTCoursewareStackManager


-(id)getParentTopViewController
{
    id topVc;
    for (ETTNavigationController *object in [self getSidenavigationViewController].childViewControllers)
    {
        if ([object.topViewController isKindOfClass:[ETTStudentCourseViewController class]]) {
            topVc = object.topViewController;
        }
        
        if ([object.topViewController isKindOfClass:[ETTStudentCourseContentViewController class]]) {
            topVc = object.topViewController;
            break;
        }
    }
    return topVc;
}

-(id)getTheCurrentTopPage
{
    ETTNavigationController *snvc = [self getSidenavigationViewController].childViewControllers[0];
    
    return snvc.topViewController;
}

-(BOOL)judgePageSimilarity:(id)target
{
    for (ETTNavigationController *obj in [self getSidenavigationViewController].childViewControllers) {
        if ([obj.topViewController isKindOfClass:[target class]]) {
            return YES;
        }
    }
    return NO;
}

-(ETTCOURSELOADMODE)judgingLoadingModeWithCurrentPage:(id)parentPage
{
    
    if ([[self getTheCurrentTopPage]isKindOfClass:[[self getParentTopViewController] class]]) {
//        return ETTCOURSELOADMODE_DIRECT;
        return ETTCOURSELOADMODE_EJECT;
    }
    
    if ([[self getTheCurrentTopPage]isKindOfClass:[parentPage class]]){
        return ETTCOURSELOADMODE_REPLACE;
    }else{
        return ETTCOURSELOADMODE_EJECT;
    }
    
    return ETTCOURSELOADMODE_DEFAULT;
}

-(ETTCOURSELOADMODE)judgingLoadingModeWithCurrentPage:(id)currentPage withPage:(id)target
{
    NSArray *childsVC = [currentPage childViewControllers];
    id lastVC = [childsVC lastObject];
    if ([self jumpeBottomContainner:lastVC]) {
        return ETTCOURSELOADMODE_DIRECT;
    }else if ([lastVC isKindOfClass:[target class]]) {
        return ETTCOURSELOADMODE_REPLACE;
    }else{
        return ETTCOURSELOADMODE_EJECT;
    }
    
    return ETTCOURSELOADMODE_DEFAULT;
}


/*
 * 此处主要判断除课件以外的容器,课件容器在外部逻辑上已经判断了。
 */
-(BOOL)jumpeBottomContainner:(id)currentObj
{
    NSArray *arr = [self getSidenavigationViewController].childViewControllers;
    NSMutableArray *topArr = [NSMutableArray array];
    
    __block BOOL b = NO;
    dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply([arr count], queue, ^(size_t t) {
        ETTNavigationController *topVc = [arr objectAtIndex:(NSUInteger)t];
        [topArr addObject:topVc.topViewController];
    });
    dispatch_barrier_sync(queue, ^{
        for (id obj in topArr) {
            if ([currentObj isKindOfClass:[obj class]]) {
                b = YES;
            }
        }
    });
    return b;
}

-(void)resumeCourse:(ETTNavigationController *)target
{
    [target popToRootViewControllerAnimated:NO];
}

-(void)removeAllCildViewController:(UIViewController *)target
{
    NSArray *childArr = [target childViewControllers];
    for (ETTNavigationController *obj in childArr) {
        [obj popToRootViewControllerAnimated:NO];
    }
}

-(ETTSideNavigationViewController *)getSidenavigationViewController
{
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ETTSideNavigationViewController *sideNav = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    
    return sideNav;
}

-(ETTCOURSELOADMODE)judgingVideoPlaying
{
    ETTSideNavigationViewController *sidNav = [self getSidenavigationViewController];
    ETTCOURSELOADMODE loadMode = ETTCOURSELOADMODE_DEFAULT;
    NSArray *childArr = sidNav.childViewControllers;
    
    if ([sidNav.presentedViewController isKindOfClass:[ReaderViewController class]]) {
        loadMode = ETTCOURSELOADMODE_HAVINGCLASS;
        return loadMode;
    }
    
    __block NSMutableArray *topChildArray = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply([childArr count], queue, ^(size_t t) {
        ETTNavigationController *ngC = [childArr objectAtIndex:t];
        [topChildArray addObject:ngC.topViewController];
    });
    
    for (UIViewController *obj in topChildArray) {
        loadMode = [self judgChildVC:obj];
        NSLog(@"judgingVideoPlaying  -- obj is %@,obj childVC is %@ obj.navigaitoncontrller is %@",obj,obj.childViewControllers,obj.navigationController.childViewControllers);
        if (ETTCOURSELOADMODE_HAVINGCLASS == loadMode) {
            return loadMode;
        }
    }
    
    return loadMode;
}

-(ETTCOURSELOADMODE)judgChildVC:(UIViewController *)obj
{
    NSArray *tarArr = obj.navigationController.childViewControllers;
    for (id target in tarArr) {
        if ([target isKindOfClass:[ETTStudentVideoAudioViewController class]]||[target isKindOfClass:[ETTStudentTestPaperDetailViewController class]]) {
            return ETTCOURSELOADMODE_HAVINGCLASS;
        }
    }
    return ETTCOURSELOADMODE_DEFAULT;
}

-(void)stopCurrentAV:(id)target
{
    ETTSideNavigationViewController *sidNav = [self getSidenavigationViewController];
    ETTCOURSELOADMODE loadMode = ETTCOURSELOADMODE_DEFAULT;
    NSArray *childArr = sidNav.childViewControllers;
    
    __block NSMutableArray *topChildArray = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("ett", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply([childArr count], queue, ^(size_t t) {
        ETTNavigationController *ngC = [childArr objectAtIndex:t];
        [topChildArray addObject:ngC.topViewController];
        if ([ngC.topViewController isKindOfClass:[ETTTeacherVideoAudioViewController class]]) {
            ETTTeacherVideoAudioViewController *tAV = (ETTTeacherVideoAudioViewController *)ngC.topViewController;
            [tAV stopAVPlay];
            [ngC popViewControllerAnimated:NO];
        }
    });
}

-(BOOL)studentProcessTeacherExit
{
    NSLog(@"studentProcessTeacherExit");
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    id rootVc = (ETTSideNavigationViewController *)appDele.window.rootViewController;
    if (![rootVc isKindOfClass:[ETTSideNavigationViewController class]]) {
        return NO;
    }
    return YES;
}

@end
