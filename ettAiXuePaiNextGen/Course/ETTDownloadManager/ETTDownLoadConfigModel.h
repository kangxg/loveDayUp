//
//  ETTDownLoadConfigModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"


@interface ETTDownLoadConfigModel : ETTBaseModel
@property (nonatomic,retain,readonly)NSNumber * maxCount;
@property (nonatomic,retain,readonly)NSString * cacheDirectory;
@end
