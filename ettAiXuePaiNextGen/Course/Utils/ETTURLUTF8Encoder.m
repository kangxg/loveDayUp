//
//  ETTURLUTF8Encoder.m
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/11/9.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTURLUTF8Encoder.h"

@implementation ETTURLUTF8Encoder

+ (NSURL *)urlUTF8EncoderWithString:(NSString *)string {
    
    NSString *urlString= [NSString stringWithFormat:@"%@",string];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    NSURL *url =[NSURL URLWithString:encodedString];
    
    return url;
}

@end
