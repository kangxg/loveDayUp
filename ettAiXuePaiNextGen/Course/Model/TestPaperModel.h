//
//  TestPaperModel.h
//  ettAiXuePaiNextGen
/**
 试卷模型
 */
//  Created by Liu Chuanan on 16/9/29.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestPaperModel : NSObject

@property (copy, nonatomic  ) NSString  *testPaperId;//试卷id

@property (copy, nonatomic  ) NSString  *testPaperName;//试卷名

@property (assign, nonatomic) NSInteger subjectiveItemNum;//主观题数量

@property (assign, nonatomic) NSInteger objectiveItemNum;//客观题数量

@end
