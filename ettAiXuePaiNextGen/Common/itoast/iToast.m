//
//  iToast.m
//  economicInfo
//
//  Created by 徐记军 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"


static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast

- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

-(id)initWithText:(NSString *) tex  withTime:(float)time
{
    if (self = [self initWithText:tex])
    {
        [self getitostSettings].duration = time*1000;
    }

    return self;
}
CGSize DrawAdaptInIos7(NSString *apText, UIFont *apFont,CGSize acSize)
{
    CGSize size;
  
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:apFont,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
        
    
        
        size = [apText boundingRectWithSize:acSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dictionary
                                    context:nil].size;
 
    return size;
}



-(void)showInWindowOfCenter
{
   
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIView * lastview = [window viewWithTag:8080];
    if (lastview)
    {
        [lastview removeFromSuperview];
        lastview = nil;
    }

    CGFloat lfOrigionX=window.frame.size.width/2;
    CGPoint point= CGPointMake(lfOrigionX, window.frame.size.height/2);// =
    
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    view = [self createView];
	view.center = point;
    view.tag = 8080;
    [window addSubview:view ];
	
    [self createTimer];
	
	
}

-(void)showInWindowOfTop
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    
    CGFloat lfOrigionX=window.frame.size.width/2;
    CGPoint point= CGPointMake(lfOrigionX, window.frame.size.height/2);
    point = CGPointMake(lfOrigionX, 45);
    view = [self createView];
    view.center = point;
    
    [window addSubview:view];
    
    [self createTimer];

    
}

-(void)showInWindowOfBottom
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    
    CGFloat lfOrigionX=window.frame.size.width/2;
    CGPoint point= CGPointMake(lfOrigionX, window.frame.size.height-45);
    point = CGPointMake(lfOrigionX, 45);
    view = [self createView];
    view.center = point;
    
    [window addSubview:view];
    
    [self createTimer];
}

-(void)showInWindowOfCustom:(CGPoint)apPoint
{
    UIWindow *window  = [[UIApplication sharedApplication]keyWindow];
    view = [self createView];
    view.center = apPoint;
    
    [window addSubview:view];
    
    [self createTimer];
}



- (void)show
{
    
    [self showInWindowOfCenter];
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer2 = [NSTimer timerWithTimeInterval:1000
                                              target:self selector:@selector(hideToast:) 
                                            userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

-(iToastSettings *)getitostSettings
{
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
    }
    return theSettings;
}

-(void)createTimer
{
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)[self getitostSettings].duration)/1000*3
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
}

-(UIView *)createView
{
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize = DrawAdaptInIos7(text, font, CGSizeMake(280, 60));
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(1, 1);
    
    UIButton *lpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lpBtn.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
    label.center = CGPointMake(lpBtn.frame.size.width / 2, lpBtn.frame.size.height / 2);
    [lpBtn addSubview:label];
    
    lpBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    lpBtn.layer.cornerRadius = 5;
    
    [lpBtn addTarget:self action:@selector(hideToast:)
    forControlEvents:UIControlEventTouchDown];
    
    return lpBtn;

}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[iToast alloc] initWithText:_text];
	return toast;
}
+ (iToast *) makeText:(NSString *) _text withTime:(float)time
{
    iToast *toast = [[iToast alloc] initWithText:_text withTime:time];
    return toast;

}
- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}

+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
	}
	return sharedSettings;
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key]
               forType:[key intValue]];
	}
	return copy;
}

@end
