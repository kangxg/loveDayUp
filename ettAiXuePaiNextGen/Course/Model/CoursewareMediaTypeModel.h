//
//  CoursewareMediaTypeModel.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/8.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursewareMediaTypeModel : NSObject

@property (copy, nonatomic  ) NSString  *coursewareName;//课件名

@property (copy, nonatomic  ) NSString  *coursewareId;//课件id

@property (assign, nonatomic) NSInteger coursewareType;//课件类型1：word2：PDF3：img4：video5：audio

@property (copy, nonatomic  ) NSString  *coursewareIcon;//课件icon url

@property (assign, nonatomic) NSInteger visible;//可见性1：可见2：不可见

@property (copy, nonatomic  ) NSString  *coursewareUrl;//课件资源地址

@property (copy, nonatomic  ) NSString  *coursewareImg;//课件的预览图

@property (assign, nonatomic) NSInteger uploadSource;//上传来源1:pad录屏微课;0:其他

@property (copy, nonatomic  ) NSString  *duration;//Pad录屏微课时长

@property (assign, nonatomic) float lastTime;//上次播放时间

@end
