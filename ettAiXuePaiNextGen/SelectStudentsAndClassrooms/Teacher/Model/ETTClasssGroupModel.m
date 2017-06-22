//
//  ETTClasssGroupModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClasssGroupModel.h"

@implementation ETTClasssGroupModel
@synthesize groupId    = _groupId;
@synthesize groupName  = _groupName;
@synthesize userList   = _userList;
-(BOOL)putInDataFordic:(id)data
{
    if (!data) {
        return false;
    }
    NSDictionary * dic = data;
    _groupId    = [dic valueForKey:@"groupId"];
    _groupName  = [dic valueForKey:@"groupName"];
    [self processingData:[dic valueForKey:@"userList"]];
    return YES;
}

-(void)processingData:(NSArray *)arr
{
    if (!arr|| ![arr isKindOfClass:[NSArray class]]) {
        return;
    }
    if (_userList == nil)
    {
        _userList = [[NSMutableArray alloc]init];
    }
    
    for (NSDictionary * dic in arr)
    {
        ETTClassUserModel * model = [[ETTClassUserModel alloc]init];
        [model putInDataFordic:dic];
        [_userList addObject:model];
    }
}

-(NSInteger )getUserOnlineCount
{
    NSInteger sum = 0;
    for (ETTClassUserModel * mode in _userList)
    {
        if (mode.isOnline)
        {
            sum ++;
        }
    }
    return sum;
}
-(NSInteger )getUserCount
{
    return _userList.count;
}

-(ETTClassUserModel *)getUserModelForJid:(NSInteger )userJid
{
    if (self.userList.count)
    {
        
        for (ETTClassUserModel  * userModel in _userList)
        {
            if (userJid == userModel.jid.integerValue)
            {
                return userModel;
            }
        }
    }
    
    return nil;
}
-(NSArray *)getOnlineUsers
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (ETTClassUserModel * model in _userList)
    {
        if (model.isOnline)
        {
            [arr addObject:model];
        }
    }
    return arr;
}

-(NSArray * )getOnlineusersId
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (ETTClassUserModel * model in _userList)
    {
        if (model.isOnline)
        {
            [arr addObject:model.jid];
        }
    }
    return arr;
}
-(NSDictionary *)getOnlineUserInfo
{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    NSMutableArray * nameArr = [[NSMutableArray alloc]init];
    for (ETTClassUserModel * model in _userList)
    {
        if (model.isOnline)
        {
            [arr addObject:model.jid];
            [nameArr addObject:model.userName];
        }
    }
    
    [infoDic setValue:arr forKey:@"jid"];
    [infoDic setValue:nameArr forKey:@"names"];
    return infoDic;
}


-(NSDictionary *)setupOnlineRewardsAndReturnUsers
{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    NSMutableArray * nameArr = [[NSMutableArray alloc]init];
    for (ETTClassUserModel * model in _userList)
    {
        if (model.isOnline)
        {
            model.rewardScore++;
            [arr addObject:model.jid];
            [nameArr addObject:model.userName];
        }
    }
    
    [infoDic setValue:arr forKey:@"jid"];
    [infoDic setValue:nameArr forKey:@"names"];
    return infoDic;

}
-(NSDictionary *)transformModelToNSDictionary
{
   
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (ETTClassUserModel * model in _userList)
    {
        NSDictionary * dic = [model transformModelToNSDictionary];
        [arr addObject:dic];
    }
    NSDictionary * dic = @{@"groupId":_groupId,@"groupName":_groupName,@"userList":arr};
    return dic;
}
-(NSArray  *)getAllUserIntegral
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (ETTClassUserModel * model in _userList)
    {
        NSDictionary * dic = [model getUserIntegral];
        [arr addObject:dic];
    }
    return arr;
}
-(void)updateGroupStudentsIntegral:(NSDictionary *)dic
{
    for (ETTClassUserModel * model in _userList)
    {
        if (model.jid.integerValue == [[dic valueForKey:@"jid"] integerValue]) {
            [model accumulationAssignValue:dic];
            return;
        }
    }
}

-(NSString *)getObjectInternal:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}

-(void)sortDescriptorUserOnline
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isOnline" ascending:false];
    NSArray *descriptors             = [NSArray arrayWithObjects:sortDescriptor,nil];
    
    [_userList sortUsingDescriptors:descriptors];
}

@end
