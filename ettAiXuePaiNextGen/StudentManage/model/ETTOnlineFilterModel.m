//
//  ETTOnlineFilterModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/2/8.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTOnlineFilterModel.h"
@implementation  ETTFilterModel
@synthesize EDFilterCount = _EDFilterCount;
@synthesize EDFilterModel = _EDFilterModel;

-(BOOL)putInData:(id)data
{
    return YES;
}
@end



@implementation ETTOnlineFilterModel
@synthesize EDFilterArr = _EDFilterArr;
-(id)init
{
    if (self = [super init])
    {
        _EDFilterArr  = [[NSMutableArray alloc]init];
        [self resetData];
    }
    return self;
}

-(void)resetData
{
 
    if (_EDFilterArr.count)
    {
        [_EDFilterArr removeAllObjects];
    }
}
-(void)filterOnlineModel:(NSMutableArray *)onlineArr
{
    if (onlineArr == nil || onlineArr.count<2)
    {
        return;
    }
    
    NSMutableSet *seenObjects = [NSMutableSet set];
    NSPredicate *dupPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        ETTClassUserModel *hObj = (ETTClassUserModel*)obj;
        BOOL seen = [seenObjects containsObject:hObj.jid];
        if (!seen) {
            [seenObjects addObject:hObj.jid];
        }
        return !seen;
    }];
   
    NSArray *yourHistoryArray = [yourHistoryArray filteredArrayUsingPredicate:dupPred];
    
    
}

-(BOOL)putInData:(id)data
{
    if (data == nil)
    {
        return false;
    }
    ETTClassUserModel * onlineModel = data;
    if (_EDFilterArr.count == 0)
    {
        ETTFilterModel * filterModel = [[ETTFilterModel alloc]init];
        filterModel.EDFilterModel    = onlineModel;
        filterModel.EDFilterCount    = 1;
        [_EDFilterArr addObject:filterModel];
        return YES;
    }
    for (ETTFilterModel * filterModel in _EDFilterArr)
    {
        if ([filterModel putInData:onlineModel])
        {
            return YES;
        }
        ETTFilterModel * filterModel = [[ETTFilterModel alloc]init];
        filterModel.EDFilterModel    = onlineModel;
        filterModel.EDFilterCount    = 1;
        [_EDFilterArr addObject:filterModel];
        
    }
    return false;
}
@end
