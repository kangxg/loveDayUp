//
//  ETTClasssModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTClasssGroupModel.h"

@interface ETTClasssModel : ETTBaseModel
@property (nonatomic,copy,readonly)NSString  * className;
@property (nonatomic,copy,readonly)NSString  * classId;
@property (nonatomic,retain)NSMutableArray <ETTClasssGroupModel * >  * groupList;
-(void)setModelId:(NSString * )cid;
-(NSInteger )getClassUserOnlineCount;

-(NSInteger )getclassUserCount;
-(void)sortDescriptorUserOnline;

-(NSDictionary *)transformModelToNSDictionary;

-(BOOL)haveStudent;

-(ETTClassUserModel *)getUserModelForJid:(NSInteger )userJid;


-(NSArray  *)getAllUserIntegral;

-(void)updateStudentsIntegral:(NSDictionary *)dic;

@end
