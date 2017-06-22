//
//  ETTClassListCell.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTableViewCell.h"
@class ETTClassificationModel;
@interface ETTClassListCell : ETTTableViewCell
@property (nonatomic,weak)ETTClassificationModel  * EVModel;
@property (nonatomic,retain)UILabel               * EVMarkView;
@property (nonatomic,retain)UILabel               * EVNameLabel;
@property (nonatomic,retain)UILabel               * EVCountLabel;
-(void)createLabelView;
-(void)createImageView;

@end

//在线
@interface ETTClassOnlineCell :  ETTClassListCell

@end
//旁听
@interface ETTClassAttendCell : ETTClassListCell

@end
//创建的班级
@interface ETTClassEstablishCell : ETTClassListCell
@property (nonatomic,retain)UILabel               * EVOnlineLabel;
@end




