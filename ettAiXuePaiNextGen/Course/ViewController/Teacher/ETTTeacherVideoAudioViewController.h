//
//  ETTVideoAudioViewController.h
//  ettAiXuePaiNextGen
//
//  Created by qitong on 16/10/2.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursewareMediaTypeModel.h"

@interface ETTTeacherVideoAudioViewController : UIViewController

@property (copy, nonatomic  ) NSString                 *navigationTitle;

@property (copy, nonatomic  ) NSString                 *coursewareImg;

@property (copy, nonatomic  ) NSString                 *urlString;

@property (strong, nonatomic) CoursewareMediaTypeModel *coursewareMediaTypeModel;

@property (copy, nonatomic  ) NSString                 *jid;
@property (copy, nonatomic  ) NSString                 *classroomId;
@property (copy, nonatomic  ) NSString                 *courseId;
@property (copy, nonatomic  ) NSString                 *coursewareID;


-(void)stopAVPlay;


@end
