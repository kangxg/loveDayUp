//
//  ETTReformanceCell.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/24.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTableViewCell.h"
#import "ETTScoreSectionModel.h"
@interface ETTReformanceCell : ETTTableViewCell
-(void)updateCellViews:(ETTBaseModel *)model withScore:(ETTScoreSectionModel *)scoreModel withIndex:(NSIndexPath *)ndexPath responderCount:(NSInteger )responderCount rollcallCount:(NSInteger)rollcallCount;
@end
