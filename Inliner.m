//
//  Inliner.m
//  Inliner
//
//  Created by Brian Hartvigsen on 12/28/12.
//  Copyright (c) 2012 Brian Hartvigsen. All rights reserved.
//

#import "Inliner.h"
#import "HTMLParser.h"
#import "MediaModules.h"

@implementation Inliner {
  MediaModuleFactory *factory;
}

- (NSString *)pluginAuthor {
	return @"Brian Hartvigsen";
}

/*
- (NSString *)pluginURL {
	return @"http://betteradiumfiles.murin.cz";
}
*/

- (NSString *)pluginVersion {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)pluginDescription {
	return @"Adium plugin that embeds images, videos, etc in chat session.";
}

- (void)installPlugin
{
  factory = [[MediaModuleFactory alloc] init];
  [[adium contentController] registerHTMLContentFilter:self direction:AIFilterIncoming];
	[[adium contentController] registerHTMLContentFilter:self direction:AIFilterOutgoing];
}

- (void)uninstallPlugin
{
  [[adium contentController] unregisterHTMLContentFilter:self];
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject*)content
{
  HTMLParser *html = [[HTMLParser alloc] initWithString:inHTMLString error:nil];
  HTMLNode *body = [html body];
  NSArray *nodes = [body findChildrenWithTag:@"a"];
  if ([nodes count] == 0) return inHTMLString;
  
  for (HTMLNode *linkNode in nodes) {
    [factory process:linkNode];
  }

  return [body innerHTML];
}

- (CGFloat)filterPriority {
  return LOWEST_FILTER_PRIORITY;
}
@end