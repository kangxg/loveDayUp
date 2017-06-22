//
//  ETTDataCenterManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTDataCenterInterface.h"
@interface ETTDataCenterManager : ETTBaseModel<ETTDataCenterInterface>
+(instancetype)dataCenter;
@end
