//
//  ETTNetworkAixueManager.h
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AFURLSessionManager.h>
#import "ETTNSError.h"
#import <AFNetworking.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>

static NSTimeInterval const TOAST_DURATIONS = 5;
typedef void (^ResponseCallbacks)(NSDictionary * responseDictionary, NSError * error);
typedef void (^ProgressCallBacks)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);

@interface ETTNetworkAixueManager : NSObject

+ (ETTNetworkAixueManager *)sharedInstance;

//post请求
- (void)POST:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack;

@end
