//
//  ETTTeacherResponderViewModel.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTBaseViewModel.h"
#import "ETTClassUserModel.h"
@interface ETTTeacherResponderViewModel : ETTBaseViewModel
@property (nonatomic,assign)NSInteger                             EDResponderCount;
@property (nonatomic,retain)NSMutableArray <ETTResponderModel *> *  EDResponderArr;
@end
