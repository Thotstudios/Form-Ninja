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
}
@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;

- (IBAction)buttonPressedForms:(id)sender;
- (IBAction)buttonPressedManagement:(id)sender;
- (IBAction)buttonPressedAccount:(id)sender;


// TODO: temporary
- (IBAction)buttonPressedTemplateEditor:(id)sender;

@end
