//
//  RegistrationTest.h
//  FormNinja
//
//  Created by Hackenslacker on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceLink.h"

@interface RegistrationTest : UIViewController <registrationDelegate, loginDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField, *passwordField;
@property (nonatomic, retain) IBOutlet UITextView *resultTextView;
@property (nonatomic, retain) RegistrationConnectionHandler *registration;
@property (nonatomic, retain) LoginConnectionHandler *logger;

-(IBAction) fauxRegistrationPressed;
-(IBAction) loginPressed;

@end
