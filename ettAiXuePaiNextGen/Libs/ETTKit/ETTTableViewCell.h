//
//  ETTTableViewCell.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/17.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTViewDelegate.h"
@class ETTBaseModel;
@interface ETTTableViewCell : UITableViewCell
@property (nonatomic,weak)id<ETTViewDelegate>  EVDelegate;
-(void)updateCellViews:(ETTBaseModel *)model;
@end
