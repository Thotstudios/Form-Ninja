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
    [self.dictionary removeObjectForKey:@"filled value"];
	[self.valueField setText:[self.dictionary valueForKey:@"value"]];
}
-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
    
	[self.labelLabel setText:[self.dictionary objectForKey:@"label"]];
    NSNumber *index=[self.dictionary objectForKey:@"label alignment"];
    if ([index intValue]==0) {
        self.labelLabel.textAlignment=UITextAlignmentLeft;
    }
    else if([index intValue]==1)
    {
        self.labelLabel.textAlignment=UITextAlignmentCenter; 
    }
    else if([index intValue]==2)
    {
        self.labelLabel.textAlignment=UITextAlignmentRight;
    }
    
    NSString *stringValue=[self.dictionary valueForKey:@"filled value"];
    if (stringValue) {
        [self.valueField setText:stringValue];
    }
    else
    {
        [self.valueField setText:[self.dictionary valueForKey:@"value"]];
    }
    
	[self.minLength setText:[self.dictionary valueForKey:@"minimum length"]];
	[self.maxLength setText:[self.dictionary valueForKey:@"maximum length"]];
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
		[self.dictionary setValue:[textField text] forKey:key];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.curLength setText:[NSString stringWithFormat:@"%i", [self.valueField.text length]]];
    
    //TODO:  Validate length.
    
    return NO;
}

@end
