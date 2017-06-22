//
//  AXPTextContantView.m
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/11/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "AXPTextContantView.h"
#import "AXPShowtextView.h"


@interface AXPTextContantView ()

@property(nonatomic ,strong) NSMutableArray *textFields;

@property(nonatomic ,strong) NSDictionary *selectedDict;

@end

@implementation AXPTextContantView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.frame = CGRectMake(0, 0, kWIDTH-kAXPWhiteboardManagerWidth, kHEIGHT-64);
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    return self;
}

//-(void)drawTextWithTextFields:(NSMutableArray *)textFields;
//{
//    self.textFields = textFields;
//    
//    if (self.textFields.count == 0) {
//        self.selectedDict = nil;
//    }
//    
//    [self setNeedsDisplay];
//}
//
//-(void)deleteSelectedTextWithTextDict:(NSDictionary *)textDict
//{
//    [self.textFields removeObject:self.selectedDict];
//    self.selectedDict = nil;
//    [self setNeedsDisplay];
//}
//
//-(void)selectedTextWithTextDict:(NSDictionary *)textDict
//{
//    self.selectedDict = textDict;
//    
//    [self setNeedsDisplay];
//}

//-(void)drawRect:(CGRect)rect
//{
//    [self.textFields enumerateObjectsUsingBlock:^(NSDictionary *textDict, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//           
//            NSDictionary *textAttributes = key;
//            UITextView *textView = obj;
//            
//            [textView.text drawInRect:textView.frame withAttributes:textAttributes];
//        }];
//    }];
//    
//    if (self.selectedDict) {
//        
//        [self.selectedDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            
//            NSDictionary *textAttributes = key;
//            UITextView *textView = obj;
//            
//            [textView.text drawInRect:textView.frame withAttributes:textAttributes];
//            
//            UIBezierPath *path = [UIBezierPath bezierPathWithRect:textView.frame];
//            
//            [kAXPLINECOLORl4 setStroke];
//            
//            [path stroke];
//            
//        }];
//    }
//}

@end
