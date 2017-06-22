//
//  ETTDownloadSessionManager.h
//  ETTDownloadManagerDemo
//
//  Created by Liu Chuanan on 16/9/12.
//  Copyright © 2016年 etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTDownloadModel.h"
#import "ETTDownloadDelegate.h"
#import "EttDownloadHeader.h"
#import "ETTDownLoadProcessingState.h"
/**
 *  下载管理类 封装NSURLSessionDownloadTask
 */
@interface ETTDownloadManager : NSObject<NSURLSessionDownloadDelegate>
@property (nonatomic,retain,readonly)AFURLSessionManager   *  EDDownLoadManager;
@property (nonatomic,retain,readonly)AFURLSessionManager   *  EDBgDownLoadManager;
// 下载代理
@property (nonatomic,weak) id<ETTDownloadDelegate> delegate;

// 下载中的模型 只读
@property (nonatomic, strong,readonly) NSMutableArray *waitingDownloadModels;

// 等待中的模型 只读
@property (nonatomic, strong,readonly) NSMutableArray *downloadingModels;

// 最大下载数
@property (nonatomic, assign) NSInteger maxDownloadCount;

// 等待下载队列 先进先出 默认YES， 当NO时，先进后出
@property (nonatomic, assign) BOOL      resumeDownloadFIFO;

// 全部并发 默认NO, 当YES时，忽略maxDownloadCount
@property (nonatomic, assign) BOOL      isBatchDownload;

// 后台session configure
@property (nonatomic, strong) NSString *backgroundConfigure;

@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)();

// 后台下载完成后调用 返回文件保存路径filePath
@property (nonatomic, copy) NSString *(^backgroundSessionDownloadCompleteBlock)(NSString *downloadURL);

// 单例
+ (ETTDownloadManager *)manager;

// 配置后台session
- (void)configureBackroundSession;

// 取消所有完成或失败后台task
- (void)cancleAllBackgroundSessionTasks;

// 开始下载
- (ETTDownloadModel *)startDownloadURLString:(NSString *)URLString toDestinationPath:(NSString *)destinationPath progress:(ETTDownloadProgressBlock)progress state:(ETTDownloadStateBlock)state;

// 开始下载
- (void)startWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 开始下载
- (void)startWithDownloadModel:(ETTDownloadModel *)downloadModel progress:(ETTDownloadProgressBlock)progress state:(ETTDownloadStateBlock)state;

// 恢复下载（除非确定对这个model进行了suspend，否则使用start）
- (void)resumeWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 暂停下载
- (void)suspendWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 取消下载
- (void)cancleWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 删除下载
- (void)deleteFileWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 删除下载
- (void)deleteAllFileWithDownloadDirectory:(NSString *)downloadDirectory;

// 获取正在下载模型
- (ETTDownloadModel *)downLoadingModelForURLString:(NSString *)URLString;

// 获取后台运行task
- (NSURLSessionDownloadTask *)backgroundSessionTasksWithDownloadModel:(ETTDownloadModel *)downloadModel;

// 是否已经下载
- (BOOL)isDownloadCompletedWithDownloadModel:(ETTDownloadModel *)downloadModel;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.1  10:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 创建一个下载任务，返回 ETTDownLoadTaskState 状态类型
 1.网络不可达 不创建任务，返回不成功创建状态错误类型
 2.已经有此下载任务，不创建任务，返回不成功创建状态错误类型
 3.因为现在制定能有一个下载任务进行，所以如果已经创建下载其它课件任务
 不成功创建状态错误类型
 4.创建下载任务对象失败，不成功创建状态错误类型
 *注意 合并父分支到 bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 */

-(ETTDownLoadTaskState)downloadTaskWithRequest:(NSURLRequest *)request
                                      progress:( void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                   destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                             completionHandler:( void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler;


////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.1  10:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 创建一个下载任务，返回 ETTDownLoadTaskState 状态类型
 1.网络不可达 不创建任务，返回不成功创建状态错误类型
 2.已经有此下载任务，不创建任务，返回不成功创建状态错误类型
 3.因为现在制定能有一个下载任务进行，所以如果已经创建下载其它课件任务
 不成功创建状态错误类型
 4.创建下载任务对象失败，不成功创建状态错误类型
 *注意 合并父分支到 bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 */
-(ETTDownLoadTaskState)downloadTaskWithRequest:(NSString  *)url
                                      fileName:(NSString  *)fileName
                                     downModel:(ETTDownloadModel *)model
                                      progress:( void (^)(NSProgress *downloadProgress))downloadProgressBlock

                             completionHandler:( void (^)(NSURLResponse *response, NSURL * filePath, NSError *  error))completionHandler;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 恢复一个正在下载到任务
 1.如果任务不存在，返回 假值
 2.AFURLSessionManager 对象为空时，返回假值
 
 */
-(BOOL)resumeDownloadTask:(NSString *)url
                 fileName:(NSString  *)fileName
                downModel:(ETTDownloadModel *)model
                 progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
        completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;



-(BOOL)isHaveDownloading:(NSString *)url;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 根据url获取一个下载任务的 ETTDownloadModel对象实例
 
 */
-(ETTDownloadModel *)getDownloadModel:(NSString *)key;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 根据url 判断下载任务的 是否存在
 
 */
-(BOOL)downloadingTask:(NSString *)url;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 取消所以下载任务
 
 */
-(void)cannelAllTask;

////////////////////////////////////////////////////////
/*
 new      : create
 time     : 2017.4.6  11:00
 modifier : 康晓光
 version  ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth
 branch   ：bugfix/Epic-PushLargeCourseware-0331-无RedisAuth／AIXUEPAIOS-0406-1169
 describe : 学生端课件下载更换成AFN
 introduce: 所有下载任务及ETTDownloadModel对象字典清空
 
 */
-(void)resetTasks;

-(void)cacheTasks;

@end
