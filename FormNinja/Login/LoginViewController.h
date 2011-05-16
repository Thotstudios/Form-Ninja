//
//  LoginViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomLoadAlertViewController;

@interface LoginViewController : UIViewController
{
	UITextField *usernameField;
	UITextField *passwordField;
	UIButton *loginButton;
	UILabel *statusLabel;
	CustomLoadAlertViewController *loadAlert;
}
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet CustomLoadAlertViewController *loadAlert;

- (IBAction)loginButtonAction;
- (IBAction)userAuthenticated; // TODO: temporary. -Chad

@end
