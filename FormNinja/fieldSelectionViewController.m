//
//  fieldSelectionViewController.m
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "fieldSelectionViewController.h"


@implementation fieldSelectionViewController
@synthesize availableFields;
@synthesize delegate;
@synthesize picker;
@synthesize insertionIndex;

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
    NSDictionary *stringType=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"type",
                              @"One Line Text",@"label",
                              nil];
    self.availableFields=[NSArray arrayWithObjects:stringType, nil];
    
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

#pragma mark - IBAction Functions

-(IBAction) selectButtonPressed
{
    NSDictionary *temporary=[availableFields objectAtIndex:[picker selectedRowInComponent:0]];
    
    [[self delegate] fieldSelectionDidChooseFieldType:[temporary objectForKey:@"type"] 
                                            withIndex:insertionIndex
                                       fromController:self];
    //-(void) fieldSelectionDidChooseFieldType:(NSString *)fieldType;    
}

-(IBAction) cancelButtonPressed
{
    //-(void) fieldSelectionCancelButtonPressed:(fieldSelectionViewController *)controller;
    [self.delegate fieldSelectionCancelButtonPressed:self];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [availableFields count];
}

#pragma mark - Picker View Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[availableFields objectAtIndex:component] objectForKey:@"label"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 384;
}

@end
