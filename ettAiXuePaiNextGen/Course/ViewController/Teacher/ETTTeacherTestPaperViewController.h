//
//  ETTExaminationPaperViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"
#import "ETTAnouncement.h"
@interface ETTTeacherTestPaperViewController : ETTViewController

@property (strong, nonatomic) UIViewController *delegate;

@property (copy, nonatomic)   NSString         *courseId;


@end
