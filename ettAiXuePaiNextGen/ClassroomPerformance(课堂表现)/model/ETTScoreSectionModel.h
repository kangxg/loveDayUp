//
//  ETTScoreSectionModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/25.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"
@interface  ETTScoreModel:ETTBaseModel
@property (nonatomic,assign)NSInteger   EDBestNum;
@property (nonatomic,assign)NSInteger   EDBestScore;
@end
@interface ETTScoreSectionModel : ETTBaseModel
@property (nonatomic,assign)NSInteger   EDFirstBest;
@property (nonatomic,assign)NSInteger   EDSecondBest;
@property (nonatomic,assign)NSInteger   EDThirdBest;
@property (nonatomic,retain)NSMutableArray <ETTScoreModel *> * ETTScoreArr;

-(NSInteger )getBestNum:(NSInteger )index;
-(NSInteger )getBestScore:(NSInteger )index;

@end
