//
//  AXPKeyboardManager.m
//  AXPBasic
//
//  Created by Li Kaining on 16/8/10.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import "AXPKeyboardManager.h"

@implementation AXPKeyboardManager

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
    
        self.keyboardIsHidden = YES;
        self.keyboardHeight = 0;
    
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
    NSDictionary *info = [notify userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.keyboardHeight = keyboardSize.height;
    self.keyboardIsHidden = NO;
}

- (void)keyboardWasHidden:(NSNotification *)notify
{
    self.keyboardIsHidden = YES;
}



@end
