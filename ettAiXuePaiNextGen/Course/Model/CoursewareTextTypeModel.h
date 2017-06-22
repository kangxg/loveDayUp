//
//  ETTCoursewareTextTypeModel.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/30.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTDownloadModel.h"

@interface CoursewareTextTypeModel : NSObject

@property (copy, nonatomic  ) NSString         *coursewareName;//课件名

@property (copy, nonatomic  ) NSString         *coursewareId;//课件id

@property (assign, nonatomic) NSInteger        coursewareType;//课件类型1：word2：PDF3：img4：video5：audio

@property (copy, nonatomic  ) NSString         *coursewareIcon;//课件icon url

@property (assign, nonatomic) NSInteger        visible;//可见性1：可见2：不可见

@property (copy, nonatomic  ) NSString         *coursewareUrl;//课件资源地址

@property (copy, nonatomic  ) NSString         *coursewareImg;//课件的预览图

@property (assign, nonatomic) BOOL             isShowDownloadButton;

@property (assign, nonatomic) CGFloat          progress;

@property (nonatomic)         ETTDownloadModel *downloadModel;

@end
