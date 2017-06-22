//
//  ETTOnlineFilterModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/8.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTClassUserModel.h"
@interface ETTFilterModel : ETTBaseModel
@property (nonatomic,retain)ETTClassUserModel  *  EDFilterModel;
@property (nonatomic,assign)NSInteger             EDFilterCount;


@end


@interface ETTOnlineFilterModel : ETTBaseModel
@property (nonatomic,retain)NSMutableArray <ETTFilterModel *> * EDFilterArr;

-(void)filterOnlineModel:(NSMutableArray *)onlineArr;
@end
