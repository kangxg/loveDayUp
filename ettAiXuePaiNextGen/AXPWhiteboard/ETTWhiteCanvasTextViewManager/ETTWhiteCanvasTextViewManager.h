//
//  ETTWhiteCanvasTextViewManager.h
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ETTWhiteBoardView.h"


typedef void(^textViewDidCreated)(UITextView *textView,NSDictionary *textAtrributes);

typedef void(^textViewReturn)();

@interface ETTWhiteCanvasTextViewManager : NSObject

// 文字大小/颜色/字体
@property(nonatomic ,copy) NSString *textStyle;

@property(nonatomic ,assign) CGFloat fontSize;

@property(nonatomic ,strong) UIColor *textColor;

// 键盘是否显示

@property(nonatomic ,strong) UITextView *textView;


+(instancetype)sharedManager;

/**
 *  @author DeveloperLx, 16-08-02 13:08:17
 *
 *  @brief 创建文字输入框
 *
 *  @param point                    文字输入框的左上角位置
 *  @param superView                文字输入框添加到哪个View上.
 *  @param textViewDidCreatedHandle 文字输入框创建完成之后的回调.
 *  @param returnHandle             点击键盘return之后的回调.
 *
 *  @since 0.0
 */
-(void)createTextViewWithPoint:(CGPoint)point superView:(UIView *)superView didCreated:(textViewDidCreated)textViewDidCreatedHandle keyboardDidReturn:(textViewReturn)returnHandle;

-(void)textViewDidDone:(UITextView *)textView;

@end
