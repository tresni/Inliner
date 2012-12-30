//
//  MediaYoutube.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaYoutube.h"

@implementation MediaYoutube

+ (void)load {
  [MediaModuleFactory registerModule:self];
}

+ (Boolean)detect:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  return ([[href lowercaseString] rangeOfString:@"youtube.com"].location != NSNotFound ||
          [[href lowercaseString] rangeOfString:@"youtu.be"].location != NSNotFound) &&
          [href rangeOfString:@"/embed/"].location == NSNotFound;
}

+ (void)handleNode:(HTMLNode *)node {
  NSString *href = [node getAttributeNamed:@"href"];
  NSRegularExpression *regex = nil;
  if ([href rangeOfString:@"youtube.com"].location != NSNotFound) {
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\?v=([\\w\\-]{11})&?" options:NSRegularExpressionCaseInsensitive error:nil];
  }
  else {
    //youtu.be short link
    regex = [NSRegularExpression regularExpressionWithPattern:@"youtu.be/([\\w\\-]{11})" options:NSRegularExpressionCaseInsensitive error:nil];
  }
  NSTextCheckingResult *match = [regex firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
  NSString *video = [href substringWithRange:[match rangeAtIndex:1]];
  
  /* TODO:
   * - Allow width/height to be set by options
   * - See if it can support the (?:\?|&)t=([^&]+) start time variable
   * - fix above to pull the the video code if /embed/ URL
   */
    
  xmlNode *embed = xmlNewNode(NULL, (const xmlChar*)"iframe");
  xmlNewProp(embed, (const xmlChar*)"width", (const xmlChar*)"560");
  xmlNewProp(embed, (const xmlChar*)"height", (const xmlChar*)"315");
  xmlNewProp(embed, (const xmlChar*)"frameborder", (const xmlChar*)"0");
  xmlNewProp(embed, (const xmlChar*)"allowfullscreen", (const xmlChar*)"allowfullscreen");
  xmlNewProp(embed, (const xmlChar*)"onLoad", (const xmlChar*)"alignChat(nearBottom());");
  xmlNewProp(embed, (const xmlChar*)"src", (const xmlChar*)[[NSString stringWithFormat:@"https://www.youtube.com/embed/%@?rel=0", video] UTF8String]);
  xmlReplaceNode(node->_node, embed);
}

@end
