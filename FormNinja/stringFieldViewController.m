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
@synthesize dictValue;
@synthesize delegate;
@synthesize minLengthLabel, maxLengthLabel;
@synthesize fieldNameTextField, minLengthTextField, maxLengthTextField;

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
    if(dictValue!=nil)
    {
        self.fieldNameTextField.text=[dictValue valueForKey:@"label"];
        self.minLengthTextField.text=[dictValue valueForKey:@"minLength"];
        self.maxLengthTextField.text=[dictValue valueForKey:@"maxLength"];
    }
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Save/load


-(void)setByDictionary:(NSDictionary *) aDictionary
{
    
    self.dictValue=aDictionary;
    self.fieldNameTextField.text=[aDictionary valueForKey:@"label"];
    self.minLengthTextField.text=[aDictionary valueForKey:@"minLength"];
    self.maxLengthTextField.text=[aDictionary valueForKey:@"maxLength"];
    
    //self.maxLengthSlider.value=[[aDictionary valueForKey:@"maxLength"] floatValue];
    //self.minLengthSlider.value=[[aDictionary valueForKey:@"minLength"] floatValue];
    //[self sliderUpdated:maxLengthSlider];
    //[self sliderUpdated:minLengthSlider];
    
}


-(NSDictionary *) getDictionaryData
{
    NSMutableDictionary *fieldDictionary=[NSMutableDictionary dictionary];
    
    [fieldDictionary setValue:@"string" forKey:@"type"];
    [fieldDictionary setValue:fieldNameTextField.text forKey:@"label"];
    [fieldDictionary setValue:minLengthTextField.text forKey:@"minLength"];
    [fieldDictionary setValue:maxLengthTextField.text forKey:@"maxLength"];

    return fieldDictionary;
}

#pragma mark - UI Functionality
//These all need to be reported 'up' the chain via delegate methods

-(IBAction) addButtonPressed
{
    [[self delegate] addFieldButtonPressed:self];
}

-(IBAction) removeButtonPressed
{
    NSLog(@"stringField remove");
    [[self delegate] removeFieldButtonPressed:self];
}
-(IBAction) moveUpButtonPressed
{
    [[self delegate] moveFieldUpButtonPressed:self];
}

-(IBAction) moveDownButtonPressed
{
    [[self delegate] moveFieldDownButtonPressed:self];
}

#pragma mark Own Delegate Functionality

//originaly had setDelegate here; caused infinite loop when it collided with the @synthesized function of same name

#pragma mark other delegates

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==minLengthTextField) {
        //handle converting into integers
    }
    else if (textField==maxLengthTextField)
    {
        //handle converting into integers
    }
    return YES;
}

@end
