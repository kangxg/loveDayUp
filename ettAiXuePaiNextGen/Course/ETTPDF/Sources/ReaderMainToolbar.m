//
//	ReaderMainToolbar.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//


#import "ReaderConstants.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"
#import <MessageUI/MessageUI.h>
#import "ETTSideNavigationViewController.h"
#import "ETTBackToPageManager.h"
#import "ETTRememberCourseIDManager.h"
#import "AXPRedisManager.h"
#import "AXPUserInformation.h"
#import "ETTJSonStringDictionaryTransformation.h"
#import "ETTRedisBasisManager.h"
#import "ETTJudgeIdentity.h"
#import "ETTGovernmentTask.h"
#import "ETTAnouncement.h"
#import "ETTCoursewarePresentViewControllerManager.h"

#import "ETTRestoreCommand.h"

#import "ETTScenePorter.h"
#import "ETTGovernmentTask.h"
@interface ReaderMainToolbar ()

@property (strong, nonatomic) NSDictionary *pushDict;

@end

@implementation ReaderMainToolbar
{
    UIButton *markButton;
    
    UIImage *markImageN;
    UIImage *markImageY;
}

#pragma mark - Constants

#define BUTTON_X 20.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 19.0f
#define TITLE_HEIGHT 28.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ReaderMainToolbar instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor colorWithRed:38.0/225 green:147.0/255 blue:220.0/255 alpha:1.0];
    ETTLog(@"%d",self.currentPage);
    
    return [self initWithFrame:frame document:nil];
}

- (instancetype)initWithFrame:(CGRect)frame document:(ReaderDocument *)document
{
    assert(document != nil); // Must have a valid ReaderDocument
    
    if ((self = [super initWithFrame:frame]))
    {
        CGFloat viewWidth = self.bounds.size.width; // Toolbar view width
        
#if (READER_FLAT_UI == TRUE) // Option
        UIImage *buttonH = nil;
        
        UIImage *buttonN = nil;
#else
        UIImage *buttonH = [[UIImage imageNamed:@"Reader-Button-H"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonN = [[UIImage imageNamed:@"Reader-Button-N"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
#endif // end of READER_FLAT_UI Option
        
        BOOL largeDevice              = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);

        const CGFloat buttonSpacing   = BUTTON_SPACE;

        const CGFloat iconButtonWidth = ICON_BUTTON_WIDTH;

        CGFloat titleX                = BUTTON_X;

        CGFloat titleWidth            = (viewWidth - (titleX + titleX));

        CGFloat leftButtonX = BUTTON_X; // Left-side button start X position
        
#if (READER_STANDALONE == FALSE) // Option
        
        UIFont *doneButtonFont      = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
        NSString *doneButtonText    = NSLocalizedString(@"返回", @"button");//国际化
        CGSize doneButtonSize       = [doneButtonText sizeWithFont:doneButtonFont];
        CGFloat doneButtonWidth     = (doneButtonSize.width + TEXT_BUTTON_PADDING);

        UIButton *doneButton        = [UIButton buttonWithType:UIButtonTypeCustom];

        doneButton.frame            = CGRectMake(BUTTON_X, 0, 80, 41);
        [doneButton setImage:[UIImage imageNamed:@"navbar_btn_back_default"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"navbar_btn_back_pressed"] forState:UIControlStateHighlighted];
        [doneButton setTitle:@"返回" forState:UIControlStateNormal];
        doneButton.imageEdgeInsets  = UIEdgeInsetsMake(5, 0, 5, 50);
        doneButton.titleEdgeInsets  = UIEdgeInsetsMake(5, -30, 5, 0);
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];

        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
        [doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        doneButton.autoresizingMask = UIViewAutoresizingNone;
        //doneButton.backgroundColor = [UIColor grayColor];
        doneButton.exclusiveTouch   = YES;
        
        [self addSubview:doneButton];
        
        leftButtonX += (doneButtonWidth + buttonSpacing);

        titleX      += (doneButtonWidth + buttonSpacing);

        titleWidth -= (doneButtonWidth + buttonSpacing);
        
#endif // end of READER_STANDALONE Option
        
#if (READER_ENABLE_THUMBS == TRUE) // Option  缩略图按钮
        
        UIButton *thumbsButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        //thumbsButton.frame = CGRectMake(leftButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
        thumbsButton.frame                     = CGRectMake(CGRectGetMaxX(doneButton.frame), 0, 36, 41);
        [thumbsButton setImage:[UIImage imageNamed:@"navbar_btn_thumbnail_default"] forState:UIControlStateNormal];
        [thumbsButton setImage:[UIImage imageNamed:@"navbar_btn_thumbnail_pressed"] forState:UIControlStateHighlighted];

        [thumbsButton addTarget:self action:@selector(thumbsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        thumbsButton.exclusiveTouch            = YES;

        ETTSideNavigationViewIdentity identity = [ETTJudgeIdentity getCurrentIdentity];
        
        //如果不是老师隐藏(也就是学生)隐藏上面缩略图按钮
        if (!(identity == ETTSideNavigationViewIdentityTeacher)) {
            
            
        }
        thumbsButton.hidden = YES;
        
        
        [self addSubview:thumbsButton]; 
        
#endif // end of READER_ENABLE_THUMBS Option
        
        CGFloat rightButtonX = viewWidth; // Right-side buttons start X position
        
#if (READER_BOOKMARKS == TRUE) // Option
        
        rightButtonX -= (iconButtonWidth + buttonSpacing); // Position
        
        UIButton *flagButton        = [UIButton buttonWithType:UIButtonTypeCustom];
        flagButton.frame            = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
        [flagButton addTarget:self action:@selector(markButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [flagButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
        [flagButton setBackgroundImage:buttonN forState:UIControlStateNormal];
        flagButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        flagButton.exclusiveTouch   = YES;

        titleWidth                  -= (iconButtonWidth + buttonSpacing);

        markButton                  = flagButton;

        markButton.enabled          = NO;

        markButton.tag              = NSIntegerMin;

        markImageN                  = [UIImage imageNamed:@"Reader-Mark-N"];// N image
        markImageY                  = [UIImage imageNamed:@"Reader-Mark-Y"];// Y image
        
#endif // end of READER_BOOKMARKS Option
        
        //邮件分享
        if (document.canEmail == YES) // Document email enabled
        {
            if ([MFMailComposeViewController canSendMail] == YES) // Can email
            {
                unsigned long long fileSize = [document.fileSize unsignedLongLongValue];
                
                if (fileSize < 15728640ull) // Check attachment size limit (15MB)
                {
                    rightButtonX -= (iconButtonWidth + buttonSpacing); // Next position
                    
                    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    emailButton.frame = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
                    [emailButton setImage:[UIImage imageNamed:@"Reader-Email"] forState:UIControlStateNormal];
                    [emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [emailButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
                    [emailButton setBackgroundImage:buttonN forState:UIControlStateNormal];
                    emailButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    emailButton.exclusiveTouch = YES;
                    
                    titleWidth -= (iconButtonWidth + buttonSpacing);
                }
            }
        }
        
        //添加打印机
        if ((document.canPrint == YES) && (document.password == nil)) // Document print enabled
        {
            Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
            
            if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
            {
                rightButtonX -= (iconButtonWidth + buttonSpacing); // Next position
                
                UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];
                printButton.frame = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
                [printButton setImage:[UIImage imageNamed:@"Reader-Print"] forState:UIControlStateNormal];
                [printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
                [printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
                printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                printButton.exclusiveTouch = YES;
                
                titleWidth -= (iconButtonWidth + buttonSpacing);
            }
        }
        
        //导出
        if (document.canExport == YES) // Document export enabled
        {
            rightButtonX -= (iconButtonWidth + buttonSpacing); // Next position
            
            UIButton *exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
            exportButton.frame = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
            [exportButton setImage:[UIImage imageNamed:@"Reader-Export"] forState:UIControlStateNormal];
            [exportButton addTarget:self action:@selector(exportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [exportButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
            [exportButton setBackgroundImage:buttonN forState:UIControlStateNormal];
            exportButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            exportButton.exclusiveTouch = YES;
            
            titleWidth -= (iconButtonWidth + buttonSpacing);
        }
        
        if (largeDevice == YES) // Show document filename in toolbar
        {
            CGRect titleRect = CGRectMake(titleX, BUTTON_Y, titleWidth, TITLE_HEIGHT);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            titleLabel.font = [UIFont systemFontOfSize:17.0];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.minimumScaleFactor = 0.75f;
#if (READER_FLAT_UI == FALSE) // Option
            titleLabel.shadowColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
            titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
#endif // end of READER_FLAT_UI Option
            
            titleLabel.centerX = self.centerX;
            
            //中间标题
            [self addSubview:titleLabel];
            self.titleLabel = titleLabel;
            
            //如果是老师才添加推送按钮 学生那边要隐藏掉
            ETTSideNavigationViewController *sideNav = [ETTJudgeIdentity getSideNavigationViewController];
            if (sideNav.identity == ETTSideNavigationViewIdentityTeacher) {
                
                //                [ETTBackToPageManager sharedManager].isPushing = NO;
                
                //推送按钮
                UIButton *pushBtn = [[UIButton alloc]init];
                CGFloat pushBtnWidth = 100;
                CGFloat pushBtnHeight = 44;
                [pushBtn setFrame:CGRectMake(self.bounds.size.width - pushBtnWidth - 10, (self.bounds.size.height - pushBtnHeight ) /2, pushBtnWidth, pushBtnHeight)];
                pushBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
                [pushBtn setTitle:@"推送" forState:UIControlStateNormal];
                [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [pushBtn setTitleColor:ETTBUTTON_HIGHLIGHTED_COLOR forState:UIControlStateHighlighted];
                pushBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
                [pushBtn addTarget:self action:@selector(pushBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:pushBtn];
                self.pushBtn = pushBtn;
                
                //结束推送按钮
                UIButton *endPushBtn = [[UIButton alloc]init];
                [endPushBtn setHidden:YES];
                CGFloat endPushBtnWidth = 100;
                CGFloat endPushBtnHeight = 44;
                [endPushBtn setFrame:CGRectMake(self.bounds.size.width - endPushBtnWidth - 10, (self.bounds.size.height - endPushBtnHeight) / 2, endPushBtnWidth, endPushBtnHeight)];
                endPushBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
                [endPushBtn setTitle:@"结束推送" forState:UIControlStateNormal];
                [endPushBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                endPushBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                [endPushBtn addTarget:self action:@selector(endPushBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:endPushBtn];
                self.endPushBtn = endPushBtn;
            }
            
        }
    }
    
    return self;
}
- (void)setPushButtonViewHiden:(BOOL)hiden
{
    if (hiden)
    {
        self.pushBtn.hidden = hiden;
        self.endPushBtn.hidden = hiden;
    }
    
}

//右边推送按钮的点击
- (void)pushBtnDidClick:(UIButton *)button {
    
    /**点击课件推送要做的事情:
     1.将不可见课件变成课件
     2.改变按钮的状态
     3.快捷返回条弹出
     4.将推送信息传到redis然后推到学生
     
     */
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
    if ( [ETTBackToPageManager sharedManager].isPushing == NO) {
        
        if ([self.delegate respondsToSelector:@selector(tappedInToolbar:pushButton:)]) {
            
            [self.delegate tappedInToolbar:self pushButton:button];
            
        }
        
        //1.将不可见课件变成课件
        [self changeCoursewareVisible];
        
        //2.更改按钮的可见性
        [self changeButtonHiddenOrAppear];
        
        [ETTBackToPageManager sharedManager].coursewareID = self.coursewareID;
        
        //记住当前推送课件的url
        [ETTBackToPageManager sharedManager].coursewareUrl = self.coursewareUrl;
        
        //3.快捷返回条弹出
        
        //4.将推送信息传到redis然后推到学生
        [self pushCoursewareInfoToStudent];
        
        [ETTBackToPageManager sharedManager].isPushing = YES;
        
    }
}


/**
 1.更改课件的可见性
 */
- (void)changeCoursewareVisible {
    
    AXPUserInformation *userInformation = [AXPUserInformation sharedInformation];
    
    NSDictionary *params = @{@"jid":userInformation.jid,
                             @"classroomId":userInformation.classroomId,
                             @"courseId":self.courseId,
                             @"coursewareId":self.coursewareID};
    
    ETTLog(@"coursewareID%@",self.coursewareID);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_HOST,setCoursewareVisible];
    [[ETTNetworkManager sharedInstance]POST:urlStr Parameters:params responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        
        if (error) {
            [self toast:@"网络有问题"];
        }
        
        NSNumber *result = responseDictionary[@"result"];
        
        if ([result isEqual:@1]) {
            ETTLog(@"更改课件可见性成功");
        }
    }];
    
}


/**
 2.更改按钮的可见性
 */
- (void)changeButtonHiddenOrAppear {
    
    if ([ETTBackToPageManager sharedManager].isPushing == NO) {
        
        [self.pushBtn setHidden:YES];
        if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
        {
            [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDPUSHFILES withInfo:@{@"push":@(YES)}];
        }
        [self.endPushBtn setHidden:NO];
        [self.endPushBtn setEnabled:NO];
        [self.endPushBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //2秒后出现
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.endPushBtn setEnabled:YES];
            [self.endPushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.endPushBtn setTitleColor:ETTBUTTON_HIGHLIGHTED_COLOR forState:UIControlStateHighlighted];
        });
    } else {
        
        [self.endPushBtn setHidden:YES];
        
        if (self.EVDelegate && [self.EVDelegate respondsToSelector:@selector(pEvenFunctionOperation:withCommandType:withInfo:)])
        {
            [self.EVDelegate pEvenFunctionOperation:self withCommandType:ETTTEACHERMOMMANDPUSHFILES withInfo:@{@"push":@(false)}];
        }
        [self.pushBtn setHidden:NO];
        [self.pushBtn setEnabled:NO];
        [self.pushBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //2秒后出现
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pushBtn setEnabled:YES];
            [self.pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.pushBtn setTitleColor:ETTBUTTON_HIGHLIGHTED_COLOR forState:UIControlStateHighlighted];
        });
    }
}


/**
 4.将推送信息传到redis然后推到学生
 */
- (void)pushCoursewareInfoToStudent {
    
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *userInfo = @{@"coursewareUrl":[NSString stringWithFormat:@"%@*%@*%@",self.coursewareUrl,self.coursewareID,self.navigationTitle],
                               @"CO_02_state":@"CO_02_state1",
                               @"currentPage":[NSString stringWithFormat:@"%ld",(long)self.currentPage]
                               };
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_02",
                            @"userInfo":userInfo
                            };
    NSDictionary *theUserInfo = @{@"type":@"CO_02",
                                  @"theUserInfo":dict
                                  };
    
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    NSDictionary * expDic = @{@"coursewareId":self.coursewareID,@"coursewareUrl":self.coursewareUrl,@"courseId":self.courseId,@"navigationTitle":self.navigationTitle};
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    [task setExtensionData:@"exp" value:expDic];
    [task setExtensionData:@"title" value:[ETTScenePorter shareScenePorter].EDViewRecordManager.EDTitleRecord ];
    [task setOperationState:ETTBACKOPERATIONSTATEWILLBEGAIN];
    [task putInDataFordic:theUserInfo];
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:nil];
    
    NSString *key = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    NSString *theUserInfoJson = [ETTRedisBasisManager getJSONWithDictionary:theUserInfo];
    
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) {
            
            [redisManager publishMessageToChannel:key message:messageJSON  respondHandler:^(id value, id error) {
                if (!error) {
                    //NSLog(@"成功发送消息%@",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATESTART];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];
                    
                }else{
                    NSLog(@"发送消息%@失败！",dict);
                    [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
                    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];
                }
            }];
            
        } else {
            ETTLog(@"推课件失败原因:%@",error);
            [task setOperationState:ETTBACKOPERATIONSTATEFAILURE];
            [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT withEntity:self];        }
    }];
    
}

//结束推送按钮的点击
- (void)endPushBtnDidClick {
    
    ETTGovRestoreWorkTask * task = [[ETTGovRestoreWorkTask alloc]initTask:ETTDELRESTOREACACHIVE];
    [ETTAnouncement reportGovernmentTask:task withType:0 withEntity:self];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    
    /**老师点击了结束推送要干的事情
     1.更改按钮的状态
     2.把这个状态推送给学生让学生端pdf阅读器弹出返回栏
     
     */
    
    if ([ETTBackToPageManager sharedManager].isPushing == YES) {
        //1.更改按钮的状态
        [self changeButtonHiddenOrAppear];
        
        //2.把这个状态推送给学生让学生端pdf阅读器弹出返回栏
        [self pushEndPushInfoToStudent];
        
        [[ETTBackToPageManager sharedManager] endPushing];
    }
}


/**
 将结束推送信息推给学生
 */
- (void)pushEndPushInfoToStudent {
    
    /* 时间戳 精确到秒*/
    NSString *time = [ETTRedisBasisManager getTime];
    
    NSDictionary *userInfo = @{@"CO_02_state":@"CO_02_state5",
                               @"endPushCurrentPage":[NSString stringWithFormat:@"%ld",(long)self.endPushCurrentPage]
                               };
    
    NSDictionary  *dict = @{@"mid":[NSString stringWithFormat:@"%@_IOS",time],
                            @"to":@"ALL",
                            @"from":[AXPUserInformation sharedInformation].jid,
                            @"type":@"CO_02",
                            @"userInfo":userInfo
                            };
    
   
    NSString *key = [NSString stringWithFormat:@"%@%@",[AXPUserInformation sharedInformation].classroomId,kPCI_CLASSROOM_CHANNEL];
    ETTRedisBasisManager *redisManager = [ETTRedisBasisManager sharedRedisManager];
    NSString *messageJSON = [ETTRedisBasisManager getJSONWithDictionary:dict];
    
    NSString *redisKey = [NSString stringWithFormat:@"%@%@",kPCI_CLASSROOM_STATE,[AXPUserInformation sharedInformation].classroomId];
    NSDictionary *theUserInfo = @{
                                  @"type":@"CO_02",
                                  @"theUserInfo":dict
                                  };
    NSString *theUserInfoJson = [ETTJSonStringDictionaryTransformation dictionaryToJson:theUserInfo];
    ///////////////////////////////////////////////
    /*
     Epic-KXG-AIXUEPAIOS-1141
     */
    ETTGovernmentClassReportTask * task = [[ETTGovernmentClassReportTask alloc]initTask:ETTSITUATIONCLASSREPORT withClassRoom:[AXPUserInformation sharedInformation].classroomId];
    
    [task putInDataFordic:theUserInfo];
    
    [ETTAnouncement reportGovernmentTask:task withType:ETTSITUATIONCLASSREPORT];
    ///////////////////////////////////////////////
    
    [redisManager redisSet:redisKey value:theUserInfoJson respondHandler:^(id value, id error) {
        if (!error) 
        {
            //连续发三次
            [self redisManager:redisManager publicMessageWithKey:key andMessage:messageJSON];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self redisManager:redisManager publicMessageWithKey:key andMessage:messageJSON];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self redisManager:redisManager publicMessageWithKey:key andMessage:messageJSON];
            });
            
        }else 
        {
            ETTLog(@"课件结束推送错误原因:%@",error);
        }
    }];
    
}

- (void)redisManager:(ETTRedisBasisManager *)redisManager publicMessageWithKey:(NSString *)key andMessage:(NSString *)message
{
    [redisManager publishMessageToChannel:key message:message  respondHandler:^(id value, id error) {
        if (!error) {
            //NSLog(@"成功发送消息%@",dict);
        }else{
            //NSLog(@"发送消息%@失败！",dict);
        }
    }];
    
}

- (void)setBookmarkState:(BOOL)state
{
#if (READER_BOOKMARKS == TRUE) // Option
    
    if (state != markButton.tag) // Only if different state
    {
        if (self.hidden == NO) // Only if toolbar is visible
        {
            UIImage *image = (state ? markImageY : markImageN);
            
            [markButton setImage:image forState:UIControlStateNormal];
        }
        
        markButton.tag = state; // Update bookmarked state tag
    }
    
    if (markButton.enabled == NO) markButton.enabled = YES;
    
#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#if (READER_BOOKMARKS == TRUE) // Option
    
    if (markButton.tag != NSIntegerMin) // Valid tag
    {
        BOOL state = markButton.tag; // Bookmarked state
        
        UIImage *image = (state ? markImageY : markImageN);
        
        [markButton setImage:image forState:UIControlStateNormal];
    }
    
    if (markButton.enabled == NO) markButton.enabled = YES;
    
#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
    if (self.hidden == NO)
    {
        [UIView animateWithDuration:1.0 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
    }
}

- (void)showToolbar
{
    if (self.hidden == YES)
    {
        [self updateBookmarkImage]; // First
        
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
    }
}

#pragma mark - UIButton action methods

//完成按钮被点击
- (void)doneButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self doneButton:button];
}

//缩略图按钮被点击
- (void)thumbsButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self thumbsButton:button];
}

- (void)exportButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self exportButton:button];
}

- (void)printButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self printButton:button];
}

- (void)emailButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self emailButton:button];
}

- (void)markButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self markButton:button];
}

-(void)performTask:(id<ETTCommandInterface>)commond
{
    if (commond== nil)
    {
        [commond commandPeriodicallyFailure:self withState:ETTTASKOPERATIONSTATEERROR ];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RemindLockScreenAssociatedKey object:nil];
    ETTRestoreCommand * restoreCommand = (ETTRestoreCommand *)commond;
    if (restoreCommand.EDListModel.EDOperationSTate == ETTBACKOPERATIONSTATESTART)
    {
        [self changeCoursewareVisible];
        
        //2.更改按钮的可见性
        [self changeButtonHiddenOrAppear];
        
        [ETTBackToPageManager sharedManager].coursewareID = self.coursewareID;
        
        //记住当前推送课件的url
        [ETTBackToPageManager sharedManager].coursewareUrl = self.coursewareUrl;
        
        
        [ETTBackToPageManager sharedManager].isPushing = YES;
    }
    else
    {
        [commond commandPeriodicallyComplete:self];
    }

    

}
@end
