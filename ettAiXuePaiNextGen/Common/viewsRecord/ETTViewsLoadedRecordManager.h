//
//  ETTViewsLoadedRecordManager.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/11.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTBaseModel.h"

@interface ETTViewsLoadedRecordManager : ETTBaseModel
@property (nonatomic,copy)NSString     *   EDTitleRecord;
-(BOOL)viewHadRecord:(NSString *)viewNames;
-(BOOL)viewRecord:(NSString *)viewNames view:(ETTView *)view;

-(void)viewMandatoryRecord:(NSString *)viewNames view:(ETTView *)view;

-(void)undoRecores:(NSString *)viewNames;

-(void)resetManagerSystem;



@end
