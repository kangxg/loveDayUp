//
//  ETTRememberCourseIDManager.h
//  ettAiXuePaiNextGen
/**
 记住课件id
 
 */

//  Created by Liu Chuanan on 16/10/31.
//  Copyright © 2016年 Etiantian. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ETTRememberCourseIDManager : NSObject

@property (copy, nonatomic) NSString *coursewareID;

@property (copy, nonatomic) NSString *coursewareUrl;

+ (ETTRememberCourseIDManager *)sharedManager;

@end
