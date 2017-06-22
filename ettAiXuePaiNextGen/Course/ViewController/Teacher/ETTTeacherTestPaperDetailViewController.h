//
//  ETTTestPaperDetailViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"

@interface ETTTeacherTestPaperDetailViewController : ETTViewController

@property (strong, nonatomic) NSString *navigationTitle;

@property (strong, nonatomic) NSString *testPaperId;

@property (strong, nonatomic) NSString *pushId;

@property (strong, nonatomic) NSString *itemIds;//推题的时候用到

@property (strong, nonatomic) NSString *courseId;

@property (copy, nonatomic)   NSString *testPaperName;


@end
