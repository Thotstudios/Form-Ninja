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
	// Interface Elements:
	UILabel *loginExpirationLabel;
	UILabel *versionLabel;
	
	// View Controllers:
	UIViewController *loginViewController;
	UIViewController *formManagerViewController;
	UIViewController *accountEditor;
	UIViewController *templateManagerViewContoller;
	UIViewController *groupManagerViewController;
	
	
	// TODO: temporary members
	UIViewController *templateEditorViewController;
	UIViewController *signatureViewController;
	UIViewController *temporaryFormEditorViewController;
}
// Interface Elements:
@property (nonatomic, retain) IBOutlet UILabel *loginExpirationLabel;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

// View Controllers:
@property (nonatomic, retain) IBOutlet UIViewController *loginViewController;
@property (nonatomic, retain) IBOutlet UIViewController *formManagerViewController;
@property (nonatomic, retain) IBOutlet UIViewController *templateManagerViewContoller;
@property (nonatomic, retain) IBOutlet UIViewController *groupManagerViewController;
@property (nonatomic, retain) IBOutlet UIViewController *accountEditor;


- (IBAction)pushFormManagerViewController;
- (IBAction)pushTemplateManagerViewController;
- (IBAction)pushGroupManagerViewController;
- (IBAction)pushAccountEditorViewController;
- (IBAction)logout;


// TODO: Temporary properties and methods
@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;
- (IBAction)buttonPressedTemplateEditor:(id)sender;

@property (nonatomic, retain) IBOutlet UIViewController *temporaryFormEditorViewController;
- (IBAction)pressedTemporaryFormEditorButton;

@property (nonatomic, retain) IBOutlet UIViewController *signatureViewController;
- (IBAction)signatureTesting;

@end
