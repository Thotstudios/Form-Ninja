//
//  MainMenu.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/1/11.
//  Copyright 2011 Thot Studios. All rights reserved.
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
    IBOutlet UIButton *logoutButton, *profileButton, *formsButton, *templateButton, *groupsButton;
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

@end
