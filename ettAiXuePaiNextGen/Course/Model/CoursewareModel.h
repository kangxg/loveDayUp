//
//  CoursewareModel.h
//  ettAiXuePaiNextGen
/**

 1.获取课件列表
 
 */
//  Created by Liu Chuanan on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursewareModel : NSObject

@property (copy, nonatomic  ) NSString  *coursewareName;//课件名称

@property (copy, nonatomic  ) NSString  *coursewareId;//课件id

@property (assign, nonatomic) NSInteger coursewareType;//课件类型

@property (assign, nonatomic) NSInteger visible;//是否可见1,可见;2,不可见

@property (copy, nonatomic  ) NSString  *coursewareIcon;//icon的url

@property (copy, nonatomic  ) NSString  *coursewareUrl;//课件资源地址

@property (copy, nonatomic)   NSString  *coursewareImg;//课件的预览图


@end
