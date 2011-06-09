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


#pragma mark - Instance Methods
-(void) setDate
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	NSDate *date = [dictionary valueForKey:templateCreationDateKey];
	if(!date)
		{
		date = [NSDate date];
		[dictionary setValue:date forKey:templateCreationDateKey];
		}
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[creationDateField setText:[dateFormatter stringFromDate:date]];

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

	[templateNameField setText:[dictionary valueForKey:templateNameKey]];
	[templateGroupField setText:[dictionary valueForKey:templateGroupKey]];
	[creatorNameField setText:[dictionary valueForKey:templateCreatorKey]];
	[self setDate];
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
	/*
	NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	NSDate * date = nil;
	*/
	/*
	switch([textField tag])
	{
		case 0: default: // error
		[textField resignFirstResponder];
		break;
		
		case 1: // template name
		break;
		case 2: // template group
		break;
		case 3: // creator name
		break;
		case 4: // creation date
		break;
	}
	*/
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
		key = @"template name";
		break;
		
		case 2: // template group
		key = @"group name";
		break;
		
		case 3: // creator name
		key = @"creator name";
		break;
		
		case 4: // creation date
		key = @"creation date";
		break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

@end
