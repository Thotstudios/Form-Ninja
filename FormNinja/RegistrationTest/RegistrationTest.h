//
//  RegistrationTest.h
//  FormNinja
//
//  Created by Hackenslacker on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceMessageQueue.h"
#import "RegistrationMessage.h"
#import "LoginMessage.h"

@interface RegistrationTest : UIViewController <RegistrationMessageDelegate, LoginMessageDelegate, MessageDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField, *passwordField;
@property (nonatomic, retain) IBOutlet UITextView *resultTextView;
@property (nonatomic, retain) RegistrationMessage *regMessage;
@property (nonatomic, retain) LoginMessage *loginMessage;

-(IBAction) fauxRegistrationPressed;
-(IBAction) loginPressed;

@end
