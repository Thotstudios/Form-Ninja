//
//  FormSingleLineElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormSingleLineElement.h"


@implementation FormSingleLineElement

@synthesize curLength, maxLength, minLength;

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
    
	NSString * valueString = [self.dictionary valueForKey:elementFormValueKey];
	if(!valueString) valueString = [self.dictionary valueForKey:elementValueKey];
	[self.valueField setText:valueString];
    
	[self.minLength setText:[self.dictionary valueForKey:elementMinLengthKey]];
	[self.maxLength setText:[self.dictionary valueForKey:elementMaxLengthKey]];
    
    valueString=[self.dictionary valueForKey:@"finished"];
    if ([valueString isEqualToString:@"yes"]) {
        self.valueField.enabled=NO;
    }
    else
        self.valueField.enabled=YES;
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
