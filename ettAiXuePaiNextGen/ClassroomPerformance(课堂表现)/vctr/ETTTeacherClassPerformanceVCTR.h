//
//  ETTTeacherClassPerformanceVCTR.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClassPerformanceVCTR.h"
@class ETTClasssModel;
@interface ETTTeacherClassPerformanceVCTR : ETTClassPerformanceVCTR
@property  (nonatomic,copy)   NSString        * EVClassId;
@property  (nonatomic,retain) ETTClasssModel  * EVClassModel;
@end
