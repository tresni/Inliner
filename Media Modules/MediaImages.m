//
//  MediaImages.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaImages.h"

@implementation MediaImages
+ (void)load {
  [MediaModuleFactory registerModule:self];
}

+ (Boolean)detect:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  return [[NSRegularExpression regularExpressionWithPattern:@"\\.(png|jpe?g|tif?f|gif|bmp)(?:[?&#_].*|$)" options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:href options:0 range:NSMakeRange(0, [href length])];
}

+ (void)handleNode:(HTMLNode *)node {
  [MediaModuleFactory removeChildNodes:node->_node];
  [MediaModuleFactory imageAtNode:node->_node src:[node getAttributeNamed:@"href"]];
}

@end
