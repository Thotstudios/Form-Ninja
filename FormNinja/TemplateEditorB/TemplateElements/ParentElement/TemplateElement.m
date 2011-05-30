//
//  ParentElement.m
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateElement.h"


@implementation TemplateElement

@synthesize delegate;
@synthesize dictionary;
@synthesize labelField;
@synthesize labelAlignmentControl;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	dictionary = [[NSMutableDictionary alloc] init];
	[self reset];
}

- (void)viewDidUnload
{
	[self setDictionary:nil];
    [self setLabelField:nil];
	[self setLabelAlignmentControl:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
	[dictionary release];
	[labelField release];
	[labelAlignmentControl release];
    [super dealloc];
}


#pragma mark - Methods

-(void) setIndex:(int)arg
{
	index = arg;
}
-(IBAction) reset
{
	[labelField setText:nil];
	[dictionary removeAllObjects];
	[dictionary setValue:@"Label" forKey:@"type"];
	[labelAlignmentControl setSelectedSegmentIndex:0];
}

-(void) setDictionary:(NSMutableDictionary *)arg
{
	[dictionary release];
	dictionary = [arg retain];
	[labelField setText:[dictionary objectForKey:@"label"]];
	[labelAlignmentControl setSelectedSegmentIndex:[[dictionary objectForKey:@"label alignment"] integerValue]];
}

#pragma mark - Delegate Methods:

#pragma mark -Segmented Control

- (IBAction)segmentedControlValueDidChange:(UISegmentedControl*)segmentedControl
{
	[dictionary setValue:[NSNumber numberWithInteger:[segmentedControl selectedSegmentIndex]] forKey:@"label alignment"];
}

#pragma mark -Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	switch([textField tag])
	{
		case 0: default: // error
		[textField resignFirstResponder];
		break;
	}
	return YES;
}

-(void) selectSection:(int)arg
{}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	[delegate selectSection:index];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1:
		key = @"label";
		break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

@end
