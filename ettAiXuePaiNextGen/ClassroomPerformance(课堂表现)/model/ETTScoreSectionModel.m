//
//  ETTScoreSectionModel.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTScoreSectionModel.h"
@implementation  ETTScoreModel
@synthesize EDBestNum,EDBestScore;
@end


@implementation ETTScoreSectionModel
@synthesize ETTScoreArr = _ETTScoreArr;
-(id)init
{
    if (self = [super init])
    {
        _ETTScoreArr  = [[NSMutableArray alloc]init];
        [self resetData];
    }
    return self;
}
-(BOOL)putInDataForArr:(id)data
{
    
    if (!data)
    {
        return false;
    }
    [self resetData];
    NSArray * arr = data;
    for (int i  = 0; i<arr.count;i++ )
    {
        
        if (i == 0)
        {
            _EDFirstBest = [arr[i] integerValue];
        }
        ETTScoreModel  * model = [[ETTScoreModel alloc]init];
        model.EDBestNum   = i+1;
        model.EDBestScore = [arr[i] integerValue];
        [_ETTScoreArr addObject:model];
            
    }
    return true;
}

-(void)resetData
{
    _EDThirdBest  = 0;
    _EDSecondBest = 0;
    _EDThirdBest  = 0;
    if (_ETTScoreArr.count)
    {
        [_ETTScoreArr removeAllObjects];
    }
}

-(NSInteger )getBestNum:(NSInteger )index
{
    if (index<0 || index>(_ETTScoreArr.count-1))
    {
        return 0;
    }
    return _ETTScoreArr[index].EDBestNum;
}
-(NSInteger )getBestScore:(NSInteger )index
{
    if (index<0 || index>(_ETTScoreArr.count-1))
    {
        return 0;
    }
    return _ETTScoreArr[index].EDBestScore;
}
@end
