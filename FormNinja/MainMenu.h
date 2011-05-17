//
//  MainMenu.h
//  FormNinja
//
//  Created by Hackenslacker on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainMenu : UIViewController
{
	UIViewController *templateEditorViewController;
	UIViewController *accountEditor;
	UIViewController *loginViewController;
	UIViewController *templateManagerViewContoller;
	UILabel *loginExpirationLabel;
}
@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;
@property (nonatomic, retain) IBOutlet UIViewController *accountEditor;
@property (nonatomic, retain) IBOutlet UIViewController *loginViewController;
@property (nonatomic, retain) IBOutlet UIViewController *templateManagerViewContoller;
@property (nonatomic, retain) IBOutlet UILabel *loginExpirationLabel;

- (IBAction)buttonPressedForms:(id)sender;
- (IBAction)buttonPressedTemplateManagement:(id)sender;
- (IBAction)buttonPressedAccount:(id)sender;

- (IBAction)requireLogin;


// TODO: temporary
- (IBAction)buttonPressedTemplateEditor:(id)sender;

@end
