//
//  ETTLCAButton.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 16/12/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTLCAButton.h"

@implementation ETTLCAButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}



@end
