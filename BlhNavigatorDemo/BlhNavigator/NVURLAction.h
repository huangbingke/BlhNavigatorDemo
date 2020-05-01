//
//  NVURLAction.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "NVURLPattern.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger NVNaviAnimation;
#define NVNaviAnimationNone -1 // 没有动画
#define NVNaviAnimationPush 0 // 标准的导航压入动画
// 更多压入动画可以在业务层定义

@interface NVURLAction : NSObject

/**
 需要导航到的url地址
 */
@property (nonatomic, strong, readonly) NSURL *url;

/**
 导航动画
 animation : 动画类型，默认为NVNaviAnimationPush
 */
@property (nonatomic) NVNaviAnimation animation;

/**
 所有的参数构建成query
 */
@property (nonatomic, readonly) NSString *query;

/**
 如果url为http url，则会询问是否在外部打开
 默认为NO
 */
@property (nonatomic) BOOL openExternal;

/**
 对应的NVURLPattern, online url mapping可能会修改pattern，所以需要将pattern粘贴在urlAction中
 */
@property (nonatomic, strong) NVURLPattern *urlPattern;

//////////////////////////////
+ (id)actionWithURL:(NSURL *)url;
+ (id)actionWithURLString:(NSString *)urlString;
+ (id)actionWithHost:(NSString *)host;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithHost:(NSString *)host;

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
- (void)setDouble:(double)doubleValue forKey:(NSString *)key;
- (void)setBool:(BOOL)boolValue forKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

/**
 一次性写入多个参数
 使用场景：
    拷贝另一个NVURLAction的参数值到新的NVURLAction中
 */
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
/**
 使用场景：
 从另一个NVURLAction拷贝参数
 */
- (void)addParamsFromURLAction:(NVURLAction *)otherURLAction;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

/**
 如果参数不为4中基本类型，可以使用anyObject进行传递
 不建议使用该方法
 anyObject不支持在URL中进行传递
 */
- (id)anyObjectForKey:(NSString *)key;

/**
 *  parameters for navigator
 *
 *  @return queryDict
 */
- (NSDictionary *)queryDictionary;

@end

@interface UIViewController (urlAction)

@property (nonatomic, strong) NVURLAction *urlAction;

@end

NS_ASSUME_NONNULL_END
