//
//  ETTClasssModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTClasssGroupModel.h"
@interface ETTClasssModel : ETTBaseModel<NSCoding>
@property (nonatomic,copy,readonly)NSString  * className;
@property (nonatomic,copy,readonly)NSString  * classId;
@property (nonatomic,retain)NSMutableArray <ETTClasssGroupModel * >  * groupList;

-(NSInteger )getClassUserOnlineCount;
-(NSInteger )getclassUserCount;
@end
