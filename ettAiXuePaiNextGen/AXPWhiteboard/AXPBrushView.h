//
//  AXPBrushView.h
//  ettAiXuePaiNextGen
//
//  Created by Li Kaining on 16/10/19.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXPBrushView : UIView

@property(nonatomic ,strong) NSMutableArray *paths;

-(void)clearAllBezierPaths;

@end
