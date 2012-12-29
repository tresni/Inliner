//
//  MediaModules.h
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@protocol MediaModule <NSObject>
+ (void) load;
+ (Boolean) detect:(HTMLNode*)node;
+ (void) handleNode:(HTMLNode*)node;
@end

@interface MediaModuleFactory : NSObject
- (void) process:(HTMLNode*)node;
+ (void) registerModule:(Class<MediaModule>)module;
+ (void) removeChildNodes:(xmlNode*)theNode;
+ (void) imageAtNode:(xmlNode*)parent src:(NSString*) src;
@end
