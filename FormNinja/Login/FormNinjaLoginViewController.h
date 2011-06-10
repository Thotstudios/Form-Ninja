//
//  FormNinjaViewController.h
//  FormNinja
//
//  Created by Ollin on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomLoadAlertViewController, AccountEditorViewController;


@interface FormNinjaLoginViewController : UIViewController {
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


- (IBAction)rememberSwitchAction:(UISwitch*)sender;
- (IBAction) loginButtonAction;
- (IBAction) userAuthenticated; // TODO temporary


- (IBAction)pressedRegisterButton;

@end