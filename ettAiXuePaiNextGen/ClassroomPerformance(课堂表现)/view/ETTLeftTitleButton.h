//
//  ETTLeftTitleButton.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/29.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

/**
 Description  学生端 课程表现  班级名称显示视图

 */
#import "ETTView.h"

@interface ETTLeftTitleButton : ETTView
@property (nonatomic,retain)UILabel  *  EVTitleLabe;
@property (nonatomic,copy)NSString   *  EVTitle;
@property (nonatomic,assign)BOOL        EVViewSelected;
-(void)resetViewCanSelect:(NSInteger)count;
@end
