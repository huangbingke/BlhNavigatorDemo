//
//  NSURL+NavigatorExtension.m
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import "NSURL+NavigatorExtension.h"
#import "NSString+NavigatorExtension.h"

@implementation NSURL (NavigatorExtension)

- (NSDictionary *)parseQuery {
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            continue;
        }
        
        // my fix
        if (elements.count > 2) {
            NSString *preStr = [elements objectAtIndex:1];
            for (int i = 2; i < elements.count; i++) {
                preStr = [NSString stringWithFormat:@"%@=%@", preStr, [elements objectAtIndex:i]];
            }
            
            NSString *key = [[elements objectAtIndex:0] deEncodeStringByReplacingPercentEscapes];
            NSString *val = [preStr deEncodeStringByReplacingPercentEscapes];
            
            [dict setObject:emptyString(val) forKey:emptyString(key)];
            
        } else {
            
            NSString *key = [[elements objectAtIndex:0] deEncodeStringByReplacingPercentEscapes];
            NSString *val = [[elements objectAtIndex:1] deEncodeStringByReplacingPercentEscapes];
            
            [dict setObject:emptyString(val) forKey:emptyString(key)];
        }
       
    }
    return dict;
}

@end
