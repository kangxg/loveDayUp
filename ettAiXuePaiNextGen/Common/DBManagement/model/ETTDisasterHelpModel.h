//
//  ETTDisasterHelpModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/5/5.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDataHelperModel.h"
#import "ETTTaskInterface.h"
@interface ETTDisasterHelpModel : ETTDataHelperModel
-(NSString *)selectDisasterMessage:(NSString *)uid withkey:(NSString *)key;

-(void)updateClassActionCache:(NSString *)uid withTask:( id<ETTTaskInterface>)task;

-(void)updateClassActionCache:(NSString *)uid withTask:( id<ETTTaskInterface>)task withField:(NSString *)field;
-(void)deleteClassActionCache:(NSString *)uid withTask:( id<ETTTaskInterface>)task;
@end
