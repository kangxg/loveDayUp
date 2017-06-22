//
//  ETTClasssGroupModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
#import "ETTClassUserModel.h"
@interface ETTClasssGroupModel : ETTBaseModel
@property (nonatomic,copy,readonly)NSString  * groupName;
@property (nonatomic,copy,readonly)NSString  * groupId;
@property (nonatomic,retain)NSMutableArray<ETTClassUserModel *>* userList;
-(NSInteger )getUserOnlineCount;
-(NSInteger )getUserCount;
-(NSArray  *)getOnlineUsers;
-(NSArray  *)getOnlineusersId;
-(NSDictionary *)getOnlineUserInfo;

-(NSDictionary *)setupOnlineRewardsAndReturnUsers;
-(ETTClassUserModel *)getUserModelForJid:(NSInteger )userJid;
-(void)sortDescriptorUserOnline;

-(NSArray  *)getAllUserIntegral;

-(void)updateGroupStudentsIntegral:(NSDictionary *)dic;
@end
