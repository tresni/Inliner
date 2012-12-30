//
//  MediaEhost.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaEhost.h"

@implementation MediaEhost

static NSRegularExpression *regex;

+ (void)load {
  regex = [NSRegularExpression regularExpressionWithPattern:@"^http://(?:i\\.)?(?:\\d+\\.)?eho.st/(\\w+)/?" options:NSRegularExpressionCaseInsensitive error:nil];

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
  
  [MediaModuleFactory removeChildNodes:node->_node];
  
  xmlNode *child = xmlNewChild(node->_node, NULL, (const xmlChar*)"img", NULL);
  xmlNewProp(child, (const xmlChar*)"src", (const xmlChar*)[[NSString stringWithFormat:@"http://i.eho.st/%@.jpg", group] UTF8String]);
  xmlNewProp(child, (const xmlChar*)"style", (const xmlChar*)"max-width: 100%; max-height: 100%");
  xmlNewProp(child, (const xmlChar*)"onLoad", (const xmlChar*)"imageSwap(this, false); alignChat(nearBottom());");
  
  /* eHo.st allows uploads of 3 image types (png, gif, jpg) and only allows
   * access for the specific file extension of the uploaded image.  This allows
   * us to cycle through the available formats until we get the right one.
   */
  xmlNewProp(child, (const xmlChar*)"onError", (const xmlChar*)[[NSString stringWithFormat:@"if (this.src.match(/\\.jpg/)) { this.src = 'http://i.eho.st/%@.png'; return true; } else { this.onerror = ''; this.src = 'http://i.eho.st/%@.gif'; return true; }", group, group] UTF8String]);
}

@end
