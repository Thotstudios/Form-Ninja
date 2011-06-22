//
//  FormElementPicker.m
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "FormElementPicker.h"
#import "ElementPicker.h"
#import "FormTemplateElement.h"

@implementation FormElementPicker

static NSMutableDictionary * elementDictionary = nil;

+(void) loadElementDictionary
{
	if(elementDictionary) return;
	
	NSString * path;
	path = [[NSBundle mainBundle] pathForResource:@"ElementList" ofType:@"plist"];
	
	elementDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}


+(FormTemplateElement*) formElementOfType:(NSString *)type delegate:(id)delegate
{
	[FormElementPicker loadElementDictionary];
	
	FormTemplateElement * element = nil;
	
	
	element = [[[NSClassFromString([NSString stringWithFormat:@"Form%@", [elementDictionary valueForKey:type]]) alloc] init] autorelease];
	
	if(!element)
		element = [[[FormTemplateElement alloc] init] autorelease];
	
	if(element)
		{
		[element setDelegate:delegate];
		[element setDictionary:[NSMutableDictionary dictionaryWithObject:type forKey:elementTypeKey]];
		}
	return element;
}


@end
