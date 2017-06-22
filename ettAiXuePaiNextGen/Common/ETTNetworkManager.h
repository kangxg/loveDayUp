//
//  ETTNetworkManager.h
//  ettNextGen
//
//  Created by Bin Lee on 7/11/15.
//  Copyright (c) 2015 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTNSError.h"
#import <AFNetworking.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import <Toast/UIView+Toast.h>


typedef enum : NSUInteger {
    kStudentAnswerImage,
    kTeacherSourceImage,
    kStudentCommentImage,
    kTeacherWBEncode,
    kTeacherTestPaperEncode,
    kCacheImage
} kUploadImageNameRule;

static CGFloat const JPEG_COMPRESSION_QUALITY = 1.0;

static NSTimeInterval const TOAST_DURATION = 2;
typedef void (^ResponseCallback)(NSDictionary * responseDictionary, NSError * error);
typedef void (^ProgressCallBack)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);

typedef NS_ENUM(NSUInteger, ETTUpdateDataStrategy) {
    ETTUpdateDataStrategyAdd,
    ETTUpdateDataStrategyReload,
};

typedef void (^CompletedRequested)(id, ETTNSError *);

typedef void (^CompletedPost)(BOOL, ETTNSError *);

@interface ETTNetworkManager : NSObject

+ (ETTNetworkManager *)sharedInstance;

//get请求
- (void)GET:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack;

//post请求
- (void)POST:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack;

//post请求 -- 上传文件
- (void)POST:(NSString *)urlString Parameters:(NSDictionary *)parameters fileData:(NSData *)fileData mimeType:(NSString *)mimeType uploadImageRule:(kUploadImageNameRule)imageRule responseCallBack:(ResponseCallback)responseCallBack;

-(NSString *)getUploadImageNameWithUploadImageMimeType:(NSString *)mimeType rule:(kUploadImageNameRule)imageRule;

- (void)GETSign:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack;

+ (NSString *)currentMsTimeString;
+ (NSString *)signOfInterfaceName:(NSString *)interfaceName parameters:(NSDictionary *)parameters;

+ (void)encryptSignatureParameters:(NSMutableDictionary *)parameters interfaceName:(NSString *)interfaceName;

@end

@interface UIView (SimpleToast)

- (void)toast:(NSString *)msg;

@end
