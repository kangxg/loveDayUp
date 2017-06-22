//
//  ETTBackToPageManager.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTBackPageDelegate <NSObject>

@optional

//返回到需要的界面
- (void)backToTheNeedPage:(UITapGestureRecognizer *)tap;

@end

@interface ETTBackToPageManager : NSObject

@property (nonatomic ,strong) NSIndexPath         *indexPath;

@property (nonatomic        ) BOOL                isPushing;

// 推送前当前根控制器显示视图
@property (nonatomic        ) NSInteger           forwardIndex;
// push时当前根控制器显示视图
@property (nonatomic        ) NSInteger           currentIndex;
// 选择 课件/试卷/等
@property (nonatomic        ) NSNumber            *selectedBtn;
//课件id
@property (copy, nonatomic  ) NSString            *coursewareID;

@property (copy, nonatomic  ) NSString            *coursewareUrl;

@property (weak, nonatomic  ) id<ETTBackPageDelegate> delegate;

@property (nonatomic ,strong) UIView              *backPageView;

@property (nonatomic ,strong) ETTViewController   *pushingVc;

@property (assign, nonatomic) BOOL                isPushItem;//是否 推单道题

@property (assign, nonatomic) BOOL                hasHidePushBtnMethod;//网页是否有这个js方法

@property (copy, nonatomic) NSString              *testPaperID;//试卷id

/**
 *  @author LiuChuanan, 17-03-20 16:32:57
 *  
 *  @brief 学生点击了进入课堂按钮,状态判断
 *
 *
 *  @since 
 */
@property (assign, nonatomic) BOOL                isEnterSideNav;

/**
 *  @author LiuChuanan, 17-04-10 17:42:57
 *  
 *  @brief 学生在应用内是否已经执行过课堂重连操作.点击退出按钮的时候状态设为NO.只要执行过一次课堂恢复值为YES. 强制退出或者崩溃,内存中的所有数据会清空,isHavenRecovery = NO;
 *
 *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
 *   
 *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
 * 
 *  @since 
 */
@property (assign, nonatomic) BOOL                 isHavenRecovery;

/**
 *  @author LiuChuanan, 17-05-10 16:57:57
 *  
 *  @brief  判断相机启动次数
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1319
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (assign, nonatomic) int                  cameraOpenTimes;


+ (ETTBackToPageManager *)sharedManager;
- (void)addBackPageViewToView:(UIView *)view;

-(void)startPushing;
-(void)endPushing;


@end
