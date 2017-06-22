//
//  ViewModel.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "CourseViewModel.h"
#import <AFNetworking.h>

@implementation CourseViewModel


- (void)getCourseDataWithCallBack:(CallBackBlock)callback {
    
    NSMutableArray *courseModelArray = [NSMutableArray array];
    
//    if (本地有) {
//    
//    } else {//本地没有发送网络请求
//    
//    
//    }
    
    
    
    NSString *urlString; //= [NSString stringWithFormat:@"%@,%@",testHost,openClassroomTest];

    NSDate *date                = [NSDate dateWithTimeIntervalSinceNow:0];

    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;

    NSNumber *timeNum           = [NSNumber numberWithInteger:timeInterval];
    
    
    NSDictionary *params = @{@"jid":@"jid",
                             @"schoolId":@"schoolId",
                             @"gradeId":@123,
                             @"subjectId":@123,
                             @"time":timeNum,
                             @"sign":@""
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    //模型解析
    
    
    //将数组传到控制器中
    callback(courseModelArray);
}

@end
