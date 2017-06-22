//
//  AXPPolygonView.h
//  AXPBasic
//
//  Created by Li Kaining on 16/9/6.
//  Copyright © 2016年 DeveloperLx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPPolygonImageModel.h"

@interface AXPPolygonView : UIView

@property(nonatomic ,strong) AXPPolygonImageModel *polygonModel;

-(instancetype)initWithModel:(AXPPolygonImageModel *)model;


@end
