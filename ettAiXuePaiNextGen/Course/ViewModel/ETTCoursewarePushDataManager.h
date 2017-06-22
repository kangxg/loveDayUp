//
//  ETTCoursewarePushDataManager.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/28.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTSideNavigationViewController.h"

@interface ETTCoursewarePushDataManager : NSObject

#pragma push PDF courseware 
@property (strong, nonatomic) NSDictionary *pushPDFDict;

@property (copy, nonatomic  ) NSString     *mid;

@property (strong, nonatomic) NSDictionary *userInfo;

@property (copy, nonatomic  ) NSString     *CO_02_state;

@property (copy, nonatomic  ) NSString     *coursewareUrl;

@property (assign, nonatomic) NSInteger    currentPage;

@property (copy, nonatomic)   NSString     *theFilePath;

/**
 学生接收老师推送课件
 
 @param 数据
 */
- (void)dataAnalysisWithDictionary:(NSDictionary *)dictionary;

/**
 学生还在上次推送的pdf页面
 
 */
- (void)studentStillInLastReaderViewController;

/**
 学生不在上次推送的pdf页面
 
 */
- (void)studentIsNotInLastReaderViewController;


/**
 判断推送的pdf文件路径是否存在
 
 @param 
 */
- (BOOL)judgeFileIsExistWithFileUrl:(NSString *)fileUrl andDownloadCache:(NSString *)downloadCache;

/**
 打开pdf课件
 
 @param 
 */
- (void)openPDFWithFileUrl:(NSString *)fileUrl andSideNavigationViewController:(ETTSideNavigationViewController *)sideNavigationViewController;



@end
