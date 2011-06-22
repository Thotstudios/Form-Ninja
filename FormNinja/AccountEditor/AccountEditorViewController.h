//
//  AccountEditorViewController.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/7/11.
//  Copyright 2011 Thot Studios. All rights reserved.
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
	UITextField *zipCodeTextField;
	UITextField *zipCodeExtTextField;
    
    UIButton *confirmButton;
	
	UIButton *changePasswordButton;
	UIView *changePasswordView;
    UIButton *changePasswordConfirmButton;
	
	UIView *securityQuestionView;
	UITextField *securityQuestionTextField;
	UITextField *securityAnswerTextField;
    
    UILabel *statusLabel;
    
    int type; //0 indicates registration and 1 regular update
    
    CustomLoadAlertViewController *loadAlert;
}

@property (nonatomic, retain) AccountClass * account;

@property (nonatomic, retain) IBOutlet UIScrollView *scroller;

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordChangeTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordConfirmTextField;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic, retain) IBOutlet UITextField *companyNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipCodeTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipCodeExtTextField;

@property (nonatomic, retain) IBOutlet UIButton *changePasswordButton, *changePasswordConfirmButton, *confirmButton, *cancelButton;

@property (nonatomic, retain) IBOutlet UIView *changePasswordView;

@property (nonatomic, retain) IBOutlet UIView *securityQuestionView;
@property (nonatomic, retain) IBOutlet UITextField *securityQuestionTextField;
@property (nonatomic, retain) IBOutlet UITextField *securityAnswerTextField;

@property (nonatomic, retain) IBOutlet CustomLoadAlertViewController *loadAlert;

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

@property (nonatomic) int type;


- (IBAction) textFieldDidChange;

- (IBAction)pressedConfirm:(id)sender;
- (IBAction)pressedCancel:(id)sender;

- (IBAction)changePasswordEnable;
- (IBAction)changePasswordCancel;
- (IBAction)changePasswordConfirm;

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