//
//  MediaLivememe.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaLivememe.h"

@implementation MediaLivememe
static NSRegularExpression *regex = nil;

+ (void)load {
  [MediaModuleFactory registerModule:self];
  regex = [NSRegularExpression regularExpressionWithPattern:@"^http://(?:www.livememe.com|lvme.me)/(?!edit)([\\w]+)/?" options:NSRegularExpressionCaseInsensitive error:nil];
}

+ (Boolean)detect:(HTMLNode *)node {
  return [regex numberOfMatchesInString:[node getAttributeNamed:@"href"] options:0 range:NSMakeRange(0, [[node getAttributeNamed:@"href"] length])];
}

+ (void)handleNode:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  NSTextCheckingResult* match = [regex firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
  NSString* image = [NSString stringWithFormat:@"http://www.livememe.com/%@.jpg", [href substringWithRange:[match rangeAtIndex:1]]];
  [MediaModuleFactory removeChildNodes:node->_node];
  [MediaModuleFactory imageAtNode:node->_node src:image];
}
@end
