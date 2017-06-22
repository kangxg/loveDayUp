//
//  ETTDBHeader.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/4/12.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#ifndef ETTDBHeader_h
#define ETTDBHeader_h

#define  STRINGGOBJECT(string)   \
(                                \
  {                              \
    if(string == nil)            \
    {                            \
       string = @"";             \
    }                            \
  }                              \
)
#endif /* ETTDBHeader_h */
