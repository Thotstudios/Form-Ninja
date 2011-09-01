//
//  RegistrationTest.m
//  FormNinja
//
//  Created by Hackenslacker on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegistrationTest.h"
#import "WebServiceLink.h"

@implementation RegistrationTest
@synthesize registration;
@synthesize resultTextView;
@synthesize usernameField, passwordField;

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

-(IBAction) fauxRegistrationPressed
{
    id regger=[WebServiceLink registerUserWithDelegate:self andUserName:@"Rilbur" andPassword:@"Rilbur" andFName:@"Fname" andLName:@"lname" andEmail:@"email@email.com" andZip:@"93245" andZipExt:@"2423" andPhoneNumber:@"5596818113" andCompany:@"thotstudios" andSecurityQuestion:@"quest" andSecurityAnswer:@"tion"];
    self.registration=regger;
    [resultTextView setText:@"Sending request..."];
}

- (void)registrationReturnedWithResult:(BOOL) result andErrors:(NSDictionary *)errors
{
    NSString *resultText;
    NSString *errorText=@"";
    if(result)
    {
        resultText=@"Registration successful!";
        }
    else
    {
        resultText=@"Registration failed --";
        NSArray *errorArray=[errors allKeys];
        for (NSString *error in errorArray) {
            errorText=[errorText stringByAppendingString:[NSString stringWithFormat:@" %@", error]];
        }
    }
    [resultTextView setText:[NSString stringWithFormat:@"%@%@", resultText, errorText]];
}

@end
