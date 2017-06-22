//
//  UILabel+AXPWhiteboard.h
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AXPWhiteboard)

+(UILabel *)creatTitleLable;
+(UILabel *)creatDetailLable;
+(UIImageView *)creatArrowImageView;

+(UIImageView *)creatApexImageView;

+(UIView *)creatColorView;

+(UISwitch *)creatSwitch;

+(UISlider *)creatSlider;
+(UILabel *)createSliderDescribeLabel;

+(UIView *)creatSelectedColorView;
+(UILabel *)creatColorLabel;
+(UIImageView *)creatSelectedImageView;

@end
