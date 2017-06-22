//
//  ETTViewsLoadedRecordManager.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTViewsLoadedRecordManager.h"
@interface ETTViewsLoadedRecordManager()
@property (nonatomic,retain)NSMutableArray *   MVViewsRecordList;
@end
@implementation ETTViewsLoadedRecordManager
-(id)init
{
    if (self = [super init])
    {
        _MVViewsRecordList = [[NSMutableArray alloc]init];
    }
    return self;
}
-(BOOL)viewHadRecord:(NSString *)viewNames
{
    if ([_MVViewsRecordList containsObject:viewNames])
    {
        return YES;
    }
    return false;
}
-(BOOL)viewRecord:(NSString *)viewNames view:(ETTView *)view
{
    if (![self viewHadRecord:viewNames])
    {
        [_MVViewsRecordList addObject:viewNames];
        return YES;
    }
    return false;
}
-(void)viewMandatoryRecord:(NSString *)viewNames view:(ETTView *)view
{
    if (![self viewHadRecord:viewNames])
    {
        [_MVViewsRecordList addObject:viewNames];
    }
}
-(void)undoRecores:(NSString *)viewNames
{
    ////////////////////////////////////////////////////////
    /*
     new      : Modify
     time     : 2017.3.17  14:00
     modifier : 康晓光
     version  ：Epic_0314_AIXUEPAIOS-1068
     branch   ：AIXUEPAIOS-1008
     describe :  白板互批后，点击查看原题和查看学生作答，需要点击两次，且最后一次页面的内容显示的是上次的推送信息 2倍
                增加字符串的空值判断
     */
    //[self removeFromSuperview];
    if (viewNames)
    {
        [_MVViewsRecordList removeObject:viewNames];
        
    }

    /////////////////////////////////////////////////////
}

-(void)resetManagerSystem
{
    [_MVViewsRecordList removeAllObjects];
    _EDTitleRecord = @"";
}
@end
