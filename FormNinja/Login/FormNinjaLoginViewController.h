//
//  FormNinjaViewController.h
//  FormNinja
//
//  Created by Paul Salazar on 4/30/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomLoadAlertViewController, AccountEditorViewController;


@interface FormNinjaLoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
	UISwitch *rememberSwitch;
   
    IBOutlet UIButton *loginButton;
    
    IBOutlet UILabel *statusLabel;
    
    IBOutlet CustomLoadAlertViewController *loadAlert;
	AccountEditorViewController *accountEditor;

}


@property (nonatomic, retain) UITextField *usernameField, *passwordField;
@property (nonatomic, retain) IBOutlet UISwitch *rememberSwitch;
@property (nonatomic, retain) UIButton *loginButton;

//@property (nonatomic, retain) IBOutlet UIViewController *mainMenuViewController; 
@property (nonatomic, retain) CustomLoadAlertViewController *loadAlert;
@property (nonatomic, retain) IBOutlet AccountEditorViewController *accountEditor;

@property (nonatomic, retain) UILabel *statusLabel;

@property (nonatomic, retain) IBOutlet UIViewController * registrationTest; // TODO: remove

- (IBAction)rememberSwitchAction:(UISwitch*)sender;
- (IBAction) loginButtonAction;
- (IBAction) testButtonPressed; // TODO remove


- (IBAction)pressedRegisterButton;

@end
