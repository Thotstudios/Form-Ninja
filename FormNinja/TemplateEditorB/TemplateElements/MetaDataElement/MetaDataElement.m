//
//  MetaDataElement.m
//  Dev
//
//  Created by Hackenslacker on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MetaDataElement.h"
#import "Constants.h"

@implementation MetaDataElement
@synthesize templateNameField;
@synthesize templateGroupField;
@synthesize creatorNameField;
@synthesize creationDateField;
@synthesize publishedSwitch;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setTemplateNameField:nil];
    [self setTemplateGroupField:nil];
    [self setCreatorNameField:nil];
    [self setCreationDateField:nil];
    [self setPublishedSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [templateNameField release];
    [templateGroupField release];
    [creatorNameField release];
    [creationDateField release];
    [publishedSwitch release];
    [super dealloc];
}

#pragma mark - Inherited Methods
-(void) beginEditing
{
	[templateNameField becomeFirstResponder];
}
- (IBAction)reset
{
	[publishedSwitch setOn:NO];
	NSMutableDictionary * dict = [[[self dictionary] retain] autorelease];
	[super reset];
	[self setDictionary:dict];
	[dictionary setValue:@"MetaData" forKey:elementTypeKey];
}
-(void)	setDictionary:(NSMutableDictionary *)dict
{
	//[self reset];
	[super setDictionary:dict];
	
	if(![dictionary valueForKey:templateCreationDateKey])
		{
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
		NSString * dateString = [dateFormatter stringFromDate:[NSDate date]];
		[dictionary setValue:dateString forKey:templateCreationDateKey];
		}
	
	[templateNameField setText:[dictionary valueForKey:templateNameKey]];
	[templateGroupField setText:[dictionary valueForKey:templateGroupKey]];
	[creatorNameField setText:[dictionary valueForKey:templateCreatorKey]];
	[creationDateField setText:[dictionary valueForKey:templateCreationDateKey]];
	[publishedSwitch setOn:[[dictionary valueForKey:templatePublishedKey] boolValue]];
}

-(BOOL) isValid
{
	BOOL ret = [super isValid];
	
	return ret;
}
#pragma mark - Interface Methods

-(BOOL) templateIsValid { return NO; }
-(IBAction) togglePublished
{
	if(![publishedSwitch isOn] || [delegate templateIsValid])
		{
		[dictionary setValue:[NSNumber numberWithBool:[publishedSwitch isOn]] forKey:templatePublishedKey];
		}
	else
		{
		[publishedSwitch setOn:NO];
		}
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self editNextElement];
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1: // template name
		key = templateNameKey;
		break;
		
		case 2: // template group
		key = templateGroupKey;
		break;
		
		case 3: // creator name
		key = templateCreatorKey;
		break;
		
		case 4: // creation date
		key = templateCreationDateKey;
		break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

@end
