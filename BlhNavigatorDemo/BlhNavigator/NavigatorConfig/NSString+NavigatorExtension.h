//
//  NSString+NavigatorExtension.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NavigatorExtension)

NSString *emptyString (NSString *anMaybeEmptyString);
NSString *emptySpaceString (NSString *anMaybeSpaceString);

/**
 url 编码
 */
- (NSString *)encodeStringByAddingPercentEscapes; // 带blhqimeng:// 如果有中文 统一由服务端转码，不然此方法会把 :// 也编码
/**
 url 反编码
 */
- (NSString *)deEncodeStringByReplacingPercentEscapes;

@end

NS_ASSUME_NONNULL_END
