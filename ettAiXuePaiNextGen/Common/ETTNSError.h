//
//  ETTNSError.h
//  ettNextGen
//
//  Created by Bin Lee on 7/12/15.
//  Copyright (c) 2015 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETTNSError : NSError

@property(nonatomic, readonly) NSInteger errorType;
@property(nonatomic, strong) NSError *err;
/**
 *  <#Description#>
 *
 *  @param err <#err description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithNSError:(NSError *)err;
@end
