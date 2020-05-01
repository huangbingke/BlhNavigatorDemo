//
//  NSURL+NavigatorExtension.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (NavigatorExtension)

/**
 将query解析为NSDictionary
 
 @return 返回参数字典对象，参数的值已经进行了decode.
 (stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding)
 */
- (NSDictionary *)parseQuery;

@end

NS_ASSUME_NONNULL_END
