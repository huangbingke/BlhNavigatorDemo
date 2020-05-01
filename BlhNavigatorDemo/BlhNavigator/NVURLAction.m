//
//  NVURLAction.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NVURLAction.h"
#import "NSURL+NavigatorExtension.h"
#import "NVNavigator.h"
#import <objc/runtime.h>


@interface NVURLAction ()

@property (nonatomic, strong) NSMutableDictionary *params; // setParams:forKey:

@end

@implementation NVURLAction

+ (id)actionWithURL:(NSURL *)url {
    return [[NVURLAction alloc] initWithURL:url];
}

+ (id)actionWithURLString:(NSString *)urlString {
    return [[self alloc] initWithURLString:urlString];
}

+ (id)actionWithHost:(NSString *)host {
    return [[self alloc] initWithHost:host];
}

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        
        // my fix
        NSString *scheme = [url.scheme lowercaseString];
        if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [url.absoluteString hasPrefix:@"http"] || [url.absoluteString hasPrefix:@"https"]) {
            
            NSString *webUrl = [NSString stringWithFormat:@"%@://%@?url=%@", [NVNavigator navigator].handleableURLScheme, @"browser", url.absoluteString];
            url = [NSURL URLWithString:webUrl];
            _url = url;
        }
        
        ////////////
        NSDictionary *dic = [url parseQuery];
        _params = [NSMutableDictionary dictionary];
        for (NSString *key in [dic allKeys]) {
            id value = [dic objectForKey:key];
            [_params setObject:value forKey:[key lowercaseString]];
        }
    }
    return self;
}

- (id)initWithURLString:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithHost:(NSString *)host {
    NSString *scheme = [[NVNavigator navigator] handleableURLScheme];
    if (scheme.length < 1) {
        return nil;
    }
    return [self initWithURLString:[NSString stringWithFormat:@"%@://%@", scheme, host]];
}

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key {
    [_params setObject:[NSNumber numberWithInteger:intValue] forKey:[key lowercaseString]];
}

- (void)setDouble:(double)doubleValue forKey:(NSString *)key {
    [_params setObject:[NSNumber numberWithDouble:doubleValue] forKey:[key lowercaseString]];
}

- (void)setBool:(BOOL)boolValue forKey:(NSString *)key {
    [_params setObject:[NSNumber numberWithBool:boolValue] forKey:[key lowercaseString]];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (object) {
        [_params setObject:object forKey:[key lowercaseString]];
    }
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    if (string.length > 0) {
        [_params setObject:string forKey:[key lowercaseString]];
    }
}


- (NSInteger)integerForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr integerValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr doubleValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr doubleValue];
        }
    }
    return .0;
}

- (BOOL)boolForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr boolValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr boolValue];
        }
    }
    return NO;
}

- (id)objectForKey:(NSString *)key {
    return [_params objectForKey:[key lowercaseString]];
}

- (id)anyObjectForKey:(NSString *)key {
    return [_params objectForKey:[key lowercaseString]];
}

- (NSString *)description {
    if([_params count]) {
        NSMutableArray *paramsDesc = [NSMutableArray arrayWithCapacity:_params.count];
        for(NSString *key in [_params keyEnumerator]) {
            id value = [_params objectForKey:[key lowercaseString]];
            if ([value isKindOfClass:[NSString class]]) {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            } else {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], value]];
            }
        }
        NSString *urlString = [_url absoluteString];
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *pureURLStirng = [urlString substringToIndex:range.location];
            return [pureURLStirng stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        } else {
            return [urlString stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        }
    } else {
        return [_url absoluteString];
    }
}

- (NSDictionary *)queryDictionary {
    return _params;
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (!otherDictionary) {
        return;
    }
    [_params addEntriesFromDictionary:otherDictionary];
}

- (void)addParamsFromURLAction:(NVURLAction *)otherURLAction {
    NSDictionary *dic = [otherURLAction queryDictionary];
    [self addEntriesFromDictionary:dic];
}

@end



@implementation UIViewController (urlAction)

- (void)setUrlAction:(NVURLAction *)urlAction {
    objc_setAssociatedObject(self, @"UIViewControllerNVURLAction", urlAction, OBJC_ASSOCIATION_RETAIN);
}

- (NVURLAction *)urlAction {
    return objc_getAssociatedObject(self, @"UIViewControllerNVURLAction");
}

@end
