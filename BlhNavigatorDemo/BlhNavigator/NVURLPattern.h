//
//  NVURLPattern.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NVURLPatternTypeClass = 0,   // host对应创建Class
    NVURLPatternTypeHttp = 1,    // host对应创建webviewController
    NVURLPatternTypeHtmlZip = 2, // host对应离线下载html zip包
    NVURLPatternTypeHost = 3,    // host对应替换Host
} NVURLPatternType;

@interface NVURLPattern : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, readonly) NVURLPatternType type;
@property (nonatomic, strong, readonly) NSString *patternString;
@property (nonatomic, readonly) Class targetClass;
@property (nonatomic) int version;

+ (void)setDefaultWebViewControllerClass:(Class)webControllerClass;

+ (NVURLPattern *)patternWithClassName:(NSString *)className withKey:(NSString *)key;
+ (NVURLPattern *)patternWithHttp:(NSString *)url withKey:(NSString *)key;
+ (NVURLPattern *)patternWithHtmlZip:(NSString *)urlZip withKey:(NSString *)key;
+ (NVURLPattern *)patternWithHost:(NSString *)host withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
