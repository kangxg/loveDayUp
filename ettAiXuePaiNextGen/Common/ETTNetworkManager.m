//
//  ETTNetworkManager.m
//  ettNextGen
//
//  Created by Bin Lee on 7/11/15.
//  Copyright (c) 2015 Etiantian. All rights reserved.
//

#import "ETTNetworkManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AFURLSessionManager.h>
#import "AXPUserInformation.h"
#import "ETTUserInformationProcessingUtils.h"
#import "ETTCoursewarePresentViewControllerManager.h"

static NSTimeInterval const REQUEST_TIMEOUT_DURATION = 6;
static NSString * const SECRET_KEY = @"PAD#HONER#2016";


@interface ETTNetworkManager ()

@end

@implementation ETTNetworkManager

static ETTNetworkManager *ettNetworkManager;

+ (ETTNetworkManager *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        ettNetworkManager = [[self alloc] init];
    });
    return ettNetworkManager;
}


/**
 *  validate api result
 *
 *  @param response <#response description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)validateResult:(NSDictionary *)response {
    NSInteger result = [[response valueForKey:@"result"]integerValue];
    if (result > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (AFHTTPSessionManager *)sharedManager {
    
    static AFHTTPSessionManager *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_DURATION;//请求超时时间
    });
    
    
    return manager;
}

- (void)GET:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack {
    
    if (urlString.length == 0) {
        NSError * error =
        [NSError errorWithDomain:@"URL_STRING_FORMAT_ERROR_DOMAIN"
                            code:-NSIntegerMax
                        userInfo:@{NSLocalizedDescriptionKey:@"无法获取正确的URL地址！"}];
        responseCallBack(nil, error);
    }
    
    NSMutableDictionary * mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSString * interfaceName = urlString.lastPathComponent;
    NSRange equalSignRange = [interfaceName rangeOfString:@"="];
    if (equalSignRange.location != NSNotFound) {
        interfaceName = [interfaceName substringFromIndex:(equalSignRange.location + equalSignRange.length)];
    }
    
    [ETTNetworkManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
    ETTLog(@"%@",mutableParameters);

    
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isCanReachNetwork) {
        
        [[[ETTNetworkManager sharedInstance] sharedManager] GET:urlString parameters:mutableParameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
            [ETTUserInformationProcessingUtils showErrorMessage:result];
            
            if (result <= 0) {
                
                NSString * msg = responseObject[@"msg"];
                msg = msg.length > 0 ? msg : @"";
                NSError * error = [NSError errorWithDomain:@"HTTP_REQUEST_ERROR_DOMAIN" code:result userInfo:@{NSLocalizedDescriptionKey:msg}];
                responseCallBack(responseObject, error);
                
                NSLog(@"数据返回有问题");
                
                
            }else {
                
                responseCallBack(responseObject,nil);
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            responseCallBack(nil,error);
            
            NSLog(@"网络请求错误原因:%@",error);
            
        }];

    }
    
}

- (void)GETSign:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack{
    
    if (urlString.length == 0) {
        NSError * error =
        [NSError errorWithDomain:@"URL_STRING_FORMAT_ERROR_DOMAIN"
                            code:-NSIntegerMax
                        userInfo:@{NSLocalizedDescriptionKey:@"无法获取正确的URL地址！"}];
        responseCallBack(nil, error);
    }
    
    NSMutableDictionary * mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSString * interfaceName = urlString.lastPathComponent;
    NSRange equalSignRange = [interfaceName rangeOfString:@"="];
    if (equalSignRange.location != NSNotFound) {
        interfaceName = [interfaceName substringFromIndex:(equalSignRange.location + equalSignRange.length)];
    }
    
    [ETTNetworkManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
    
    responseCallBack(mutableParameters,nil);
}

- (void)POST:(NSString *)urlString Parameters:(NSDictionary *)parameters responseCallBack:(ResponseCallback)responseCallBack {
    
    if (urlString.length == 0) {
        NSError * error =
        [NSError errorWithDomain:@"URL_STRING_FORMAT_ERROR_DOMAIN"
                            code:-NSIntegerMax
                        userInfo:@{NSLocalizedDescriptionKey:@"无法获取正确的URL地址！"}];
        responseCallBack(nil, error);
    }
    
    NSMutableDictionary * mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSString * interfaceName = urlString.lastPathComponent;
    NSRange equalSignRange = [interfaceName rangeOfString:@"="];
    if (equalSignRange.location != NSNotFound) {
        interfaceName = [interfaceName substringFromIndex:(equalSignRange.location + equalSignRange.length)];
    }
    
    [ETTNetworkManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
    
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isCanReachNetwork) {
        [[[ETTNetworkManager sharedInstance] sharedManager] POST:urlString parameters:mutableParameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
            [ETTUserInformationProcessingUtils showErrorMessage:result];
            
            
            if (result <= 0) {
                
                NSString * msg = responseObject[@"msg"];
                msg = msg.length > 0 ? msg : @"";
                NSError * error = [NSError errorWithDomain:@"HTTP_REQUEST_ERROR_DOMAIN" code:result userInfo:@{NSLocalizedDescriptionKey:msg}];
                responseCallBack(responseObject, error);
                
                NSLog(@"数据返回有问题");
                
                
            }else {
                
                responseCallBack(responseObject,nil);
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            responseCallBack(nil,error);
            
            NSLog(@"网络请求错误原因:%@",error);
            
        }];
    }else{
        if ([urlString isEqualToString:[NSString stringWithFormat:@"%@%@",SERVER_HOST,kGetLoginMessage]]) {
            NSError * error = [NSError errorWithDomain:@"HTTP_REQUEST_ERROR_DOMAIN" code:0 userInfo:@{@"NSLocalizedDescription":@"似乎已断开与互联网的连接。"}];
            responseCallBack(nil,error);
        }
    }
}

//post请求 -- 上传文件
- (void)POST:(NSString *)urlString Parameters:(NSDictionary *)parameters fileData:(NSData *)fileData mimeType:(NSString *)mimeType uploadImageRule:(kUploadImageNameRule)imageRule responseCallBack:(ResponseCallback)responseCallBack
{
    if (urlString.length == 0) {
        NSError * error =
        [NSError errorWithDomain:@"URL_STRING_FORMAT_ERROR_DOMAIN"
                            code:-NSIntegerMax
                        userInfo:@{NSLocalizedDescriptionKey:@"无法获取正确的URL地址！"}];
        responseCallBack(nil, error);
    }
    
    AXPUserInformation *info = [AXPUserInformation sharedInformation];
    
    NSMutableDictionary * mutableParameters = [NSMutableDictionary dictionaryWithDictionary:@{@"jid":info.jid}];
    
    NSString *interfaceName = urlString.lastPathComponent;
    NSRange equalSignRange = [interfaceName rangeOfString:@"="];
    if (equalSignRange.location != NSNotFound) {
        interfaceName = [interfaceName substringFromIndex:(equalSignRange.location + equalSignRange.length)];
    }
    
    [ETTNetworkManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
   
    NSString *imageName;
    
    if (parameters) {
        imageName = parameters[@"commentName"];
    }
   
    NSString *fileName = [self getUploadImageNameWithUploadImageMimeType:mimeType rule:imageRule imageName:imageName];
    
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?jid=%@&time=%@&sign=%@",mutableParameters[@"jid"],mutableParameters[@"time"],mutableParameters[@"sign"]]];
    
    if ([ETTCoursewarePresentViewControllerManager sharedManager].isCanReachNetwork) {
        [[[ETTNetworkManager sharedInstance] sharedManager] POST:urlString parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //
            [formData appendPartWithFileData:fileData name:@"file[]" fileName:fileName mimeType:mimeType];
            
        } progress:^(NSProgress * _Nonnull
                     uploadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
            [ETTUserInformationProcessingUtils showErrorMessage:result];
            
            if (result <= 0) {
                
                NSString * msg = responseObject[@"msg"];
                msg = msg.length > 0 ? msg : @"";
                NSError * error = [NSError errorWithDomain:@"HTTP_REQUEST_ERROR_DOMAIN" code:result userInfo:@{NSLocalizedDescriptionKey:msg}];
                responseCallBack(responseObject, error);
                
                NSLog(@"数据返回有问题");
                
            }else {
                
                responseCallBack(responseObject,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //
            
            responseCallBack(nil,error);
            
            NSLog(@"网络请求错误原因:%@",error);
        }];
    }

}

-(NSString *)getUploadImageNameWithUploadImageMimeType:(NSString *)mimeType rule:(kUploadImageNameRule)imageRule imageName:(NSString *)imageName;
{
    if (imageRule == kStudentCommentImage) {
        
        NSArray *array = [imageName componentsSeparatedByString:@"."];
        
        NSString *fileName = [NSString stringWithFormat:@"%@_p.%@",array.firstObject,array.lastObject];
        
        return  fileName;
    }

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *timeStr = [formatter stringFromDate:date];
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
//     schoolId_time_jid_时间戳
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_%@",userInformation.schoolId,timeStr,userInformation.jid,[ETTNetworkManager currentMsTimeString]];
    
    switch (imageRule) {
        case kStudentAnswerImage:
            fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@",mimeType.lastPathComponent]];
            break;
            
        case kTeacherSourceImage:
            fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"_r.%@",mimeType.lastPathComponent]];
            break;
            
        case kTeacherWBEncode:
            fileName = [NSString stringWithFormat:@"%@_%@_wb_%@.lpc",userInformation.schoolId,userInformation.classroomId,[ETTNetworkManager currentMsTimeString]];
            break;
            
        case kTeacherTestPaperEncode:
            fileName = [NSString stringWithFormat:@"%@_%@_test_%@.lpc",userInformation.schoolId,userInformation.classroomId,[ETTNetworkManager currentMsTimeString]];
            break;
        
        case kCacheImage:
            fileName = [NSString stringWithFormat:@"%@_cacheImage.png",userInformation.jid];
            break;
            
        default:
            break;
            
    }
    
    return fileName;
}

+ (NSString *)buildCompleteGetUrlStringWithBaseUrlString:(NSString *)baseUrlString
                                              parameters:(NSDictionary *)parameters
{
    if ([NSURL URLWithString:baseUrlString] == nil) {
        NSCAssert(NO, @"%@ 不是一个合法的URL字符串", baseUrlString);
        return nil;
    }
    
    NSMutableArray * keyValuePairsArray = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        [keyValuePairsArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    NSString * keyValuePairsString = [keyValuePairsArray componentsJoinedByString:@"&"];
    NSString * completeGetUrlString = [NSString stringWithFormat:@"%@?%@", baseUrlString, keyValuePairsString];
    
    completeGetUrlString = [completeGetUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return completeGetUrlString;
}



+ (NSString *)currentMsTimeString
{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
}

+ (NSString *)signOfInterfaceName:(NSString *)interfaceName parameters:(NSDictionary *)parameters
{
    NSMutableDictionary * parametersM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    
    for (NSString * key in parameters.allKeys) {
        
        NSCAssert([key isKindOfClass:[NSString class]], @"");
        
        NSString * valueDescription = [parameters[key] description];
        
        valueDescription = [[valueDescription stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (valueDescription.length == 0) {
            [parametersM removeObjectForKey:key];
        }
    }
    
    NSArray * allKeys = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2] == NSOrderedDescending;
    }];
    
    NSMutableArray * pairsArray = [NSMutableArray array];
    
    for (NSString * key in allKeys) {
        if (![key isEqualToString:@"dataJson"]) {
        [pairsArray addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncode(parameters[key])]];
        }
      
    }
    
    NSString * pairsString = [pairsArray componentsJoinedByString:@"&"];
    
    NSString * sign = [NSString stringWithFormat:@"%@&%@%@", interfaceName, pairsString, SECRET_KEY];
    
    sign = [base64(md5(sign)) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
    
    return sign;
}

+ (void)encryptSignatureParameters:(NSMutableDictionary *)parameters interfaceName:(NSString *)interfaceName
{
    [parameters setValue:[ETTNetworkManager currentMsTimeString] forKey:@"time"];
    [parameters setValue:[ETTNetworkManager signOfInterfaceName:interfaceName parameters:parameters] forKey:@"sign"];
}

NSString * urlEncode(id value)
{
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[value description], NULL, (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`", kCFStringEncodingUTF8));
}

NSString * md5(NSString * plaintext)
{
    const char * plaintextC = [plaintext UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(plaintextC, (CC_LONG)strlen(plaintextC), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

NSString * base64(NSString * plaintext)
{
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

@end

@implementation UIView (SimpleToast)

- (void)toast:(NSString *)msg
{
    if (msg.length == 0) {
        return;
    }
    [self makeToast:msg duration:TOAST_DURATION position:CSToastPositionCenter];
}

@end
