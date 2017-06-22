//
//  ETTBaseModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import <objc/runtime.h>
#import "NSMutableArray+merge.h"
@implementation ETTBaseModel
-(BOOL)putInData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        return [self putInDataFordic:data];
    }
    else
    {
        return [self putInDataForArr:data];
    }
    return YES;
}


-(BOOL)putInDataForArr:(id)data
{
    if (data == nil) {
        return false;
    }
    return YES;
}

-(BOOL)putInDataFordic:(id)data
{
    if (data == nil)
    {
        return false;
    }
    
    return YES;
}
-(NSDictionary *)transformModelToNSDictionary
{
    return nil;
}

-(NSArray      *)transformModelToNSArry
{
    return nil;
}
-(void)processingData:(NSArray *)arr
{
    
    
}

-(NSString     *)getClassModelToJsonString
{
    return @"";
}
-(NSString     *)getClassModelToJsonStringForModel:(id)model
{
    return @"";
}
-(NSString     *)getClassModelToJsonStringForModelArr:(NSArray *)modelArr
{
    return @"";
}
-(BOOL)accumulationAssignValue:(NSDictionary *)dic
{
    return false;
}
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.23  16:35
 modifier : 康晓光
 version  ：AIXUEPAIOS-924
 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
 describe : 师端奖励后学生端没有出现奖励数值的变化
 operation: 实现方法
 */
-(BOOL)statisticalAssignValue:(NSDictionary *)dic
{
    return false;
}
/////////////////////////////////////////////////////

-(BOOL)setAssignValue:(NSString *)key value:(NSString *)value
{
    return false;
}

-(NSString     *)getDicToJsonString:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(NSArray *)modelInfo:(Class)cls
{
    unsigned int  count = 0;
    objc_property_t  * properties= class_copyPropertyList(cls, &count);
    NSMutableArray  * infoarr = [NSMutableArray new];
    for (int i = 0; i<count; i++)
    {
        objc_property_t property = properties[i];
        NSString * name = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding ];
        
        [infoarr addObject:name];
    }
    return infoarr;
}

-(void)loadModelData:(NSString *)filePath withblock:(void (^)(NSError * error))completion
{
    NSString * path = [[NSBundle mainBundle] pathForResource:filePath ofType:@"json"];
    NSError * error = nil;
    if (path)
    {
        id data =  [NSData dataWithContentsOfFile:path];
        if (data != nil)
        {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary * dict  = [dic objectForKey:@"modelData"];
            NSMutableArray   * infoArr =  [NSMutableArray arrayWithArray:[self modelInfo:[self class]] ];
            Class currentCls = [self class];
            Class parent  = [currentCls superclass];
            while (parent)
            {
                
                [infoArr merge:[self modelInfo:currentCls]];
                currentCls = parent;
                parent =[currentCls superclass];
            }
            @autoreleasepool
            {
                
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull k, id  _Nonnull v, BOOL * _Nonnull stop)
                 {
                     if ([infoArr containsObject:k])
                     {
                         [self setValue:v forKey:k];
                     }
                     
                 }];
                
            }
        }
        else
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"读取文件错误"                                                                      forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"数据读取错误" code:-1000 userInfo:userInfo];
            
        }
    }
    else
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"读取文件错误"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"文件不存在" code:-1000 userInfo:userInfo];
    }
    completion(error);
    
}

@end
