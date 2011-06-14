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
    [dictionary removeObjectForKey:@"filled value"];
	[valueField setText:[dictionary valueForKey:@"value"]];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
    
	[labelLabel setText:[dictionary objectForKey:@"label"]];
    NSNumber *index=[dictionary objectForKey:@"label alignment"];
    if ([index intValue]==0) {
        labelLabel.textAlignment=UITextAlignmentLeft;
    }
    else if([index intValue]==1)
    {
        labelLabel.textAlignment=UITextAlignmentCenter; 
    }
    else if([index intValue]==2)
    {
        labelLabel.textAlignment=UITextAlignmentRight;
    }
    
    NSString *stringValue=[dictionary valueForKey:@"filled value"];
    if (stringValue) {
        [valueField setText:stringValue];
    }
    else
    {
        [valueField setText:[dictionary valueForKey:@"value"]];
    }
    
	[minLength setText:[dictionary valueForKey:@"minimum length"]];
	[maxLength setText:[dictionary valueForKey:@"maximum length"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1:
            key = @"filled label";
            break;
            
		case 2:
            key = @"filled minimum length";
            break;
            
		case 3:
            key = @"filled maximum length";
            break;
            
		case 4:
            key = @"filled value";
            break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [curLength setText:[NSString stringWithFormat:@"%i", [valueField.text length]]];
    
    //TODO:  Validate length.
    
    return NO;
}

@end
