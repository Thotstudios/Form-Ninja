//
//  FormAddressElement.m
//  FormNinja
//
//  Created by Programmer on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormAddressElement.h"


@implementation FormAddressElement
@synthesize fieldLabelLabel;

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
	//[dictionary setValue:@"Address" forKey:@"type"];
    //if the reset button is hit, kill all filled fields, and reset to the template-defined versions
    [dictionary removeObjectForKey:@"filled address line"];
    [dictionary removeObjectForKey:@"filled address line 2"];
    [dictionary removeObjectForKey:@"filled city name"];
    [dictionary removeObjectForKey:@"filled abbr"];
    [dictionary removeObjectForKey:@"filled zip code"];
	[addressLineOneField setText:[dictionary valueForKey:@"address line"]];
	[addressLineTwoField setText:[dictionary valueForKey:@"address line 2"]];
	[cityNameField setText:[dictionary valueForKey:@"city name"]];
	[stateAbbrField setText:[dictionary valueForKey:@"state abbr"]];
	[zipCodeField setText:[dictionary valueForKey:@"zip code"]];
}

-(void)	setDictionary:(NSMutableDictionary *)arg
{
	[super setDictionary:arg];
    NSString *stringValue;
    stringValue=[dictionary valueForKey:@"filled address line"];
    if (stringValue) {//if the 'filled' value exists, use it, otherwise...
        [addressLineOneField setText:stringValue];
    }
    else
    {//use form defined value
        [addressLineOneField setText:[dictionary valueForKey:@"address line"]];
    }
    stringValue=nil;//Not really needed since dictionaries return nil for keys not found; included for code clarity reading
    
    
    stringValue=[dictionary valueForKey:@"filled address line 2"];
    if (stringValue) {
        [addressLineTwoField setText:stringValue];
    }
    else
    {
        [addressLineTwoField setText:[dictionary valueForKey:@"address line 2"]];
    }
    stringValue=nil;
    
    stringValue=[dictionary valueForKey:@"filled city name"];
    if (stringValue) {
        [cityNameField setText:stringValue];
    }
    else
    {
        [cityNameField setText:[dictionary valueForKey:@"city name"]];
    }
    stringValue=nil;
    
    stringValue=[dictionary valueForKey:@"filled state abbr"];
    if (stringValue) {
        [stateAbbrField setText:stringValue];
    }
    else
    {
        [stateAbbrField setText:[dictionary valueForKey:@"state abbr"]];
    }
    stringValue=nil;
    
    stringValue=[dictionary valueForKey:@"filled zip code"];
    if (stringValue) {
        [zipCodeField setText:stringValue];
    }
    else
    {
        [zipCodeField setText:[dictionary valueForKey:@"zip code"]];
    }
    stringValue=nil;
	
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
            key = @"filled address line";
            break;
            
		case 3: // addr 2
            key = @"filled address line 2";
            break;
            
		case 4: // city
            key = @"filled city name";
            break;
            
		case 5: // state
            key = @"filled state abbr";
            break;
            
		case 6: // zip
            key = @"filled zip code";
            break;
	}
	if(key)
		[dictionary setValue:[textField text] forKey:key];
}

@end
