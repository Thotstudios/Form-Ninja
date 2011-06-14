//
//  FormEditorViewController.h
//  FormNinja
//
//  Created by Programmer on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "TemplateEditorController.h"


@interface FormEditorViewController : TemplateEditorController {
    
}
- (void) newFormWithTemplate:(NSMutableArray*)data;

-(IBAction) saveButtonPressed;
-(IBAction) dumpButtonPressed;
-(IBAction) finishButtonPressed;

@end
