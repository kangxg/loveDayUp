//
//  AXPUserInformation.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/4.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPUserInformation : NSObject

+(instancetype)sharedInformation;

@property(nonatomic ,copy) NSString *jid;

@property(nonatomic ,copy) NSString *schoolId;

@property(nonatomic ,copy) NSString *classroomId;

@property(nonatomic ,copy) NSString *userPhoto;

@property(nonatomic ,copy) NSString *userName;

@property(nonatomic ,copy) NSString *redisIp;

@property(nonatomic ,copy) NSString *userType;

@property(nonatomic ,copy) NSString *gradeId;

@property(nonatomic ,copy) NSString *subjectId;

@property(nonatomic, copy) NSString *paperRootUrl;

@property(nonatomic, copy) NSString *netClassUrl;


// 测试方法
+(instancetype)infomationWithDict:(NSDictionary *)dict;


@end
