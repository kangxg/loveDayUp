//
//  DefineBlock.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/20.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef DefineBlock_h
#define DefineBlock_h
#import "ETTEnum.h"
typedef void (^ ETTCallbackBlock)(id  object);
typedef void (^ ETTPutDataBlock)(ETTProcessingDataState state);
typedef void (^ ETTPutDataTypeBlock)(ETTProcessingDataState state,NSInteger type);
#endif /* DefineBlock_h */
