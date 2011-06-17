//
//  MultiLineElement.m
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiLineElement.h"


@implementation MultiLineElement

@synthesize valueField;
@synthesize minimumLengthField;
@synthesize maximumLengthField;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setValueField:nil];
    [self setMinimumLengthField:nil];
    [self setMaximumLengthField:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [valueField release];
    [minimumLengthField release];
    [maximumLengthField release];
    [super dealloc];
}

#pragma mark - Methods

-(IBAction) reset
{
	[super reset];
	[dictionary setValue:@"Multi-Line" forKey:elementTypeKey];
	[valueField setText:nil];
	[minimumLengthField setText:nil];
	[maximumLengthField setText:nil];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[valueField setText:[dictionary valueForKey:elementValueKey]];
	[minimumLengthField setText:[dictionary valueForKey:elementMinLengthKey]];
	[maximumLengthField setText:[dictionary valueForKey:elementMaxLengthKey]];
}
#pragma mark - Delegate Methods:
#pragma mark -Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * number = nil;
	
	switch([textField tag])
	{
		case 0: default: // error
		break;
		
		case 1: // label
		[minimumLengthField becomeFirstResponder];
		break;
		
		case 2: // min
		number = [formatter numberFromString:[minimumLengthField text]];
		if(!number)
			return NO;
		[minimumLengthField setText:[NSString stringWithFormat:@"%@", number]];
		[maximumLengthField becomeFirstResponder];
		break;
		
		case 3: // max
		number = [formatter numberFromString:[maximumLengthField text]];
		if(!number)
			return NO;
		[maximumLengthField setText:[NSString stringWithFormat:@"%@", number]];
		[self editNextElement];
		break;
	}
	
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1:
		key = elementLabelKey;
		break;
		
		case 2:
		key = elementMinLengthKey;
		break;
		
		case 3:
		key = elementMaxLengthKey;
		break;
	}
	
	if(key) [dictionary setValue:[textField text] forKey:key];
}

#pragma mark -Text View

-(void) selectElementAtIndexPath:(NSIndexPath*)indexPath {}
-(void) textViewDidBeginEditing:(UITextView *)textView
{
	[delegate selectElementAtIndexPath:[self indexPath]];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSString * key = elementValueKey;
	
	if(key) [dictionary setValue:[textView text] forKey:key];
}
@end
