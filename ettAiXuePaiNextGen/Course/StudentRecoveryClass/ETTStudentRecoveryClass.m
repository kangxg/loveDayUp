//
//  ETTStudentRecoveryClass.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 2017/4/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTStudentRecoveryClass.h"
#import "ETTJudgeIdentity.h"
#import "ETTBackToPageManager.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ReaderViewController.h"
#import "ETTStudentTestPaperDetailViewController.h"
#import "ETTRecoveryCommand.h"


@implementation ETTStudentRecoveryClass

/**
    获取上次断开时候的数据,主要是从redis缓存获取,每次断网重连会走这个方法
 
 @param dictionary 课堂重连恢复从redis 获取的上次缓存命令数据
 */
- (void)getLastCourseDataWithDictionary:(NSDictionary *)dictionary 
{
    /**
     *  @author LiuChuanan, 17-04-10 17:42:57
     *  
     *  @brief 学生课堂恢复,课件的部分功能恢复.
     *
     *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
     *   
     *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
     * 
     *  @since 
     */
    [ETTBackToPageManager sharedManager].isHavenRecovery = YES;
    
    if ([[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController isKindOfClass:[ReaderViewController class]]) 
    {
        ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
        [reader dismissViewControllerAnimated:NO completion:^{
            
            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = NO;
        }];
    }
    
    ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *userInfo;
        NSString *type = [dictionary objectForKey:@"type"];
        
        //课件相关功能恢复 基本恢复
        if ([type isEqualToString:kPDFCoursewareCommand]) 
        {
            [self p_handlePDFCoursewareRecoveryWithDictionary:dictionary userInfo:userInfo sideNavigationController:sideNav];
        }
        
        //试卷相关功能恢复 部分恢复
        if ([type isEqualToString:kTestPaperCommand]) 
        {
           [self p_handleTestPaperRecoveryWithDictionary:dictionary userInfo:userInfo sideNavigationController:sideNav];
        }
    });
}

#pragma -mark 处理试卷恢复 私有方法
- (void)p_handleTestPaperRecoveryWithDictionary:(NSDictionary *)dictionary userInfo:(NSDictionary *)userInfo sideNavigationController:(ETTSideNavigationViewController *)sideNav
{
    userInfo = [[dictionary objectForKey:@"theUserInfo"] objectForKey:@"userInfo"];
    
    ETTStudentTestPaperDetailViewController *studentTestPaperDetail = [[ETTStudentTestPaperDetailViewController alloc]init];
    
    NSString *CO_04_state = [userInfo objectForKey:@"CO_04_state"];
    
    //这个命令是老师推送原始试卷 
    if ([CO_04_state isEqualToString:kPushTestPaper]) 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加动画
            [sideNav addCoursewarePushAnimationWithTitle:@"正在加载试卷..."];
        });
        
        [self addDataToStudentTestPaperViewController:studentTestPaperDetail withDictionary:userInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ETTNavigationController *currentVc = sideNav.childViewControllers[sideNav.index];
            UIViewController *rootVC = currentVc.topViewController;
            [rootVC.navigationController pushViewController:studentTestPaperDetail animated:YES];
        });
    } 
    
    //这个命令是老师点击了结束作答按钮
    if ([CO_04_state isEqualToString:kEndAnswer]) 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加动画
            [sideNav addCoursewarePushAnimationWithTitle:@"正在加载试卷..."];
        });
        
        [ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndPublishAnswer = YES;
        [self addDataToStudentTestPaperViewController:studentTestPaperDetail withDictionary:userInfo];
        //添加动画
        dispatch_async(dispatch_get_main_queue(), ^{
            ETTNavigationController *currentVc = sideNav.childViewControllers[sideNav.index];
            UIViewController *rootVC = currentVc.topViewController;
            [rootVC.navigationController pushViewController:studentTestPaperDetail animated:YES];
        });
    }
    
    //试卷翻页协同浏览
    if ([CO_04_state isEqualToString:kSynchronousBrowsingTestPaper]) 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加动画
            [sideNav addCoursewarePushAnimationWithTitle:@"正在加载试卷..."];
        });
        
        [ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndShowCurrentPage = YES;
        [ETTCoursewarePresentViewControllerManager sharedManager].isReconnectPushTestPaperAndPublishAnswer = YES;
        [self addDataToStudentTestPaperViewController:studentTestPaperDetail withDictionary:userInfo];
        //添加动画
        dispatch_async(dispatch_get_main_queue(), ^{
            ETTNavigationController *currentVc = sideNav.childViewControllers[sideNav.index];
            UIViewController *rootVC = currentVc.topViewController;
            [rootVC.navigationController pushViewController:studentTestPaperDetail animated:YES];
        });
    } 
}

#pragma -mark 处理课件恢复 私有方法
- (void)p_handlePDFCoursewareRecoveryWithDictionary:(NSDictionary *)dictionary userInfo:(NSDictionary *)userInfo sideNavigationController:(ETTSideNavigationViewController *)sideNav
{
    userInfo = [[dictionary objectForKey:@"theUserInfo"] objectForKey:@"userInfo"];
    
    //如果老师端已经结束课件的推送 学生端不做处理
    if (![[userInfo objectForKey:@"CO_02_state"] isEqualToString:kEndPushPDF]) 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sideNav addCoursewarePushAnimationWithTitle:@"正在同步老师课件..."];
        });
        
        NSString *courseIdCoursewareID = [userInfo objectForKey:@"coursewareUrl"];
        NSArray *array                 = [courseIdCoursewareID componentsSeparatedByString:@"*"];
        NSString *coursewareUrl        = [array firstObject];
        NSInteger currentPage          = [[userInfo objectForKey:@"currentPage"] integerValue];
        
        //文件下载路径 以下是拼接文件名
        NSString *fileUrl = coursewareUrl;
        
        if (fileUrl) 
        {
            /**
             *  @author LiuChuanan, 17-04-10 17:42:57
             *  
             *  @brief 学生课堂恢复,课件的部分功能恢复.
             *
             *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
             *   
             *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
             * 
             *  @since 
             */
            [self recoveryPDFCoursewareWithCoursewareURLString:fileUrl currentPage:currentPage userInfo:userInfo sideNavigationController:sideNav];
        }
    }
}

/**
 *  @author LiuChuanan, 17-04-10 17:42:57
 *  
 *  @brief 学生课堂恢复,课件的部分功能恢复.
 *
 *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
 *   
 *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
 * 
 *  @since 
 */
- (void)recoveryPDFCoursewareWithCoursewareURLString:(NSString *)urlString currentPage:(NSInteger)currentPage userInfo:(NSDictionary *)userInfo sideNavigationController:(ETTSideNavigationViewController *)sideNav
{
    NSString *filePath = [self getFilePathWithCoursewareURLString:urlString];
    
    BOOL fileIsExist                                 = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileIsExist) 
    { //文件存在直接打开课件
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
        if (document) 
        {
            ETTSideNavigationViewController *sideNav                = [ETTJudgeIdentity getSideNavigationViewController];
            [sideNav openPDFCoursewareWhitCoverView];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                //pdf阅读控制器
                ReaderViewController *readerVC                          = [[ReaderViewController alloc]initWithReaderDocument:document];
                
                readerVC.modalTransitionStyle                           = UIModalTransitionStyleCrossDissolve;
                readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                readerVC.isAgainPushCourseware = YES;
                if ([[userInfo objectForKey:@"CO_02_state"]isEqualToString:kSynchronousBrowsingThumb])
                {
                    readerVC.pushedCurrentPage = currentPage + 1;
                } else 
                {
                    readerVC.pushedCurrentPage = currentPage;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    ETTNavigationController *currentVc = sideNav.childViewControllers[sideNav.index];
                    UIViewController *rootVC = currentVc.topViewController;
                    
                    [rootVC presentViewController:readerVC animated:NO completion:^{
                        readerVC.mainToolbar.hidden = YES;
                        readerVC.mainPagebar.hidden = YES;
                        [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                        [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
                        [ETTCoursewarePresentViewControllerManager sharedManager].isAgainPush = YES;
                    }];
                });
            });
        } 
    }
    else
    {
        [self downloadCoursewareWithURLString:urlString currentPage:currentPage sideNavigationController:sideNav];
    }
}

#pragma -mark 获取课件拼接后路径
- (NSString *)getFilePathWithCoursewareURLString:(NSString *)urlString
{
    NSString *str                                    = urlString.lastPathComponent;
    
    NSString *beforeFileName                         = [urlString substringToIndex:urlString.length - str.length-1].lastPathComponent;
    
    NSString *fileName                               = [NSString stringWithFormat:@"%@%@",beforeFileName,str];
    
    NSString *cahce = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *ETTDownloadCache = [cahce stringByAppendingPathComponent:@"ETTDownloadCache"];
    
    NSString *filePath                               = [ETTDownloadCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    return filePath;
}

/**
 *  @author LiuChuanan, 17-04-10 17:42:57
 *  
 *  @brief 学生课堂恢复,课件的部分功能恢复.
 *
 *  branch origin/bugfix/AIXUEPAIOS-1184-42-19
 *   
 *  Epic   origin/bugfix/Epic-ReFixCoursewareDownloadAIXUEPAIOS-1189
 * 
 *  @since 
 */
- (void)downloadCoursewareWithURLString:(NSString *)url currentPage:(NSInteger)currentPage sideNavigationController:(ETTSideNavigationViewController *)sideNav
{
    //URL
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //3.0
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载操作 创建下载句柄
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"课件下载进度: %f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *ETTDownloadCache = [cachesPath stringByAppendingPathComponent:@"ETTDownloadCache"];
        
        if (![[NSFileManager defaultManager]createDirectoryAtPath:ETTDownloadCache withIntermediateDirectories:YES attributes:nil error:nil]) 
        {
            return nil;
        } else
        {
            NSString *str            = url.lastPathComponent;
            
            NSString *beforeFileName = [url substringToIndex:url.length - str.length-1].lastPathComponent;
            
            NSString *fileName       = [NSString stringWithFormat:@"%@%@",beforeFileName,str];
            
            NSString *path = [ETTDownloadCache stringByAppendingPathComponent:fileName];
            
            return [NSURL fileURLWithPath:path];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (filePath)
                {
                    NSString *filePathString = [filePath path];
                    
                    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePathString password:nil];
                    
                    if (document)
                    {
                        ReaderViewController *readerVC = [[ReaderViewController alloc]initWithReaderDocument:document];
                        readerVC.pushedCurrentPage = currentPage>=0?currentPage:0;
                        readerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        readerVC.isAgainPushCourseware = YES;
                        ETTNavigationController *currentVc = sideNav.childViewControllers[sideNav.index];
                        UIViewController *rootVC = currentVc.topViewController;
                        [rootVC presentViewController:readerVC animated:NO completion:^{
                            readerVC.mainToolbar.hidden = YES;
                            readerVC.mainPagebar.hidden = YES;
                            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
                            readerVC.isAgainPushCourseware = YES;
                        }];
                    }
                }
            });
        } else 
        {
            //下载失败  移除推送动画
            [self reomoveDownLoadActionwithVC:sideNav];
            [ETTBackToPageManager sharedManager].isHavenRecovery = NO;
        }
    }];
    
    //开始下载
    [downloadTask resume];
    
}

#pragma -mark pdf课件下载失败移除动画
-(void)reomoveDownLoadActionwithVC:(ETTSideNavigationViewController *)sideNavigationViewController
{
    if(sideNavigationViewController)
    {
        [sideNavigationViewController removePdfCoverView];
        [sideNavigationViewController removeCoursewarePushAnimation];
    }
}

/**
 给学生试卷详情控制器需要的属性赋值
 
 @param studentTestPaperDetail 学生试卷详情控制器
 @param userInfo 源数据
 */
- (void)addDataToStudentTestPaperViewController:(ETTStudentTestPaperDetailViewController *)studentTestPaperDetail withDictionary:(NSDictionary *)userInfo 
{
    studentTestPaperDetail.testPaperId       = userInfo[@"testPaperId"];
    studentTestPaperDetail.pushId            = userInfo[@"pushId"];
    studentTestPaperDetail.courseId          = userInfo[@"courseId"];
    studentTestPaperDetail.itemIds           = userInfo[@"itemIds"];
    studentTestPaperDetail.testPaperName     = userInfo[@"testPaperName"];
    studentTestPaperDetail.paperRootUrl      = userInfo[@"paperRootUrl"];
    studentTestPaperDetail.pushCurrentPage   = userInfo[@"currentPaper"];
    studentTestPaperDetail.pushedTestPaperId = userInfo[@"pushedTestPaperId"];
}

@end
