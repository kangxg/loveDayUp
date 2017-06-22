//
//  ETTCoursewarePushDataManager.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/28.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTCoursewarePushDataManager.h"
#import "ReaderViewController.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTStudentVideoAudioViewController.h"
#import "ETTDownloadManager.h"
#import "ETTCoursewarePresentViewControllerManager.h"
#import "ETTSynchronizeStatus.h"

@interface ETTCoursewarePushDataManager ()

@property (copy, nonatomic) NSString *ETTDownloadCache;

@end

@implementation ETTCoursewarePushDataManager

- (instancetype)init {
    if (self = [super init]) {
        
        //文件缓存路径
        NSString *cachePath        = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        
        NSString *ETTDownloadCache = [cachePath stringByAppendingPathComponent:@"ETTDownloadCache"];
        
        self.ETTDownloadCache = ETTDownloadCache;
        
    }
    return self;
}

#pragma privateMethods
- (void)dataAnalysisWithDictionary:(NSDictionary *)dictionary {
    
    NSAssert(dictionary, @"push pdf courseware dictionary cannot be nil");
    
    self.pushPDFDict               = dictionary;
    
    self.mid                       = [dictionary objectForKey:@"mid"];
    
    self.userInfo                  = [dictionary objectForKey:@"userInfo"];
    
    NSString *courseIdCoursewareID = [self.userInfo objectForKey:@"coursewareUrl"];
    
    self.CO_02_state               = [self.userInfo objectForKey:@"CO_02_state"];
    
    NSArray *array                 = [courseIdCoursewareID componentsSeparatedByString:@"*"];
    
    self.coursewareUrl             = [array firstObject];
    
    self.currentPage               = [[self.userInfo objectForKey:@"currentPage"] integerValue];
    
    ETTLog(@"%ld",(long)self.currentPage);
    
}

- (void)studentStillInLastReaderViewController {
    
    ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
    
    /**
     *  @author LiuChuanan, 17-04-06 16:42:57
     *  
     *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
     *
     *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
     *   
     *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
     * 
     *  @since 
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        reader.view.userInteractionEnabled = NO;
        reader.mainToolbar.hidden = YES;
        reader.mainPagebar.hidden = YES;
    });
}

- (void)studentIsNotInLastReaderViewController {
    
    ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
    
    /**
     *  @author LiuChuanan, 17-04-06 16:42:57
     *  
     *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
     *
     *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
     *   
     *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
     * 
     *  @since 
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        reader.view.userInteractionEnabled = NO;
        [reader dismissViewControllerAnimated:NO completion:^{
            
            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = nil;
            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware      = NO;
        }];
    });
}

- (BOOL)judgeFileIsExistWithFileUrl:(NSString *)fileUrl andDownloadCache:(NSString *)downloadCache {
    
    NSAssert(fileUrl, @"pdf文件路径不存在");
    
    NSString *str            = fileUrl.lastPathComponent;
    
    NSString *beforeFileName = [fileUrl substringToIndex:fileUrl.length - str.length - 1].lastPathComponent;
    
    NSString *fileName       = [NSString stringWithFormat:@"%@%@",beforeFileName,str];
    
    self.theFilePath         = [downloadCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
    BOOL fileIsExist         = [[NSFileManager defaultManager] fileExistsAtPath:self.theFilePath];
    
    return fileIsExist;
}

- (void)openPDFWithFileUrl:(NSString *)fileUrl andSideNavigationViewController:(ETTSideNavigationViewController *)sideNavigationViewController {
    
    if (fileUrl) {//文件路径存在的话
        NSString *str = fileUrl.lastPathComponent;
        NSString *beforeFileName = [fileUrl substringToIndex:fileUrl.length - str.length - 1].lastPathComponent;
        
        NSString *fileName       = [NSString stringWithFormat:@"%@%@",beforeFileName,str];
        
        NSString *theFilePath    = [self.ETTDownloadCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        
        BOOL fileIsExist = [[NSFileManager defaultManager] fileExistsAtPath:theFilePath];
        
        //文件存在,直接打开
        if (fileIsExist) {
            
            ReaderDocument *document = [ReaderDocument withDocumentFilePath:theFilePath password:nil];
            
            if (document) {
                
                ReaderViewController *readerVC  = [[ReaderViewController alloc]initWithReaderDocument:document];
                readerVC.pushedCurrentPage      = self.currentPage;
                ETTLog(@"%ld",(long)self.currentPage);
                readerVC.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
                readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                readerVC.isAgainPushCourseware  = YES;
                
                //判断学生自己有没有打开readerVC查看别的pdf课件
                if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[ReaderViewController class]]) {
                    
                    ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
                    
                    /**
                     *  @author LiuChuanan, 17-04-06 16:42:57
                     *  
                     *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
                     *
                     *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
                     *   
                     *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
                     * 
                     *  @since 
                     */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        reader.view.userInteractionEnabled = NO;
                        
                        /**
                         *  @author LiuChuanan, 17-03-27 14:12:57
                         *  
                         *  @brief 学生打开课件的时候教师推送课件，学生可以在推送课件内任意滑动问题思路:如果学生已经自己打开了一个pdf,记录学生打开的那个pdf控制器
                         *
                         *
                         *  @since 
                         */

                        [ETTBackToPageManager sharedManager].pushingVc = nil;
                        
                        [reader dismissViewControllerAnimated:NO completion:nil];
                        
                        [sideNavigationViewController presentViewController:readerVC animated:NO completion:^{
                            readerVC.mainToolbar.hidden                                                     = YES;
                            readerVC.mainPagebar.hidden                                                     = YES;
                            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware      = YES;
                            readerVC.isAgainPushCourseware                                                  = YES;
                        }];
                    });
                    
                } else {
                    ETTNavigationController *currentVc = sideNavigationViewController.childViewControllers[sideNavigationViewController.index];
                    
                    UIViewController *rootVC = currentVc.topViewController;
                    
                    if ([rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
                        
                        ETTStudentVideoAudioViewController *studentVideoAudioVC = (ETTStudentVideoAudioViewController *)rootVC;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [studentVideoAudioVC stopPlay];
//                            [studentVideoAudioVC.moviePlayerController pause];
                            [studentVideoAudioVC.navigationController popViewControllerAnimated:YES];
                            [ETTSynchronizeStatus sharedManager].lastUrlString = nil;
                        });
                    } 
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [sideNavigationViewController presentViewController:readerVC animated:NO completion:^{
                            readerVC.mainToolbar.hidden = YES;
                            readerVC.mainPagebar.hidden = YES;
                            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
                            readerVC.isAgainPushCourseware = YES;
                        }];
                        
                    });
                }
            }
        } else { //文件不存在,先下载后打开
            
            if ([[ETTBackToPageManager sharedManager].pushingVc isKindOfClass:[ReaderViewController class]]) {
                
                ReaderViewController *reader = (ReaderViewController *)[ETTCoursewarePresentViewControllerManager sharedManager].presentViewController;
                
                /**
                 *  @author LiuChuanan, 17-04-06 16:42:57
                 *  
                 *  @brief 如果学生处于课件页面,接收到推送课件命令后,取消交互(自己要多测几遍)
                 *
                 *  branch origin/bugfix/ReFix-AIXUEPAIOS-921-0327
                 *   
                 *  Epic   origin/bugfix/Epic-0327-AIXUEPAIOS-1140
                 * 
                 *  @since 
                 */
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    reader.view.userInteractionEnabled = NO;
                    
                    [reader dismissViewControllerAnimated:NO completion:^{
                        [ETTBackToPageManager sharedManager].pushingVc = nil;
                    }];
                });
            }
            
            /**
             *  @author LiuChuanan, 17-03-30 14:42:57
             *  
             *  @brief 下载课件  框架替换
             *
             *  branch 
             *   
             *  Epic   
             * 
             *  @since 
             */
            [self downloadFileWithURL:fileUrl andSideNav:sideNavigationViewController];
            
        }
    }
}

/**
 *  @author LiuChuanan, 17-04-01 14:42:57
 *  
 *  @brief 下载课件  框架替换
 *
 *  branch origin/bugfix/AIXUEPAIOS-1166
 *   
 *  Epic   origin/bugfix/Epic-PushLargeCourseware-0331
 * 
 *  @since 
 */
- (void)downloadFileWithURL:(NSString *)url andSideNav:(ETTSideNavigationViewController *)sideNavigationViewController
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
            
            NSLog(@"file path :%@",path);
            
            return [NSURL fileURLWithPath:path];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (filePath)
                {
                    
                    NSLog(@"%@",filePath);
                    
                    NSString *filePathString = [filePath path];
                    
                    NSLog(@"%@",filePathString);
                    
                    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePathString password:nil];
                    
                    if (document)
                    {
                        ReaderViewController *readerVC = [[ReaderViewController alloc]initWithReaderDocument:document];
                        readerVC.pushedCurrentPage = self.currentPage>=0?self.currentPage:0;
                        readerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        readerVC.isAgainPushCourseware = YES;
                        ETTNavigationController *currentVc = sideNavigationViewController.childViewControllers[sideNavigationViewController.index];
                        
                        UIViewController *rootVC = currentVc.topViewController;
                        
                        if ([rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
                            
                            ETTStudentVideoAudioViewController *studentVideoAudioVC = (ETTStudentVideoAudioViewController *)rootVC;
                            [studentVideoAudioVC stopPlay];
                           // [studentVideoAudioVC.moviePlayerController pause];
                            [studentVideoAudioVC.navigationController popViewControllerAnimated:YES];
                            [ETTSynchronizeStatus sharedManager].lastUrlString = nil;
                            
                            
                        }
                        
                        [sideNavigationViewController presentViewController:readerVC animated:NO completion:^{
                            readerVC.mainToolbar.hidden = YES;
                            readerVC.mainPagebar.hidden = YES;
                            [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                            [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
                            readerVC.isAgainPushCourseware = YES;
                        }];
                        
                    }
                }
            });
        } else {
            
            //下载失败  移除推送动画
            [self reomoveDownLoadActionwithVC:sideNavigationViewController];
        }
    }];
    
    //开始下载
    [downloadTask resume];
    
}

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.3.7  18:40
 modifier : 康晓光
 version  ：Dev-0224
 branch   ：1043
 describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务 
 重新下载任务
 */
-(void)againDownloadPushFile:(NSString *)url withVC:(ETTSideNavigationViewController *)sideNavigationViewController
{
    if (url)
    {
        WS(weakSelf);
        ETTDownloadManager *manager = [ETTDownloadManager manager];
        ETTDownloadModel *downloadModel = [[ETTDownloadModel alloc]initWithURLString:url];
        [manager startWithDownloadModel:downloadModel progress:^(ETTDownloadProgress *progress) {
            
        } state:^(ETTDownloadState state, NSString *filePath, NSError *error) {
            
            if (state == ETTDownloadStateCompleted) {
                
                ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
                ReaderViewController *readerVC = [[ReaderViewController alloc]initWithReaderDocument:document];
                
                if (readerVC)
                {
                    [weakSelf downloadFilecompleteLoadingView:readerVC withVC:sideNavigationViewController];
                    
                }
                else
                {
                    [weakSelf reomoveDownLoadActionwithVC:sideNavigationViewController];
                }
                
            }
        }];
    }
    
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.3.7  18:41
 modifier : 康晓光
 version  ：Dev-0224
 branch   ：1043
 describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务
 课件下载完成 执行的操作
 
 */
-(void)downloadFilecompleteLoadingView:(ReaderViewController *)readerVC withVC:(ETTSideNavigationViewController *)sideNavigationViewController
{
    WS(weakSelf);
    if (readerVC)
    {
        
        readerVC.pushedCurrentPage = self.currentPage>=0?self.currentPage:0;
        readerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        readerVC.isAgainPushCourseware = YES;
        ETTNavigationController *currentVc = sideNavigationViewController.childViewControllers[sideNavigationViewController.index];
        
        UIViewController *rootVC = currentVc.topViewController;
        
        if ([rootVC isKindOfClass:[ETTStudentVideoAudioViewController class]]) {
            
            ETTStudentVideoAudioViewController *studentVideoAudioVC = (ETTStudentVideoAudioViewController *)rootVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [studentVideoAudioVC.moviePlayerController pause];
                [studentVideoAudioVC.navigationController popViewControllerAnimated:YES];
                [ETTSynchronizeStatus sharedManager].lastUrlString = nil;
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sideNavigationViewController presentViewController:readerVC animated:NO completion:^{
                readerVC.mainToolbar.hidden = YES;
                readerVC.mainPagebar.hidden = YES;
                [ETTCoursewarePresentViewControllerManager sharedManager].presentViewController = readerVC;
                [ETTCoursewarePresentViewControllerManager sharedManager].isPushCourseware = YES;
                readerVC.isAgainPushCourseware = YES;
            }];
            
        });
        
    }
    else
    {
        [weakSelf reomoveDownLoadActionwithVC:sideNavigationViewController];
    }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.3.7  18:42
 modifier : 康晓光
 version  ：Dev-0224
 branch   ：1043
 describe : 将新疆成都老客户端xinjiangHIRedis0305 分支上代码优化move到Dev-0224上的工作任务 
 移除接受课件推送 动画
 */
-(void)reomoveDownLoadActionwithVC:(ETTSideNavigationViewController *)sideNavigationViewController
{
    if(sideNavigationViewController)
    {
        [sideNavigationViewController removePdfCoverView];
        [sideNavigationViewController removeCoursewarePushAnimation];
        
    }
    
}
/////////////////////////////////////////////////////
@end
