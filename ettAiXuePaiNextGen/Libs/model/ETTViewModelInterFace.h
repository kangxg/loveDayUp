//
//  ETTViewModelInterFace.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTViewModelDelegate.h"
#import "ETTEnum.h"
#import "DefineBlock.h"
@protocol ETTViewModelInterFace <NSObject>
@property (nonatomic,weak)id<ETTViewModelDelegate>  EVDelegate;
-(void)putJsonData:(NSDictionary *)jsonDic withBlock:(ETTPutDataBlock)block;
-(void)putArrData:(NSArray *)arr withBlock:(ETTPutDataBlock)block;
-(void)putJsonData:(NSDictionary *)jsonDic WithType:(NSInteger )type withBlock:(ETTPutDataTypeBlock)block;
@end
