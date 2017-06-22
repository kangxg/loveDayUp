//
//  ETTTeacherResponderViewModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherResponderViewModel.h"
@interface ETTTeacherResponderViewModel ()

@property (nonatomic,retain)dispatch_semaphore_t  MDRefSemaphore;
@end

@implementation ETTTeacherResponderViewModel
@synthesize EDResponderArr = _EDResponderArr;

-(id)init
{
    if (self = [super init])
    {
        _EDResponderArr = [[NSMutableArray alloc]init];
        _MDRefSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}
-(void)putJsonData:(NSDictionary *)jsonDic withBlock:(ETTPutDataBlock)block
{
   
}
-(void)putArrData:(NSArray *)arr withBlock:(ETTPutDataBlock)block
{
    ETTProcessingDataState  state = ETTPROCESSINGDATANONE;
    if (arr == nil || arr.count == 0)
    {
       
        block(state);
        return;

    }
    dispatch_semaphore_wait(_MDRefSemaphore, DISPATCH_TIME_FOREVER);

    [self processingData:arr];
    ////////////////////////////////////////////////////////
    /*
     new      : Create
     time     : 2017.4.7  11:40
     modifier : 康晓光
     version  ：bugfix/Epic-0331-AIXUEPAIOS-1157
     branch   ：bugfix/Epic-0331-AIXUEPAIOS-1157／AIXUEPAIOS-1156
     problem  ：抢答列表的学生显示双份
     describe : 过滤强大相同的学生数据
     */
    [self filterSameResponder];
    ////////////////////////////////////////////////////////
    [self sortModer];
    state = ETTPROCESSINGDATASUCCESS;
    block(state);
    dispatch_semaphore_signal(_MDRefSemaphore);
}

-(void)processingData:(NSArray *)arr
{
    for (NSDictionary * dic in arr)
    {
        ETTResponderModel * model = [[ETTResponderModel alloc]init];
        [model putInDataFordic:dic];
   
        model.time = [dic valueForKey:@"time"];
        
        [_EDResponderArr addObject:model];
       
    }
    
   
    
}

////////////////////////////////////////////////////////
/*
 new      : Create
 time     : 2017.3.30  11:57
 modifier : 康晓光
 version  ：bugfix/Epic-0331-AIXUEPAIOS-1157
 branch   ：bugfix/Epic-0331-AIXUEPAIOS-1157／AIXUEPAIOS-1156
 problem  ：抢答列表的学生显示双份
 describe : 过滤强大相同的学生数据
 */
-(void)filterSameResponder
{
    NSMutableSet *seenObjects = [NSMutableSet set];
    NSPredicate *dupPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        ETTResponderModel *hObj = (ETTResponderModel*)obj;
        BOOL seen = [seenObjects containsObject:hObj.jid];
        if (!seen) {
            [seenObjects addObject:hObj.jid];
            
        }
        return !seen;
    }];
    
    [_EDResponderArr filterUsingPredicate:dupPred];;
    
}
/////////////////////////////////////////////////////


-(void)sortModer
{
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(ETTResponderModel *obj1,ETTResponderModel *obj2){
        
        if ([obj1.time floatValue] > [obj2.time floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([obj1.time floatValue] < [obj2.time floatValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    _EDResponderArr = [NSMutableArray arrayWithArray:[_EDResponderArr sortedArrayUsingComparator:finderSort]];
}
@end
