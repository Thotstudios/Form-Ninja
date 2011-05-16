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
}
@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;
@property (nonatomic, retain) IBOutlet UIViewController *accountEditor;
@property (nonatomic, retain) IBOutlet UIViewController *loginViewController;

- (IBAction)buttonPressedForms:(id)sender;
- (IBAction)buttonPressedManagement:(id)sender;
- (IBAction)buttonPressedAccount:(id)sender;

- (IBAction)requireLogin:(id)sender;


// TODO: temporary
- (IBAction)buttonPressedTemplateEditor:(id)sender;

@end
