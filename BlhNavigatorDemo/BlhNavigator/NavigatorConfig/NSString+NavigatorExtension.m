//
//  NSString+NavigatorExtension.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NSString+NavigatorExtension.h"

@implementation NSString (NavigatorExtension)

NSString *emptyString (NSString *anMaybeEmptyString) {
    if ([anMaybeEmptyString isKindOfClass:[NSNumber class]]) {
        anMaybeEmptyString = [NSString stringWithFormat:@"%@", anMaybeEmptyString];
    }
    if (!anMaybeEmptyString || [anMaybeEmptyString isKindOfClass:[NSNull class]] || anMaybeEmptyString.length == 0) {
        return @"";
    } else {
        return anMaybeEmptyString;
    }
}

NSString *emptySpaceString (NSString *anMaybeSpaceString) {
    if ([anMaybeSpaceString isKindOfClass:[NSNumber class]]) {
        anMaybeSpaceString = [NSString stringWithFormat:@"%@", anMaybeSpaceString];
    }
    if (!anMaybeSpaceString || [anMaybeSpaceString isKindOfClass:[NSNull class]] || anMaybeSpaceString.length == 0) {
        return @"";
    }
    else {
        return [anMaybeSpaceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}

- (NSString *)encodeStringByAddingPercentEscapes {
    /*
    NSString *url = self;
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "; // 包含这些字符就转码 默认包括中文
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
    */
    
    // 上面的转码特殊字符较多
    NSString *url = self;
     //包含这些字符就转码 默认包括中文和空格 "#%<>[\]^`{|}
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedUrl;

    
}
- (NSString *)deEncodeStringByReplacingPercentEscapes {
    
    return [self stringByRemovingPercentEncoding];
}

@end
