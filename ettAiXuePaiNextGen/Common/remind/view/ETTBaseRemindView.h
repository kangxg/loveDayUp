//
//  ETTBaseRemindView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/14.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTRemindViewInterface.h"

@interface ETTBaseRemindView : ETTView<ETTRemindViewInterface>
@property (nonatomic,retain)UIImageView    * YVRemindImageView;
@property (nonatomic,retain)UIButton       * YVTapButton;
@property (nonatomic,retain)UILabel        * YVRemindlable;
@property (nonatomic,retain) UIButton      * delBtn;
-(void)initData;
-(void)createView;
-(void)createBackGroundView;
-(void)createLableView;
-(void)createImageView;
-(void)createButtonView;
-(void)createOtherView;

-(void)beginAnimated;
-(void)removeView;

@end
