//
//  ETTCoursewarePresentViewControllerManager.h
//  ettAiXuePaiNextGen
/**
 这个单例用来记录老师推送课件时,学生端模态出来的ReaderViewController控制器
 
 */
//  Created by Liu Chuanan on 16/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTCoursewarePresentViewControllerManager : NSObject

@property (strong, nonatomic) UIViewController *presentViewController;

@property (strong, nonatomic) NSIndexPath      *indexPath;

@property (copy, nonatomic  ) NSString         *pushId;

@property (assign, nonatomic) BOOL             isPushCourseware;//是否正在推送课件

@property (assign, nonatomic) BOOL             isAgainPush;//是否再次推送

@property (assign, nonatomic) BOOL             isOpenVideo;

@property (copy, nonatomic  ) NSString         *itemIds;

@property (copy, nonatomic  ) NSString         *testPaperId;

@property (assign, nonatomic) BOOL             isSupportRotation;

@property (assign, nonatomic) BOOL             isPushSubjectItem;

@property (assign, nonatomic) BOOL             isReconnectPushTestPaperAndPublishAnswer;//是否是课堂重连推送的试卷后公布答案

@property (assign, nonatomic) BOOL             isReconnectPushTestPaperAndShowCurrentPage;//是否是课堂重连推送的试卷后协同浏览

@property (strong, nonatomic) NSMutableArray   *markArray;//试卷互批信息

@property (copy, nonatomic  ) NSString         *cacheHost;//白板图片缓存host

@property (assign, nonatomic) BOOL             isCanReachNetwork;//是否可以访问网络 YES可以  NO不可以

@property (assign, nonatomic) BOOL             isPushingTestPaper;//是否正在推送试卷 这个判断用于控制结束作答的显示

@property (strong, nonatomic) UIViewController *thumViewController;//预览控制器

@property (assign, nonatomic) NSInteger        commitCount;//试卷中已提交的人数


+ (ETTCoursewarePresentViewControllerManager *)sharedManager;

@end
