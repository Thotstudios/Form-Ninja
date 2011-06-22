//
//  FormAddressElement.m
//  FormNinja
//
//  Created by Ron Lugge on 6/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "FormAddressElement.h"


@implementation FormAddressElement

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

-(void) reset
{
	//[super reset];
	//[dictionary setValue:@"Address" forKey:elementTypeKey];
    //if the reset button is hit, kill all filled fields, and reset to the template-defined versions
	
    [self.dictionary removeObjectForKey:elementFormAddressLineKey];
    [self.dictionary removeObjectForKey:elementFormAddressLine2Key];
    [self.dictionary removeObjectForKey:elementFormAddressCityNameKey];
    [self.dictionary removeObjectForKey:elementFormAddressStateKey];
    [self.dictionary removeObjectForKey:elementFormAddressZipKey];
	
	[self.addressLineOneField setText:[self.dictionary valueForKey:elementAddressLineKey]];
	[self.addressLineTwoField setText:[self.dictionary valueForKey:elementAddressLine2Key]];
	[self.cityNameField setText:[self.dictionary valueForKey:elementAddressCityNameKey]];
	[self.stateAbbrField setText:[self.dictionary valueForKey:elementAddressStateKey]];
	[self.zipCodeField setText:[self.dictionary valueForKey:elementAddressZipKey]];
}

-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];

    NSString *stringValue;
    stringValue=[self.dictionary valueForKey:elementFormAddressLineKey];
    if (stringValue) {//if the 'filled' value exists, use it, otherwise...
        [self.addressLineOneField setText:stringValue];
    }
    else
    {//use form defined value
        [self.addressLineOneField setText:[self.dictionary valueForKey:elementAddressLineKey]];
    }
    stringValue=nil;//Not really needed since dictionaries return nil for keys not found; included for code clarity reading
    
    
    stringValue=[self.dictionary valueForKey:elementFormAddressLine2Key];
    if (stringValue) {
        [self.addressLineTwoField setText:stringValue];
    }
    else
    {
        [self.addressLineTwoField setText:[self.dictionary valueForKey:elementAddressLine2Key]];
    }
    stringValue=nil;
    
    stringValue=[self.dictionary valueForKey:elementFormAddressCityNameKey];
    if (stringValue) {
        [self.cityNameField setText:stringValue];
    }
    else
    {
        [self.cityNameField setText:[self.dictionary valueForKey:elementAddressCityNameKey]];
    }
    stringValue=nil;
    
    stringValue=[self.dictionary valueForKey:elementFormAddressStateKey];
    if (stringValue) {
        [self.stateAbbrField setText:stringValue];
    }
    else
    {
        [self.stateAbbrField setText:[self.dictionary valueForKey:elementAddressStateKey]];
    }
    stringValue=nil;
    
    stringValue=[self.dictionary valueForKey:elementFormAddressZipKey];
    if (stringValue) {
        [self.zipCodeField setText:stringValue];
    }
    else
    {
        [self.zipCodeField setText:[self.dictionary valueForKey:elementAddressZipKey]];
    }
    stringValue=nil;
    
    stringValue=[self.dictionary valueForKey:@"finished"];
    if ([[NSString stringWithFormat:@"yes"] isEqualToString:stringValue]) {
        //self.zipCodeField.edita
    }
	
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	id key = nil;
	switch ([textField tag])
	{
		case 1: // label -- SHOULD NEVER EXIST!
            key = @"filled label";
            NSLog(@"Error!  Case 1 called in FormAddressElement.m -- should NEVER HAPPEN!");
            break;
            
		case 2: // addr 1
            key = elementFormAddressLineKey;
            break;
            
		case 3: // addr 2
            key = elementFormAddressLine2Key;
            break;
            
		case 4: // city
            key = elementFormAddressCityNameKey;
            break;
            
		case 5: // state
            key = elementFormAddressStateKey;
            break;
            
		case 6: // zip
            key = elementFormAddressZipKey;
            break;
	}
	if(key)
		[self.dictionary setValue:[textField text] forKey:key];
}

@end
