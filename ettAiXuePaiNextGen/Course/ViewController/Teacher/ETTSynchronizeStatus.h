//
//  ETTSynchronizeStatus.h
//  ettAiXuePaiNextGen
/**
 这个单例用来记录老师上次推送过来的音视频地址
 
 */
//  Created by Liu Chuanan on 16/11/3.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ETTSynchronizeStatus : NSObject

@property (copy, nonatomic) NSString *lastUrlString;

+ (ETTSynchronizeStatus *)sharedManager;

@end
