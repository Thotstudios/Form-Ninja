//
//  AddressElement.m
//  Dev
//
//  Created by Hackenslacker on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressElement.h"


@implementation AddressElement

@synthesize addressLineOneField;
@synthesize addressLineTwoField;
@synthesize cityNameField;
@synthesize stateAbbrField;
@synthesize zipCodeField;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[self setAddressLineOneField:nil];
	[self setAddressLineTwoField:nil];
	[self setCityNameField:nil];
	[self setStateAbbrField:nil];
	[self setZipCodeField:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
	[addressLineOneField release];
	[addressLineTwoField release];
	[cityNameField release];
	[stateAbbrField release];
	[zipCodeField release];
    [super dealloc];
}

#pragma mark - Methods

-(void) reset
{
	[super reset];
	[dictionary setValue:@"Address" forKey:elementTypeKey];
	[addressLineOneField setText:nil];
	[addressLineTwoField setText:nil];
	[cityNameField setText:nil];
	[stateAbbrField setText:nil];
	[zipCodeField setText:nil];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
	[addressLineOneField setText:[dictionary valueForKey:elementAddressLineKey]];
	[addressLineTwoField setText:[dictionary valueForKey:elementAddressLine2Key]];
	[cityNameField setText:[dictionary valueForKey:elementAddressCityNameKey]];
	[stateAbbrField setText:[dictionary valueForKey:elementAddressStateKey]];
	[zipCodeField setText:[dictionary valueForKey:elementAddressZipKey]];
	
}
#pragma mark - Delegate Methods:
#pragma mark -Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * number; number = nil;
	
	switch([textField tag])
	{
		case 0: default: // error
		break;
		
		case 1: // label
		[addressLineOneField becomeFirstResponder];
		break;
		
		case 2: // addr 1
		[addressLineTwoField becomeFirstResponder];
		break;
		
		case 3: // addr 2
		[cityNameField becomeFirstResponder];
		break;
		
		case 4: // city
		[stateAbbrField becomeFirstResponder];
		break;
		
		case 5: // state
		if(0) // TODO: validate state abbr?
			return NO;
		[zipCodeField becomeFirstResponder];
		break;
		
		case 6: // zip
		if(0) // TODO: validate zip code?
			{
			number = [formatter numberFromString:[zipCodeField text]];
			if(!number)
				return NO;
			[zipCodeField setText:[NSString stringWithFormat:@"%@", number]];
			}
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
		case 1: // label
		key = elementLabelKey;
		break;
		
		case 2: // addr 1
		key = elementAddressLineKey;
		break;
		
		case 3: // addr 2
		key = elementAddressLine2Key;
		break;
		
		case 4: // city
		key = elementAddressCityNameKey;
		break;
		
		case 5: // state
		key = elementAddressStateKey;
		break;
		
		case 6: // zip
		key = elementAddressZipKey;
		break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

@end
