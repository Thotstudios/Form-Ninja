//
//  FormElementPicker.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormElementPicker.h"
#import "ElementPicker.h"
#import "FormTemplateElement.h"

@implementation FormElementPicker

static NSMutableDictionary * elementDictionary = nil;
static BOOL dictionaryIsLoaded = NO;

+(void) loadElementDictionary
{
	NSString * path;
	path = [[NSBundle mainBundle] pathForResource:@"ElementList" ofType:@"plist"];
	
	elementDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	dictionaryIsLoaded = YES;
}


+(FormTemplateElement*) elementOfType:(NSString *)type
{
	if(!dictionaryIsLoaded) [self loadElementDictionary];
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	FormTemplateElement * element = nil;
	
	
	element = [[[NSClassFromString([NSString stringWithFormat:@"Form%@", [elementDictionary valueForKey:type]]) alloc] init] autorelease];
	
	if(!element)
		element = [[[FormTemplateElement alloc] init] autorelease];
	
	if(element)
    {
		[element.view setFrame:CGRectMake(0, 0, 768, element.view.frame.size.height)];
		[dict setValue:type forKey:@"type"];
		[element setDictionary:dict];
    }
	return element;
}


@end
