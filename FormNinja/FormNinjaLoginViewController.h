//
//  FormNinjaViewController.h
//  FormNinja
//
//  Created by Ollin on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormNinjaLoginViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
	UIViewController *mainMenuViewController;
}


@property(nonatomic, retain) UITextField *usernameField, *passwordField;
@property (nonatomic, retain) IBOutlet UIViewController *mainMenuViewController;


- (IBAction) loginButtonAction;


@end
