//
//  ETTCoursewareStackManager.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,ETTCOURSELOADMODE)
{
    ///默认暂时用来表示判断失败
    ETTCOURSELOADMODE_DEFAULT   =   0,
    ///直接加载
    ETTCOURSELOADMODE_DIRECT    =   10,
    ///先弹出当前后再加载
    ETTCOURSELOADMODE_EJECT,
    ///直接替换当前内容就可以
    ETTCOURSELOADMODE_REPLACE,
    ///正在上课
    ETTCOURSELOADMODE_HAVINGCLASS,
    ///视频正在播放
    ETTCOURSELOADMODE_VIDEOPLAYING
};

@interface ETTCoursewareStackManager : NSObject

///当鼎城视图是我的课程或可将想请的时候，获取顶层视图。
-(id)getParentTopViewController;

-(id)getTheCurrentTopPage;

-(BOOL)judgePageSimilarity:(id)target;

-(ETTCOURSELOADMODE)judgingLoadingModeWithCurrentPage:(id)parentPage;

-(ETTCOURSELOADMODE)judgingLoadingModeWithCurrentPage:(id)currentPage withPage:(id)target;

-(void)resumeCourse:(ETTNavigationController *)target;

-(void)removeAllCildViewController:(UIViewController *)target;

-(ETTCOURSELOADMODE)judgingVideoPlaying;

-(void)stopCurrentAV:(id)target;

-(BOOL)studentProcessTeacherExit;

@end
