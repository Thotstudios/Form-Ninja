//
//  FormManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateManagerViewController.h"

#import "FormEditorViewController.h"

#import "PopOverManager.h"

@interface FormManagerViewController : TemplateManagerViewController <PopOverManagerDelegate>
{
	NSMutableArray * formList;
	NSMutableArray * filteredFormList;
	NSMutableArray * formNameList;
	
	UITableView *formTable;
	UIButton *createFormButton;
	UIButton *resumeFormButton;
	
	FormEditorViewController *formEditorViewController;
}

// Member Objects
@property (nonatomic, retain) NSMutableArray * formList;
@property (nonatomic, retain) NSMutableArray * filteredFormList;
@property (nonatomic, retain) NSMutableArray * formNameList;

// Interface Objects
@property (nonatomic, retain) IBOutlet UITableView *formTable;
@property (nonatomic, retain) IBOutlet UIButton *createFormButton;
@property (nonatomic, retain) IBOutlet UIButton *resumeFormButton;

@property (nonatomic, retain) IBOutlet FormEditorViewController *formEditorViewController;

- (IBAction)newFormWithSelectedTemplate;
- (IBAction)resumeSelectedForm;

@end
