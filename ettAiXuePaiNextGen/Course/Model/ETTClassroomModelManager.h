//
//  ETTClassroomModelManager.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/28.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTOpenClassroomDoBackModel.h"

@interface ETTClassroomModelManager : NSObject

@property (strong, nonatomic) ETTOpenClassroomDoBackModel *openClassroomDoBackModel;

+ (ETTClassroomModelManager *)sharedManager;

@end
