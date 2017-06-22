//
//  ETTTeacherCommandView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTStudentManageEnum.h"
@class ETTClassificationModel ;
@interface ETTTeacherCommandView : ETTView
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)ETTTeacherCommandType  EVType;
-(void)initData;
-(void)createImageview;
-(void)createLabelView;
-(void)createButtonView;
-(void)reloadView:(ETTClassificationModel *)model;

@end

@interface ETTLockScreenCommandView : ETTTeacherCommandView

@end
@interface ETTRollCallCommandView : ETTTeacherCommandView

@end
@interface ETTReponderCommandView : ETTTeacherCommandView

@end

@interface ETTGroupCommandView : ETTTeacherCommandView

@end


@interface ETTTVCommandView : ETTTeacherCommandView

@end
