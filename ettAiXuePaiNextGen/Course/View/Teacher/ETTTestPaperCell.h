//
//  ETTExaminationPaperCell.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/9/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTKit.h"
#import "TestPaperModel.h"

@interface ETTTestPaperCell : ETTCollectionViewCell

@property (strong, nonatomic) UIImageView *backgroundImageView;//背景图

@property (strong, nonatomic) UILabel *testPaperNameLabel;//试卷标题

@property (strong, nonatomic) UIButton *objectiveItemNumButton;//客观题按钮

@property (strong, nonatomic) UIButton *subjectiveItemNumButton;//主观题按钮

@property (strong, nonatomic) TestPaperModel *testPaperModel;//试卷列表模型

@end
