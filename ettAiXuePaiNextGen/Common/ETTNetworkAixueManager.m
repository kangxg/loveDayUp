//
//  ETTNetworkAixueManager.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTNetworkAixueManager.h"

static NSString * const SECRET_KEYS = @"*ETT#HONER#2014*";

@implementation ETTNetworkAixueManager

static ETTNetworkAixueManager *ettNetworkAixueManager;

+ (ETTNetworkAixueManager *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        ettNetworkAixueManager = [[self alloc] init];
    });
    return ettNetworkAixueManager;
}

- (AFHTTPSessionManager *)sharedManager {
    
    static AFHTTPSessionManager *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.requestSerializer.timeoutInterval = TOAST_DURATIONS;//请求超时时间
    });
    
    
    return manager;
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
    
    [ETTNetworkAixueManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
    
    [[[ETTNetworkAixueManager sharedInstance] sharedManager] POST:urlString parameters:mutableParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
        
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

+ (void)encryptSignatureParameters:(NSMutableDictionary *)parameters interfaceName:(NSString *)interfaceName
{
    [parameters setValue:[ETTNetworkAixueManager currentMsTimeString] forKey:@"time"];
    [parameters setValue:[ETTNetworkAixueManager signOfInterfaceName:interfaceName parameters:parameters] forKey:@"sign"];
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
    
    [ETTNetworkAixueManager encryptSignatureParameters:mutableParameters interfaceName:interfaceName];
    
    responseCallBack(mutableParameters,nil);
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
        
        [pairsArray addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncodes(parameters[key])]];
    }
    
    NSString * pairsString = [pairsArray componentsJoinedByString:@"&"];
    
    NSString * sign = [NSString stringWithFormat:@"%@&%@%@", interfaceName, pairsString, SECRET_KEYS];
    
    sign = [base64s(md5s(sign)) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
    
    return sign;
}

NSString * urlEncodes(id value)
{
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[value description], NULL, (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`", kCFStringEncodingUTF8));
}

NSString * md5s(NSString * plaintext)
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

NSString * base64s(NSString * plaintext)
{
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}


@end
