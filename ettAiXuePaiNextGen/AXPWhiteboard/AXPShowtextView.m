//
//  AXPShowtextView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/18.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPShowtextView.h"

@interface AXPShowtextView ()

@property(nonatomic ,strong) NSDictionary *textAttributes;

@property(nonatomic , copy) NSString *text;

@end


@implementation AXPShowtextView

-(instancetype)initWithTextDict:(NSDictionary *)dict
{
    self = [super init];
    
    self.backgroundColor = [UIColor clearColor];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        UITextView *textView = obj;
        self.textAttributes = key;
        self.text = textView.text;
        self.frame = textView.frame;
    }];
    
    [self setNeedsDisplay];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self.text drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withAttributes:self.textAttributes];
}



@end
