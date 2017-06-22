//
//  ETTDownLoadProcessingState.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/1.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTDownLoadProcessingState.h"

@implementation ETTDownLoadProcessingState
+(void)processingCreateDownloadstate:(ETTDownLoadTaskState)state
{
    [iToastSettings getSharedSettings].duration = 500;
    switch (state)
    {
        case ETTDOWNLOADTASKSTATENONE:
        {
            
        }
            break;
        case ETTDOWNLOADTASKSTATEDOWNLOADING:
        {
            [[iToast makeText:@"课件正在下载中！"]show];
        }
            break;
        case ETTDOWNLOADTASKSTATECREATEFAILE:
        {
            [[iToast makeText:@"下载课件失败！"]show];
        }
            break;
        case ETTDOWNLOADTASKSTATEMORETHANMAX:
        {
            [[iToast makeText:@"正在下载课件,请您稍后重试"]show];
        }
            break;
        case ETTDOWNLOADTASKSTATENONETWORK:
        {
            [[iToast makeText:@"当前无网络,请您稍后重试"]show];
        }
            break;
        case ETTDOWNLOADTASKSTATEFAILURE:
        {
            [[iToast makeText:@"课件下载失败"]show];
        }
            break;
            
            
        default:
            break;
    }
}

@end
