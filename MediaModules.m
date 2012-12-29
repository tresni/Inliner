//
//  MediaModules.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/29/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "MediaModules.h"

@implementation MediaModuleFactory

static NSMutableArray* _modules = nil;

+ (void)registerModule:(Class<MediaModule>)module {
  if (!_modules) {
    _modules = [[NSMutableArray alloc] init];
  }
    NSLog(@"Added %@", module);
  [_modules addObject:module];
}

// use C to be a little faster in the loop
+ (void) removeChildNodes:(xmlNode*)theNode {
  for (xmlNode *child = theNode->children; child != NULL; child = theNode->children) {
    xmlUnlinkNode(child);
    xmlFreeNode(child);
  }
}

+ (void) imageAtNode:(xmlNode *)parent src:(NSString *)src {
  xmlNode *child = xmlNewChild(parent, NULL, (const xmlChar*)"img", NULL);
  xmlNewProp(child, (const xmlChar*)"src", (const xmlChar*)[src UTF8String]);
  xmlNewProp(child, (const xmlChar*)"style", (const xmlChar*)"max-width: 100%; max-height: 100%");
  xmlNewProp(child, (const xmlChar*)"onLoad", (const xmlChar*)"imageSwap(this, false); alignChat(nearBottom());");
}

- (void)process:(HTMLNode *)node {
  NSLog(@"Processing node: %@", [node rawContents]);
  for (Class class in _modules) {
    NSLog(@"Checking Class %@", class);
    if ([class respondsToSelector:@selector(detect:)] && [class detect:node]) {
      NSLog(@"Match for %@", class);
      [class handleNode:node];
      NSLog(@"New node: %@", [node rawContents]);
      break;
    }
  }
}

@end