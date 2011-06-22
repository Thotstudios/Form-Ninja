//
//  FormEditorViewController.h
//  FormNinja
//
//  Created by Ron Lugge on 6/6/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateEditorController.h"
#import "Constants.h"
#import "FormFinishViewController.h"

@interface FormEditorViewController : TemplateEditorController <FormFinishDelegate>
{
	BOOL allowEditing;
}

@property BOOL allowEditing;
@property (nonatomic, retain) IBOutlet UIButton *saveButton, *abortButton, *finishButton;

- (void) newFormWithTemplateAtPath:(NSString*)pathArg;
- (void) loadFormAtPath:(NSString*)pathArg;

-(IBAction) saveButtonPressed;
-(IBAction) finishButtonPressed;
- (IBAction)abortFormPressed;

@end
