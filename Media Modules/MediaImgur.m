//
//  MediaImgur.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaImgur.h"

@implementation MediaImgur

NSRegularExpression *regex = nil;

+ (void)load {
  regex = [NSRegularExpression regularExpressionWithPattern:@"^https?://(?:[i.]|[edge.]|[www.])*imgur.com/(?:r/[\\w]+/)?([\\w]{5,}(?:[&,][\\w]{5,})?)(\\.[\\w]{3,4})?(?:#(\\d*))?(?:\\?(?:\\d*))?$" options:NSRegularExpressionCaseInsensitive error:nil];
  [MediaModuleFactory registerModule:self];
}

+ (Boolean)detect:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  return [regex numberOfMatchesInString:href options:0 range:NSMakeRange(0, [href length])];
}

+ (void)handleNode:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  NSTextCheckingResult *match = [regex firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
  NSString *group = [href substringWithRange:[match rangeAtIndex:1]];
  if ([group rangeOfString:@"&"].location == NSNotFound && [group rangeOfString:@","].location == NSNotFound) {
    [MediaModuleFactory removeChildNodes:node->_node];
    [MediaModuleFactory imageAtNode:node->_node src:[NSString stringWithFormat:@"http://i.imgur.com/%@.jpg", group]];
  }
}

@end
