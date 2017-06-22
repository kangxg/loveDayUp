//
//  ETTJSonStringDictionaryTransformation.m
//  ettAiXuePaiNextGen
//
//  Created by 君子 on 2016/11/2.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTJSonStringDictionaryTransformation.h"

@implementation ETTJSonStringDictionaryTransformation

/**
 *  JSON字符串转NSDictionary
 *
 *  @param jsonString JSON字符串
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)jsonStringTodictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}


/**
 *  字典转JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData    = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getJsonStringWithDictionary:(NSDictionary *)dictionary {
    
    NSString *jsonStr = @"{";

    NSArray * keys    = [dictionary allKeys];

    for (NSString * key in keys) {

    jsonStr           = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
    }

    jsonStr           = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];

    return jsonStr;
    
}

@end
