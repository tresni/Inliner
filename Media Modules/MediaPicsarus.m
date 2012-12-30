//
//  MediaPicsarus.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaPicsarus.h"

@implementation MediaPicsarus
static NSRegularExpression *regex = nil;

+ (void)load {
  regex = [NSRegularExpression regularExpressionWithPattern:@"^https?://(?:[i.]|[edge.]|[www.])*picsarus.com/(?:r/[\\w]+/)?([\\w]{6,})(\\..+)?$" options:NSRegularExpressionCaseInsensitive error:nil];
  [MediaModuleFactory registerModule:self];
}

+ (Boolean)detect:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  return [regex numberOfMatchesInString:href options:0 range:NSMakeRange(0, [href length])];
}

+ (void)handleNode:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  NSTextCheckingResult *match = [regex firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
  NSString *source = [NSString stringWithFormat:@"http://www.picsarus.com/%@.jpg", [href substringWithRange:[match rangeAtIndex:1]]];
  
  [MediaModuleFactory removeChildNodes:node->_node];
  [MediaModuleFactory imageAtNode:node->_node src:source];
}

@end
