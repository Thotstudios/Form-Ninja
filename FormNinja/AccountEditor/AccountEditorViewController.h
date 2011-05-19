//
//  AccountEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountClass, CustomLoadAlertViewController;

@interface AccountEditorViewController : UIViewController
{
    AccountClass * account;
	UITextField *usernameTextField;
	UITextField *passwordTextField;
	UITextField *passwordChangeTextField;
	UITextField *passwordConfirmTextField;
	UITextField *firstNameTextField;
	UITextField *lastNameTextField;
	UITextField *emailAddressTextField;
	UITextField *companyNameTextField;
	UITextField *phoneNumberTextField;
	// security question
	// security answer
	UITextField *zipCodeTextField;
	UITextField *zipCodeExtTextField;
	
	UIView *changePasswordView;
    
    CustomLoadAlertViewController *loadAlert;
}

@property (retain, nonatomic) AccountClass * account;
@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordChangeTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordConfirmTextField;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic, retain) IBOutlet UITextField *companyNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneNumberTextField;
// security question
// security answer
@property (nonatomic, retain) IBOutlet UITextField *zipCodeTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipCodeExtTextField;

@property (nonatomic, retain) IBOutlet UIView *changePasswordView;

@property (nonatomic, retain) IBOutlet CustomLoadAlertViewController *loadAlert;

- (IBAction)pressedConfirm:(id)sender;
- (IBAction)pressedCancel:(id)sender;

@end

/*
 USERID
 USERNAME
 PASSWORD
 FNAME
 LNAME
 EMAIL
 COMPANY
 PHONE NUMBER
 SECURITYQUESTION
 SECURITYANSWER
 ZIPCODE
 ZIPCODEEXT
 
 */