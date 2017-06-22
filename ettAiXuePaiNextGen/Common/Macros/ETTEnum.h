//
//  ETTEnum.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/11/23.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef ETTEnum_h
#define ETTEnum_h
/**
 *  Description   数据model 处理数据状态
 */
typedef NS_ENUM(NSInteger, ETTProcessingDataState)
{
    /**
     *  Description   未处理状态
     */
    ETTPROCESSINGDATANONE = 0x00000,
    /**
     *  Description   处理错误
     */
    ETTPROCESSINGDATAERROR,
    /**
     *  Description   处理失败
     */
    ETTPROCESSINGDATAFAILT,
    /**
     *  Description   数据为空
     */
    ETTPROCESSINGDATANULL,
    /**
     *  Description   处理成功
     */
    ETTPROCESSINGDATASUCCESS,
    
};


#endif /* ETTEnum_h */
