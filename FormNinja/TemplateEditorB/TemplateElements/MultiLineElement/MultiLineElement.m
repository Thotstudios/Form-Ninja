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
	[dictionary setObject:@"Single-Line" forKey:@"type"];
	[valueField setText:nil];
	[minimumLengthField setText:nil];
	[maximumLengthField setText:nil];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[valueField setText:[dictionary objectForKey:@"value"]];
	[minimumLengthField setText:[dictionary objectForKey:@"minimum length"]];
	[maximumLengthField setText:[dictionary objectForKey:@"maximum length"]];
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
		[textField resignFirstResponder];
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
		key = @"label";
		break;
		
		case 2:
		key = @"minimum length";
		break;
		
		case 3:
		key = @"maximum length";
		break;
	}
	
	if(key) [dictionary setObject:[textField text] forKey:key];
}

#pragma mark -Text View

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSString * key = @"value";
	
	if(key) [dictionary setObject:[textView text] forKey:key];
}
@end
