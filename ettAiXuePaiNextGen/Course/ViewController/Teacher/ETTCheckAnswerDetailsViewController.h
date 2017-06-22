//
//  ETTCheckAnswerDetailsViewController.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/21.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTViewController.h"

@interface ETTCheckAnswerDetailsViewController : ETTViewController

@property(nonatomic ) BOOL isHasPaperComment;

-(instancetype)initWithAnswerData:(NSDictionary *)answerData classroomDict:(NSDictionary *)classroomDict;

@end
