//
//  stringFieldViewController.m
//  FormNinja
//
//  Created by Programmer on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "stringFieldViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation stringFieldViewController
@synthesize delegate;
@synthesize minLengthLabel, maxLengthLabel;
@synthesize minLengthSlider, maxLengthSlider;
@synthesize fieldNameTextField;

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
    [self sliderUpdated:minLengthSlider];
    [self sliderUpdated:maxLengthSlider];
    self.view.layer.cornerRadius=20;
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


#pragma mark UI Functionality
//These all need to be reported 'up' the chain via delegate methods
-(IBAction) changeTypeButtonPressed
{
    [[self delegate] changeButtonPressed:self];
}

-(IBAction) removeButtonPressed
{
    [[self delegate] removeButtonPressed:self];
}
-(IBAction) moveUpButtonPressed
{
    [[self delegate] moveUpButtonPressed:self];
}

-(IBAction) moveDownButtonPressed
{
    [[self delegate] moveDownButtonPressed:self];
}

//these methods act 'internally' -- their data can be queried later by the delegate at it's discretion

//This function is sent by the slider when it's updated.
//Use it to query against the slider and find out it's value
-(IBAction) sliderUpdated:(UISlider *)theSlider
{
    int newCharCount=[[NSNumber numberWithFloat:theSlider.value] intValue];
    if (theSlider==minLengthSlider) {
        self.minLengthLabel.text=[NSString stringWithFormat:@"%i characters",newCharCount];
    }
    else
        self.maxLengthLabel.text=[NSString stringWithFormat:@"%i characters",newCharCount];
}

#pragma mark Own Delegate Functionality

//originaly had setDelegate here; caused infinite loop when it collided with the @synthesized function of same name

#pragma mark other delegates

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [delegate textFieldShouldReturn:textField fromStringField:self];
}

@end
