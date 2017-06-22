//
//  ETTDownloadDelegate.h
//  ETTNetworkManager
//
//  Created by Liu Chuanan on 16/9/12.
//  Copyright © 2016年 etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTDownloadModel.h"

// 下载代理
@protocol ETTDownloadDelegate <NSObject>
@optional
// 更新下载进度
- (void)downloadModel:(ETTDownloadModel *)downloadModel didUpdateProgress:(ETTDownloadProgress *)progress;

// 更新下载状态
- (void)downloadModel:(ETTDownloadModel *)downloadModel didChangeState:(ETTDownloadState)state filePath:(NSString *)filePath error:(NSError *)error;

@end
