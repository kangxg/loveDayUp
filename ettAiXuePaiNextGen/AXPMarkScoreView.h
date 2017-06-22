//
//  AXPMarkScoreView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"

@interface AXPMarkScoreView : ETTView

-(void)selectedScore:(NSInteger)score;

-(void)markScoreCompletionHandle:(void(^)(NSInteger markScore))completion;

@end
