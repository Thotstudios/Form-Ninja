//
//  FormEditorViewController.h
//  FormNinja
//
//  Created by Programmer on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateEditorController.h"
#import "Constants.h"

@interface FormEditorViewController : TemplateEditorController
{
	BOOL allowEditing;
}

@property BOOL allowEditing;

- (void) newFormWithTemplateAtPath:(NSString*)pathArg;
- (void) editFormAtPath:(NSString*)pathArg;

-(IBAction) saveButtonPressed;
-(IBAction) finishButtonPressed;
- (IBAction)abortFormPressed;

@end
