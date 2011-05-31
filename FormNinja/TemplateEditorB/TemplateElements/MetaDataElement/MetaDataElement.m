//
//  MetaDataElement.m
//  Dev
//
//  Created by Hackenslacker on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MetaDataElement.h"


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


#pragma mark - Methods
-(void) beginEditing
{
	[templateNameField becomeFirstResponder];
}
-(void) setDate
{
	/*
	NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	NSDate * date = [NSDate date];
	[creationDateField setText:[NSString stringWithFormat:@"%@", date]];
	 */
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	NSDate *date = [dictionary valueForKey:@"creation date"];
	if(!date)
		{
		date = [NSDate date];
		[dictionary setValue:date forKey:@"creation date"];
		}
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[creationDateField setText:[dateFormatter stringFromDate:date]];

}

- (IBAction)reset
{
	[super reset];
	[dictionary setValue:@"MetaData" forKey:@"type"];
	[templateNameField setText:nil];
	[templateGroupField setText:nil];
	[creatorNameField setText:@"Robert Paulson"];
	[creationDateField setText:[NSString stringWithFormat:@"%@", [NSDate date]]];
	[self setDate];
	[publishedSwitch setOn:NO];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[self reset];
	[super setDictionary:arg];
	[templateNameField setText:[dictionary valueForKey:@"template name"]];
	[templateGroupField setText:[dictionary valueForKey:@"group name"]];
	[creatorNameField setText:[dictionary valueForKey:@"creator name"]];
	[self setDate];
	//[creationDateField setText:[dictionary valueForKey:@"creation date"]];
	[publishedSwitch setOn:[[dictionary valueForKey:@"published"] boolValue]];
}

#pragma mark - Interface Methods

-(BOOL) templateIsValid { return NO; }
-(IBAction) togglePublished:(UISwitch *)sender
{
	if(![publishedSwitch isOn] || [delegate templateIsValid])
		{
		[dictionary setValue:[NSNumber numberWithBool:[publishedSwitch isOn]] forKey:@"published"];
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
