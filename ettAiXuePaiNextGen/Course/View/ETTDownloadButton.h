//
//  ETTDownloadButton.h
//  ettAiXuePaiNextGen
//
//  Created by Liu Chuanan on 16/10/12.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTButton.h"
#import "ETTDownloadModel.h"

@interface ETTDownloadButton : ETTButton


@property (strong, nonatomic) ETTDownloadModel *downloadModel;

@property (strong, nonatomic) NSIndexPath      *indexPath;


@end
