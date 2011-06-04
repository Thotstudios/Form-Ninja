//
//  FormManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateManagerViewController.h"

@interface FormManagerViewController : TemplateManagerViewController
{
	NSMutableArray * formList;
	
	UITableView *formTable;
	UIButton *createFormButton;
	UIButton *resumeFormButton;
	
	UIViewController *formEditorViewController;
}

@property (nonatomic, retain) NSMutableArray * formList;

@property (nonatomic, retain) IBOutlet UITableView *formTable;

@property (nonatomic, retain) IBOutlet UIButton *createFormButton;
@property (nonatomic, retain) IBOutlet UIButton *resumeFormButton;

@property (nonatomic, retain) IBOutlet UIViewController *formEditorViewController;

- (IBAction)newFormWithSelectedTemplate;
- (IBAction)resumeSelectedForm;

@end
