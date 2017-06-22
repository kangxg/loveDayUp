//
//  ETTLoginInputView.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 16/9/27.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLoginInputView.h"

@interface ETTLoginInputView ()

/**
 *  @author LiuChuanan, 17-05-08 16:30:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 21
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTImageView *inputImageView;

@property (nonatomic,strong) ETTTextField *idTextField;

/**
 *  @author LiuChuanan, 17-05-08 16:30:57
 *  
 *  @brief  属性的声明,修饰用的有错误,现更正过来.避免出现一些低级错误 22
 *
 *  branch  origin/bugfix/AIXUEPAIOS-1315
 *   
 *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 * 
 *  @since 
 */
@property (nonatomic,strong) ETTImageView *passwordImageView;

@property (nonatomic,strong) ETTTextField *passwordTextField;

@property (nonatomic,strong) NSString     *defaultName;

/**
 *  记录密码按钮
 */
@property (nonatomic,strong) ETTButton *checkBtn;

@end

@implementation ETTLoginInputView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [[self setupUI]updateAttributes];
    }
    return self;
}

-(instancetype)setupUI
{
    ETTImageView *inputImageView = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:kInputImageURLStr]];
    [self addSubview:inputImageView];
    _inputImageView              = inputImageView;

    ETTTextField *idTextField    = [[ETTTextField alloc]init];
    [idTextField setPlaceholder:kLoginIdInputDefaultString];
    idTextField.delegate         = self;
    idTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    idTextField.tag              = 1;
    /**
     *  @author LiuChuanan, 17-04-27 11:10:57
     *  
     *  @brief  添加默认账号
     *
     *  branch  origin/bugfix/AIXUEPAIOS-1295
     *   
     *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
     * 
     *  @since  5。27 修改 康晓光  ModifyDefaultUserAcount527
     */



     idTextField.text             = @"";

//#ifdef ReleaseScheme
//    NSLog(@"ReleaseScheme 环境");
//    idTextField.text             = @"";
//#elif ReleaseProductScheme
//    NSLog(@"ReleaseScheme 环境");
//    idTextField.text             = @"";
//#else
//    idTextField.text             = @"AXPC@ett.com";
//    
//#endif
    [self addSubview:idTextField];
    _idTextField = idTextField;
    

    
    ETTImageView *passwordImageView   = [[ETTImageView alloc]initWithImage:[ETTImage imageNamed:@"login_icon_password"]];
    [self addSubview:passwordImageView];
    _passwordImageView                = passwordImageView;

    ETTTextField *passwordTextField   = [[ETTTextField alloc]init];
    [passwordTextField setPlaceholder:kLoginPasswordDefaultString];
    [passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate        = self;
    /**
     *  @author LiuChuanan, 17-04-27 11:10:57
     *  
     *  @brief  添加默认账号
     *
     *  branch  origin/bugfix/AIXUEPAIOS-1295
     *   
     *  Epic    origin/hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
     * 
     *  @since   5。27 修改 康晓光 ModifyDefaultUserAcount527
     */
      passwordTextField.text            = @"";
//#ifdef ReleaseScheme
//    NSLog(@"ReleaseScheme 环境");
//    passwordTextField.text             = @"";
//#elif ReleaseProductScheme
//    NSLog(@"ReleaseScheme 环境");
//    passwordTextField.text             = @"";
//#else
//    passwordTextField.text             = @"1111";
//    
//#endif
    passwordTextField.tag             = 2;
    [self addSubview:passwordTextField];
    _passwordTextField = passwordTextField;
    
    ETTButton *checkBtn      = [ETTButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setTitle:@"记住用户信息" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [checkBtn setImage:[ETTImage imageNamed:kCheckBtnNormalImageURLStr] forState:UIControlStateNormal];
    [checkBtn setImage:[ETTImage imageNamed:kCheckBtnSelectedImageURLStr] forState:UIControlStateSelected];
    [checkBtn setSelected:YES];
    [checkBtn addTarget:self action:@selector(onCheckBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkBtn];
    _checkBtn = checkBtn;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTextFieldHandler:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

-(void)onTextFieldHandler:(NSNotification *)notification
{
    NSLog(@"notifiction is %@",notification);
    UITextField *textField = (UITextField *)notification.object;
    if (textField.tag == 1) {
        if ([textField.text isEqualToString:_defaultName]) {
            if (self.MDelegate && [self.MDelegate respondsToSelector:@selector(updateUserIcon)]) {
                [self.MDelegate updateUserIcon];
            }
        }else{
            if (self.MDelegate && [self.MDelegate respondsToSelector:@selector(updateDefaultIcon)]) {
                [self.MDelegate updateDefaultIcon];
            }
        }
    }
    
    NSDictionary *dic;
    if (_idTextField.text&&_passwordTextField.text&&![_idTextField.text isEqualToString:@""]&&![_passwordTextField.text isEqualToString:@""]) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:_idTextField.text,@"id",_passwordTextField.text,@"password",@"YES",@"status", nil];
    }else{
        dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"status", nil];
        NSLog(@"text was wrong!!!");
    }
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(judgmentStatus:)]) {
        
        [self.MDelegate judgmentStatus:dic];
    }
}

-(instancetype)updateAttributes
{
    NSDictionary *userMessage = [ETTUSERDefaultManager getUSERMessage];
    if ([[userMessage objectForKey:@"selected"]isEqualToString:@"YES"]) {
        _idTextField.text       = [userMessage objectForKey:@"id"];
        _passwordTextField.text = [userMessage objectForKey:@"password"];
        _defaultName            = [userMessage objectForKey:@"id"];
        [_checkBtn setSelected:YES];
        
    }else{
        [_checkBtn setSelected:NO];
        
    }
    
    return self;
}

-(ETTLoginInputViewType)getStatus
{
    if (_idTextField.text&&_passwordTextField.text&&![_idTextField.text isEqualToString:@""]&&![_passwordTextField.text isEqualToString:@""]) {
        return ETTLoginInputViewTypeAvailable;
    }else{
        return ETTLoginInputViewTypeUnAvailable;
    }
}

-(instancetype)drawLineFrom:(CGPoint)beginPoint toPoint:(CGPoint)endPoint withWidth:(CGFloat)width
{
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    [[UIColor grayColor] set];
    CGContextSetLineWidth(context, width);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint beginIdPoint       = CGPointMake(0, _inputImageView.height+kLoginInputVInterval/2);
    CGPoint endIdPoint         = CGPointMake(self.width, beginIdPoint.y);
    [self drawLineFrom:beginIdPoint toPoint:endIdPoint withWidth:1.0];

    CGPoint beginPasswordPoint = CGPointMake(0, _passwordImageView.y+_passwordImageView.height+kLoginInputVInterval/2);
    CGPoint endPasswordPoint   = CGPointMake(self.width, beginPasswordPoint.y);
    [self drawLineFrom:beginPasswordPoint toPoint:endPasswordPoint withWidth:1.0];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_inputImageView setFrame:CGRectMake(14, 0, 24, 24)];
    [_idTextField setFrame:CGRectMake(14+24+13, 0, self.frame.size.width-14-13-24, 24)];
    
    [_passwordImageView setFrame:CGRectMake(_inputImageView.x, 24 + 2*kLoginInputVInterval, 24, 24)];
    [_passwordTextField setFrame:CGRectMake(_passwordImageView.x+_passwordImageView.width+13, _passwordImageView.y, _idTextField.width, _passwordImageView.height)];
    [_checkBtn setFrame:CGRectMake(self.width - 150, _passwordImageView.y+_passwordImageView.height+kLoginInputVInterval/2*3, 150, 20)];
}

-(void)onCheckBtnHandler:(ETTButton *)sender
{
    ETTButton *btn = sender;
    [btn setSelected:!btn.isSelected];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"status", nil];
    if (self.MDelegate&&[self.MDelegate respondsToSelector:@selector(judgmentStatus:)]) {
        [self.MDelegate judgmentStatus:dic];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [_idTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }else{
        [_passwordTextField resignFirstResponder];
        [_idTextField becomeFirstResponder];
    }
    return YES;
}


-(NSDictionary *)getUSERMessage
{
    NSString *selectedStr;
    if (_checkBtn.isSelected) {
        selectedStr = @"YES";
    }else{
        selectedStr = @"NO";
    }
    NSDictionary *userMessageDic = [[NSDictionary alloc]initWithObjectsAndKeys:_idTextField.text,@"id",_passwordTextField.text,@"password",selectedStr,@"selected", nil];
    
    return userMessageDic;
}

-(void)dealloc
{
    _idTextField = nil;
    _passwordTextField = nil;
    _checkBtn = nil;
}

@end
