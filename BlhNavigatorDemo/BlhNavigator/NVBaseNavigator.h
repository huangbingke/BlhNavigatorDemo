//
//  NVBaseNavigator.h
//  BlhNavigatorCore
//
//  Created by ubestkid on 2020/4/16.
//  Copyright © 2020 ubestkid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVCoreNavigationController.h"
#import "NVURLAction.h"
#import "NVURLPattern.h"
#import "NVNavigatorViewControllerProtocal.h"


NS_ASSUME_NONNULL_BEGIN

@interface NVBaseNavigator : NSObject
{
    NVCoreNavigationController *_mainNavigationController;
    NSString *_handleableURLScheme;
    NSArray *_fileNamesOfURLMapping;
    
    // url actions waiting for handle
    NSMutableArray *_urlActionWaitingList;
    
    NSMutableDictionary *_urlMapping; // host与NVURLPattern的映射关系，host为key，NVURLPattern为value
}

/**
 所有的页面跳转都会在mainNavigationContorller中进行
 */
@property (nonatomic, readonly) NVCoreNavigationController *mainNavigationController;
@property (nonatomic, readonly) NSString *handleableURLScheme;
@property (nonatomic, readonly) NSArray *fileNamesOfURLMapping;
@property (nonatomic, readonly) BOOL animating;

- (Class)matchClassWithURLAction:(NVURLAction *)urlAction;
- (NSMutableDictionary *)loadPattern;
- (NVURLPattern *)matchPatternWithURLAction:(NVURLAction *)urlAction; // 手动添加

@end

NS_ASSUME_NONNULL_END
