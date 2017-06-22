//
//  iToast.h
//  economicInfo
//
//  Created by 徐记军 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum tagToastGravity 
{
    iToastGravityTopNone,
	iToastGravityTop = 1000001,
	iToastGravityBottom,
	iToastGravityCenter
}iToastGravity;

typedef enum tagToastDuration 
{
	iToastDurationLong = 10000,
	iToastDurationShort = 1500,
	iToastDurationNormal = 3000
}iToastDuration;

typedef enum tagToastType
{
	iToastTypeInfo = -100000,
	iToastTypeNotice,
	iToastTypeWarning,
	iToastTypeError
}iToastType;


@class iToastSettings;

/** 这个View是一个非模态的
 */

@interface iToast : NSObject
{
	iToastSettings *_settings;
	NSInteger offsetLeft;
	NSInteger offsetTop;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
}

// 显示Toast视图
- (void)show;
//- (void)showInWindow:(CGPoint)apPoint andShowInViewController:(UIViewController *)apCtr;
- (void)showInWindowOfCenter;
- (void)showInWindowOfTop;
- (void)showInWindowOfBottom;
- (void)showInWindowOfCustom:(CGPoint)apPoint;
// 设置停留的时间，单位（毫秒）
- (iToast *) setDuration:(NSInteger ) duration;
- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
              offsetTop:(NSInteger) top;
- (iToast *) setGravity:(iToastGravity) gravity;
- (iToast *) setPostion:(CGPoint) position;

+ (iToast *) makeText:(NSString *) text;
+ (iToast *) makeText:(NSString *) text withTime:(float)time;
-(iToastSettings *) theSettings;

@end

@interface iToastSettings : NSObject<NSCopying>
{
	NSInteger duration;
	iToastGravity gravity;
	CGPoint postition;
	iToastType toastType;
	
	NSDictionary *images;
	
	BOOL positionIsSet;
}
@property(assign) NSInteger duration;
@property(assign) iToastGravity gravity;
@property(assign) CGPoint postition;
@property(readonly) NSDictionary *images;

- (void) setImage:(UIImage *)img forType:(iToastType) type;
+ (iToastSettings *) getSharedSettings;

@end