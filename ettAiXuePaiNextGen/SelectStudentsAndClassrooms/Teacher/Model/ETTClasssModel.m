//
//  ETTClasssModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTClasssModel.h"

@implementation ETTClasssModel
@synthesize className = _className;
@synthesize classId   = _classId;
@synthesize groupList = _groupList;


-(void)setModelId:(NSString *)cid
{
    if (cid.length)
    {
        _classId = cid;
    }
}

-(BOOL)putInDataFordic:(id)data
{
    if (!data)
    {
        return false;
    }
    NSDictionary * dic = data;
    _classId   = [dic valueForKey:@"classId"];
    _className = [dic valueForKey:@"className"];
    [self processingData:[dic valueForKey:@"groupList"]];
    return YES;
}

-(void)processingData:(NSArray *)arr
{
    if (!arr|| ![arr isKindOfClass:[NSArray class]]) {
        return;
    }
    if (_groupList == nil)
    {
        _groupList = [[NSMutableArray alloc]init];
    }
    
    for (NSDictionary * dic in arr)
    {
        ETTClasssGroupModel * model = [[ETTClasssGroupModel alloc]init];
        [model putInDataFordic:dic];
        [_groupList addObject:model];
    }
}

-(NSInteger )getClassUserOnlineCount
{
    NSInteger count = 0;
    for (ETTClasssGroupModel * model in _groupList)
    {
        count += [model getUserOnlineCount];
    }
    return count;
}
-(ETTClassUserModel *)getUserModelForJid:(NSInteger )userJid
{
    if ([self haveStudent])
    {
        for (ETTClasssGroupModel * group  in _groupList)
        {
            ETTClassUserModel * umodel = [group getUserModelForJid:userJid];
            if (umodel)
            {
                return umodel;
            }
          
        }
    }
    return nil;
}
-(NSInteger )getclassUserCount
{
    NSInteger count = 0;
    for (ETTClasssGroupModel * model in _groupList)
    {
        count += [model getUserCount];
    }
    return count;
}
-(void)sortDescriptorUserOnline
{
    for (ETTClasssGroupModel * model in _groupList)
    {
        [model sortDescriptorUserOnline];
    }
}

-(NSDictionary *)transformModelToNSDictionary
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (ETTClasssGroupModel * model in _groupList)
    {
        NSDictionary * dic = [model transformModelToNSDictionary];
        [arr addObject:dic];
    }
    NSDictionary *  classDic = @{@"classId":_classId,@"className":_className,@"groupList":arr};
    return classDic;
}
-(NSArray  *)getAllUserIntegral
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (ETTClasssGroupModel * model in _groupList)
    {
        [arr addObjectsFromArray:[model getAllUserIntegral]];
    }
    return arr;
}

-(void)updateStudentsIntegral:(NSDictionary *)dic
{
    for (ETTClasssGroupModel * model in _groupList)
    {
        [model updateGroupStudentsIntegral: dic];
    }

}
-(BOOL)haveStudent
{
    if (!_groupList || !_groupList.count)
    {
        return false;
    }
    
    return YES;
}

@end
