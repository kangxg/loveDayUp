//
//  ETTJSonStringDictionaryTransformation.h
//  ettAiXuePaiNextGen
//
//  Created by 君子 on 2016/11/2.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTJSonStringDictionaryTransformation : NSObject

/**
 *  JSON字符串转NSDictionary
 *
 *  @param jsonString JSON字符串
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)jsonStringTodictionary:(NSString *)jsonString;

/**
 *  字典转JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  字典转JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
+ (NSString *)getJsonStringWithDictionary:(NSDictionary *)dictionary;

@end
