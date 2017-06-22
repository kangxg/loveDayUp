//
//  ETTDBManagement.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTDBManagementInterface.h"
#import "ETTDataHelperDelegate.h"
@interface ETTDBManagement : NSObject<ETTDBManagementInterface,ETTDataHelperDelegate>

+ (instancetype)sharedDBManagement;
@end
