//
//  UILabel+AXPWhiteboard.m
//  test
//
//  Created by Li Kaining on 16/9/19.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "UIView+AXPWhiteboard.h"
#import "UIColor+RGBColor.h"

#define kMarginH 13
#define kMarginW 16
#define kCellHeight 44
#define kTextFont 17
#define kTitleLableWidth 90
#define kDetailLableWidth 70
#define kLableHeight 18
#define kArrowImageWidth 25
#define kArrowImageHeight 24
#define kColorViewWidth 21
#define kColorViewHeight 18
#define kSliderDescribeLabelWidth 50
#define kSliderWidth 260
#define kSelectedImageWidth 13
#define kSelectedImageHeight 10
#define kApexImageWH 12


@implementation UIView (AXPWhiteboard)

+(UIView *)creatSelectedColorView
{
    UIView *colorView = [[UIView alloc] init];
    colorView.layer.cornerRadius = 4;
    
    colorView.frame = CGRectMake(kMarginW, (kCellHeight-kColorViewHeight)/2, kColorViewWidth, kColorViewHeight);
    
    return colorView;
}
+(UILabel *)creatColorLabel
{
    UILabel *lable = [[UILabel alloc] init];
    
    lable.textColor = kAXPCOLORblack;
    lable.font = [UIFont systemFontOfSize:kTextFont];
    
    lable.frame = CGRectMake(60, kMarginH, kTitleLableWidth*2, kLableHeight);
    
    return lable;
}
+(UIImageView *)creatSelectedImageView
{
    UIImage *selectedImage = [UIImage imageNamed:@"bombbox_select_default"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:selectedImage];
    
    imageView.hidden = YES;
    imageView.frame = CGRectMake(kAXPPopWidth - kMarginW/2 - kArrowImageWidth, (kCellHeight-kSelectedImageHeight)/2, kSelectedImageWidth, kSelectedImageHeight);
    
    return imageView;
}

+(UISlider *)creatSlider
{
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.frame = CGRectMake(80 , (kCellHeight - 20)/2, kSliderWidth, 20);
    
    return slider;
}
+(UILabel *)createSliderDescribeLabel
{
    UILabel *lable = [[UILabel alloc] init];
    
    lable.textColor = kAXPTEXTCOLORf5;
    lable.font = [UIFont systemFontOfSize:kTextFont];
    lable.textAlignment = NSTextAlignmentRight;
    
    lable.frame = CGRectMake(kAXPPopWidth - kSliderDescribeLabelWidth - kMarginW , 7, kSliderDescribeLabelWidth, 30);
    
    return lable;
}

+(UIView *)creatColorView
{
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = kAXPCOLORblack;
    colorView.layer.cornerRadius = 4;
    
    colorView.frame = CGRectMake(kAXPPopWidth - kArrowImageWidth - kColorViewWidth - kMarginH, (kCellHeight-kColorViewHeight)/2, kColorViewWidth, kColorViewHeight);
    
    return colorView;
}


+(UIImageView *)creatApexImageView;
{
    UIImage *apex = [UIImage imageNamed:@"circleApexBlack"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:apex];
    
    imageView.frame = CGRectMake(kAXPPopWidth - (kMarginW + kArrowImageWidth + kApexImageWH), (kCellHeight-kApexImageWH)/2, kApexImageWH, kApexImageWH);
    
    return imageView;
}

+(UIImageView *)creatArrowImageView
{
    UIImage *arrow = [UIImage imageNamed:@"whiteboard_page_backward_default"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:arrow];
    
    imageView.frame = CGRectMake(kAXPPopWidth - kMarginW/2 - kArrowImageWidth, (kCellHeight-kArrowImageHeight)/2, kArrowImageWidth, kArrowImageHeight);
    
    return imageView;
}

+(UILabel *)creatTitleLable
{
    UILabel *lable = [[UILabel alloc] init];
    
    lable.textColor = kAXPCOLORblack;
    lable.font = [UIFont systemFontOfSize:kTextFont];
    
    lable.frame = CGRectMake(kMarginW, kMarginH, kTitleLableWidth, kLableHeight);
    
    return lable;
}
+(UILabel *)creatDetailLable
{
    UILabel *lable = [[UILabel alloc] init];
    
    lable.textColor = kAXPTEXTCOLORf5;
    lable.font = [UIFont systemFontOfSize:kTextFont];
    lable.textAlignment = NSTextAlignmentRight;
    
    lable.frame = CGRectMake(kAXPPopWidth - kArrowImageWidth - kDetailLableWidth - kMarginH , kMarginH, kDetailLableWidth, kLableHeight);
    
    return lable;
}

+(UISwitch *)creatSwitch
{
    UISwitch *axpSwitch = [[UISwitch alloc] init];
    
    axpSwitch.frame = CGRectMake(kAXPPopWidth - kMarginW - axpSwitch.bounds.size.width , (kCellHeight-axpSwitch.bounds.size.height)/2, axpSwitch.bounds.size.width, axpSwitch.bounds.size.height);
    
    return axpSwitch;
}

@end
