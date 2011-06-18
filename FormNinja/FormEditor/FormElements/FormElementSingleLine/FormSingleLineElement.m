//
//  FormSingleLineElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormSingleLineElement.h"


@implementation FormSingleLineElement

@synthesize labelLabel, curLength, maxLength, minLength;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)reset
{
    [self.dictionary removeObjectForKey:elementFormValueKey];
	[self.valueField setText:[self.dictionary valueForKey:elementValueKey]];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
    
	[self.labelLabel setText:[self.dictionary objectForKey:elementLabelKey]];
	switch ([[dictionary valueForKey:@"label alignment"] intValue])
	{
		case 0: default:
		[labelLabel setTextAlignment:UITextAlignmentLeft];
		break;
		case 1:
		[labelLabel setTextAlignment:UITextAlignmentCenter];
		break;
		case 2:
		[labelLabel setTextAlignment:UITextAlignmentRight];
		break;
	}
	NSString * valueString = [dictionary valueForKey:elementFormValueKey];
	if(!valueString) valueString = [dictionary valueForKey:elementValueKey];
	[valueField setText:valueString];
    
	[self.minLength setText:[self.dictionary valueForKey:elementMinLengthKey]];
	[self.maxLength setText:[self.dictionary valueForKey:elementMaxLengthKey]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if([textField tag] == 4)
		[self.dictionary setValue:[textField text] forKey:elementFormValueKey];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.curLength setText:[NSString stringWithFormat:@"%i", [self.valueField.text length]]];
    
    //TODO:  Validate length.
    
    return YES;
}

@end
