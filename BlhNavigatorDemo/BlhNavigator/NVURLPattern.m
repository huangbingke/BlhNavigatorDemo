//
//  NVURLPattern.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVURLPattern.h"

static Class defaultWebViewControllerClass = NULL;

@implementation NVURLPattern {
    NSString *_patternString;
}

+ (void)setDefaultWebViewControllerClass:(Class)webControllerClass {
    defaultWebViewControllerClass = webControllerClass;
}

+ (NVURLPattern *)patternWithClassName:(NSString *)className withKey:(NSString *)key {
    return [[self alloc] initWithString:className type:NVURLPatternTypeClass withKey:key];
}

+ (NVURLPattern *)patternWithHost:(NSString *)host withKey:(NSString *)key {
    return [[self alloc] initWithString:host type:NVURLPatternTypeHost withKey:key];
}

+ (NVURLPattern *)patternWithHttp:(NSString *)url withKey:(NSString *)key {
    return [[self alloc] initWithString:url type:NVURLPatternTypeHttp withKey:key];
}

+ (NVURLPattern *)patternWithHtmlZip:(NSString *)urlZip withKey:(NSString *)key {
    return [[self alloc] initWithString:urlZip type:NVURLPatternTypeHtmlZip withKey:key];
}

- (id)initWithString:(NSString *)string type:(NVURLPatternType)type withKey:(NSString *)key {
    self = [super init];
    if (self) {
        if (string.length<1 || key.length<1) {
            return nil;
        }
        _type = type;
        _key = key;
        _patternString = string;
    }
    return self;
}

- (Class)targetClass {
    
    if (_type == NVURLPatternTypeHttp || _type == NVURLPatternTypeHtmlZip) {
        if (DEBUG) {
            if (defaultWebViewControllerClass == NULL) {
                NSLog(@"default WebViewController Class is not assigned, please call [NVURLPattern setDefaultWebViewControllerClass:] method first!!");
                return NULL;
            }
        }
        return defaultWebViewControllerClass;
    }
    
    if (_patternString.length < 1) {
        return NULL;
    }
    
    if (_type == NVURLPatternTypeClass) {
        return NSClassFromString(_patternString);
    } else {
        return NULL;
    }
}

@end
