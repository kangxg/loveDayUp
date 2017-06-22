//
//  ETTStudentTestPaperDetailViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/3.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"

@interface ETTStudentTestPaperDetailViewController : ETTViewController

@property (strong, nonatomic) NSString *testPaperId;

@property (strong, nonatomic) NSString *pushId;

@property (strong, nonatomic) NSString *itemIds;//推题的时候用到

@property (strong, nonatomic) NSString *courseId;

@property (copy, nonatomic  ) NSString *testPaperName;

@property (copy, nonatomic  ) NSString *paperRootUrl;//试卷根url

@property (copy, nonatomic  ) NSString *pushCurrentPage;//试卷的当前页

@property (assign, nonatomic) BOOL     isReconnectPushTestPaperAnimation;//是否是重连课堂的推送动画

@property (copy, nonatomic) NSString *pushedTestPaperId;//用于筛选答案



@end
