//
//  ETTBaseCharAnimationView.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/1/10.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTView.h"
#import "ETTCharAnimationInterface.h"
@interface ETTBaseCharAnimationView : ETTView<ETTCharAnimationInterface>
@property (nonatomic,retain)NSArray  * EVInfoArr;
@property (nonatomic,retain)UILabel  * EVAnimationLabel;
-(void)initData:(id)data;
- (void)createView;
-(void)createBackGroundView;
-(void)createLableView;
-(void)createImageView;
-(void)createButtonView;
-(void)createOtherView;

-(void)beginAnimated;
-(void)removeView;

@end
