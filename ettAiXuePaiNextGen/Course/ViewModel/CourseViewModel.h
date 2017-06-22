//
//  ViewModel.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  课程数据回调block
 *
 *  @param callBack block
 */
typedef void (^CallBackBlock) (id callBack);

@interface CourseViewModel : NSObject

/**
 *  获取课程列表数据
 *
 *  @param callback 回调block
 */
- (void)getCourseDataWithCallBack:(CallBackBlock)callback;

@end
