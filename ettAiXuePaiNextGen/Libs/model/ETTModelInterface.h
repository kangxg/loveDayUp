//
//  ETTModelInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETTModelInterface <NSObject>
@optional
-(BOOL)putInData:(id)data;
-(BOOL)putInDataForArr:(id)data;
-(BOOL)putInDataFordic:(id)data;
-(void)processingData:(NSArray *)arr;
-(NSArray *)modelInfo:(Class)cls;

-(NSDictionary *)transformModelToNSDictionary;
-(NSArray      *)transformModelToNSArry;
-(NSString     *)getClassModelToJsonString;
-(NSString     *)getClassModelToJsonStringForModel:(id)model;
-(NSString     *)getClassModelToJsonStringForModelArr:(NSArray *)modelArr;
-(NSString     *)getDicToJsonString:(NSDictionary *)dic;

-(BOOL)setAssignValue:(NSString *)key value:(NSString *)value;
-(BOOL)accumulationAssignValue:(NSDictionary *)dic;
////////////////////////////////////////////////////////
/*
 new      : add
 time     : 2017.3.23  16:36
 modifier : 康晓光
 version  ：AIXUEPAIOS-924
 branch   ：AIXUEPAIOS-924／AIXUEPAIOS-1131
 describe : 师端奖励后学生端没有出现奖励数值的变化
 operation: 主要用于学生端 课堂表现  对应的数据model
 */
-(BOOL)statisticalAssignValue:(NSDictionary *)dic;

/////////////////////////////////////////////////////


-(void)loadModelData:(NSString *)filePath withblock:(void (^)(NSError * error))completion;
@end
