//
//  ParentElement.m
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemplateElement.h"

#import "Constants.h"

@implementation TemplateElement

@synthesize delegate;
@synthesize dictionary;
@synthesize labelField;
@synthesize labelAlignmentControl;

#pragma mark - View lifecycle

-(id) init
{
	if((self = [super init]) == nil) return nil;
	
	[self setDictionary:[NSMutableDictionary dictionary]];
	[self reset];
	
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
	[self setDelegate:nil];
	[self setDictionary:nil];
    [self setLabelField:nil];
	[self setLabelAlignmentControl:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
	[delegate release];
	[dictionary release];
	[labelField release];
	[labelAlignmentControl release];
    [super dealloc];
}


#pragma mark - Overloaded Methods

-(void) beginEditing
{
	if(labelField)
		[labelField becomeFirstResponder];
	else
		[self editNextElement];
}

-(IBAction) reset
{
	[labelField setText:nil];
	[dictionary removeAllObjects];
	[dictionary setValue:@"Label" forKey:elementTypeKey];
	[labelAlignmentControl setSelectedSegmentIndex:0];
}

-(void) setDictionary:(NSMutableDictionary *)arg
{
	[self.view setNeedsDisplay];
	[dictionary release];
	dictionary = [arg retain];
	[labelField setText:[dictionary objectForKey:elementLabelKey]];
	[labelAlignmentControl setSelectedSegmentIndex:[[dictionary objectForKey:@"label alignment"] integerValue]];
}

-(BOOL) isValid
{
	BOOL ret = YES;
	return ret;
}
#pragma mark - Non-overloaded Methods

- (NSIndexPath *) indexPath
{
	NSUInteger row = [[dictionary objectForKey:elementRowIndexKey] unsignedIntegerValue];
	NSUInteger section = [[dictionary objectForKey:elementSectionIndexKey] unsignedIntegerValue];
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
	return indexPath;
}

-(void) editElementAfterIndexPath:(NSIndexPath*)indexPath {}
-(void) editNextElement
{
	[delegate editElementAfterIndexPath:[self indexPath]];
}
- (void) moveUpElementAtIndexPath:(NSIndexPath*)arg {}
- (IBAction)moveUp
{
	[delegate moveUpElementAtIndexPath:[self indexPath]];
}

- (void) moveDownElementAtIndexPath:(NSIndexPath*)arg {}
- (IBAction)moveDown
{
	[delegate moveDownElementAtIndexPath:[self indexPath]];
}

-(void) addElementBelowIndexPath:(NSIndexPath*)arg {}
- (IBAction)addRow
{
	[delegate addElementBelowIndexPath:[self indexPath]];
}

-(void) deleteElementAtIndexPath:(NSIndexPath*)arg {}
- (IBAction)deleteRow
{
	[delegate deleteElementAtIndexPath:[self indexPath]];
}

#pragma mark - SegmentedControl Delegate

- (IBAction)segmentedControlValueDidChange:(UISegmentedControl*)segmentedControl
{
	[dictionary setValue:[NSNumber numberWithInteger:[segmentedControl selectedSegmentIndex]] forKey:@"label alignment"];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
	return YES;
}

-(void) selectElementAtIndexPath:(NSIndexPath*)indexPath {}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
	[delegate selectElementAtIndexPath:[self indexPath]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1:
		key = elementLabelKey;
		break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
	[self editNextElement];
}


@end
