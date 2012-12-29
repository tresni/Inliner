//
//  MediaLivememe.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaLivememe.h"

@implementation MediaLivememe
static NSRegularExpression *pattern = nil;

+ (void)load {
  [MediaModuleFactory registerModule:self];
  pattern = [NSRegularExpression regularExpressionWithPattern:@"^http://(?:www.livememe.com|lvme.me)/(?!edit)([\\w]+)/?" options:NSRegularExpressionCaseInsensitive error:nil];
}

+ (Boolean)detect:(HTMLNode *)node {
  return [pattern numberOfMatchesInString:[node getAttributeNamed:@"href"] options:0 range:NSMakeRange(0, [[node getAttributeNamed:@"href"] length])];
}

+ (HTMLNode *)handleNode:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  NSTextCheckingResult* match = [pattern firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
  NSString* image = [NSString stringWithFormat:@"http://www.livememe.com/%@.jpg", [href substringWithRange:[match rangeAtIndex:1]]];
  [MediaModuleFactory removeChildNodes:node->_node];
  [MediaModuleFactory imageAtNode:node->_node src:image];
  return node;
}
@end
