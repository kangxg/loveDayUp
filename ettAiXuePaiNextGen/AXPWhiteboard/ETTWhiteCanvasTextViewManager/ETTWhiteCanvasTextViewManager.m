//
//  ETTWhiteCanvasTextViewManager.m
//  whiteboardDemo
//
//  Created by Li Kaining on 16/7/21.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "ETTWhiteCanvasTextViewManager.h"
#import "UIColor+RGBColor.h"
#import "UIView+UIImage.h"

// 间隙
#define kMARGIN 8

// 默认的文字大小和颜色
#define kTextColorDefault [UIColor redColor]
#define kFontSizeDefault 18
#define kTextStyleDefault @"Helvetica-Oblique"

// 默认的文本输入框的尺寸
#define kTextViewWidthDefault 170
#define kTextViewHeightDefault 44

// 默认开始增加宽度的尺寸


#define kAutoIncreaseWidthDefault 60

#define kDeviceSystemVersion [UIDevice currentDevice].systemVersion.floatValue



@interface ETTWhiteCanvasTextViewManager ()<UITextViewDelegate>

// 返回/回车 之后的回调
@property(nonatomic ,copy) textViewReturn returnHandle;

// 当前输入字符的个数
@property(nonatomic ,assign) NSUInteger currentLocation;

// 默认输入文字的长度(输入文字超过这个长度之后,textView开始变宽)
@property(nonatomic ,assign) CGFloat defaulLength;

// 文字属性/大小/颜色/字体
@property(nonatomic ,strong) NSDictionary *attributes;

// textView 的最大尺寸(不能超出屏幕之外)
@property(nonatomic ,assign) CGSize maxTextViewSize;

// textView 需要添加到的父控件
@property(nonatomic ,strong) UIView *superView;

// 点击/触摸点
@property(nonatomic ,assign) CGPoint touchPoint;

// 键盘高度
@property(nonatomic ,assign) CGFloat keyboardHeight;


@end

@implementation ETTWhiteCanvasTextViewManager

-(void)createTextViewWithPoint:(CGPoint)point superView:(UIView *)superView didCreated:(textViewDidCreated)textViewDidCreatedHandle keyboardDidReturn:(textViewReturn)returnHandle
{
    self.superView = superView;
    self.touchPoint = point;
    
    // 设置文字的字体样式/字体大小/字体颜色
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],NSForegroundColorAttributeName:self.textColor};
    
    CGSize maxSize = [self calculateTextViewSizeWithTouchPoint:point attributes:textAttributes];
    
    self.maxTextViewSize = maxSize;
    self.attributes = textAttributes;
    
    CGFloat viewW = maxSize.width > kTextViewWidthDefault ? kTextViewWidthDefault : maxSize.width;
    
    NSString *inputStr = @"隐隐约约";
    
    CGRect rect = [inputStr boundingRectWithSize:self.maxTextViewSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil];
    
    CGSize size = [self calculateSizeWithCurrentSize:rect.size];
    
    NSLog(@"-----textView:%@",NSStringFromCGRect(rect));
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(point.x, point.y, viewW +self.fontSize , size.height)];
    
    [self setUpTextView:textView];
    
    if (textViewDidCreatedHandle) {
        textViewDidCreatedHandle(textView,textAttributes);
    }
    
    if (returnHandle) {
        self.returnHandle = returnHandle;
    }

    [superView addSubview:textView];
    [textView becomeFirstResponder];
}

// 设置 textView 的初始化属性
-(void)setUpTextView:(UITextView *)textView
{
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.borderColor = kAXPLINECOLORl4.CGColor;
    textView.layer.borderWidth = 1;
    textView.font = [UIFont fontWithName:self.textStyle size:self.fontSize];
    
    textView.textColor = self.textColor;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;

    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 0.01)];
    [textView setInputAccessoryView:topView];
    
    self.textView = textView;
}

// 根据点击位置,计算 textView 的尺寸.
-(CGSize)calculateTextViewSizeWithTouchPoint:(CGPoint)point attributes:(NSDictionary *)attributes
{
    CGFloat viewX = point.x;
    CGFloat viewY = point.y;
    
    CGFloat maxW = self.superView.bounds.size.width - viewX - kMARGIN;
    CGFloat maxH = self.superView.bounds.size.height- viewY -kMARGIN - kTextViewHeightDefault;
    
    return CGSizeMake(maxW, maxH);
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    
    NSString *inputStr = textView.text;
    
    CGSize constarintSize = self.maxTextViewSize;
    
    CGRect rect = [inputStr boundingRectWithSize:constarintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil];
    
    CGSize size = rect.size;
    
    CGSize currentSize = [self calculateSizeWithCurrentSize:size];
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, currentSize.width, currentSize.height);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *inputStr = textView.text;
    
    CGSize constarintSize = self.maxTextViewSize;
    
    CGRect rect = [inputStr boundingRectWithSize:constarintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil];
    
    CGSize size = rect.size;
    
    CGSize currentSize = [self calculateSizeWithCurrentSize:size];
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, currentSize.width, currentSize.height);
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, size.width, size.height);
        
        if (self.superView.frame.origin.y < 0) {
            
            CGRect rect = self.superView.frame;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.superView.frame = CGRectMake(rect.origin.x, rect.origin.y + self.keyboardHeight , rect.size.width, rect.size.height);
            }];
        }
        
        if (self.returnHandle) {
            self.returnHandle();
        }
        
        [textView removeFromSuperview];
        
        return NO;
    }
    
    return YES;
}

-(CGSize)calculateSizeWithCurrentSize:(CGSize)size;
{
    CGFloat kwidth, kheight;
    
    if (size.width < self.defaulLength) {
    
        kwidth = MIN(kTextViewWidthDefault, self.maxTextViewSize.width);
        
    }else
    {
        CGFloat width = kTextViewWidthDefault + size.width - self.defaulLength;
        
        kwidth = MIN(width, self.maxTextViewSize.width);
    }
    
    if (size.height + kMARGIN < kTextViewHeightDefault) {
    
        kheight = kTextViewHeightDefault;
        
    }else
    {
        CGFloat height = kTextViewHeightDefault + size.height + kMARGIN;
    
        kheight = MIN(height, self.maxTextViewSize.height);
    }
    
    return CGSizeMake(kwidth, kheight);
}


static id _instance;

+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.defaulLength = kAutoIncreaseWidthDefault;
        
        self.textColor = kTextColorDefault;
        
        self.fontSize = kFontSizeDefault;
        
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notify
{
//    NSLog(@"键盘显示:%@",NSStringFromCGRect(self.superView.frame));
    
    NSDictionary *info = [notify userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.keyboardHeight = keyboardSize.height;
    
//    NSLog(@"keyBoard:%f", keyboardSize.height);
    
    if ((self.superView.frame.size.height - keyboardSize.height) < self.touchPoint.y + kTextViewHeightDefault && self.superView.frame.origin.y > 0) {
        
        CGRect rect = self.superView.frame;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.superView.frame = CGRectMake(rect.origin.x, rect.origin.y - keyboardSize.height , rect.size.width, rect.size.height);
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AXPWhiteBoardViewShouldScrollTop" object:NSStringFromCGSize(keyboardSize)];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AXPWhiteBoardViewScrollNormal" object:NSStringFromCGSize(keyboardSize)];
    }
    
//    NSLog(@"%@",NSStringFromCGRect(self.superView.frame));

}

-(void)textViewDidDone:(UITextView *)textView
{
    NSString *inputStr = textView.text;
    
    CGSize constarintSize = self.maxTextViewSize;
    
    CGRect rect = [inputStr boundingRectWithSize:constarintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil];
    
    CGSize size = rect.size;
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, size.width, size.height);    
}

- (void)keyboardWasHidden:(NSNotification *)notify
{
    NSLog(@"键盘隐藏:%@",NSStringFromCGRect(self.superView.frame));
    NSDictionary *info = [notify userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGRect rect = self.superView.frame;
    
    if ((self.superView.frame.size.height - keyboardSize.height) < self.touchPoint.y + kTextViewHeightDefault && self.superView.frame.origin.y < 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.superView.frame = CGRectMake(rect.origin.x, rect.origin.y + keyboardSize.height, rect.size.width, rect.size.height);
        }];
        
    }
}

@end
