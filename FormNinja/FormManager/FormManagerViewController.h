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
	NSMutableArray * formListFilteredByGroup;
	NSMutableArray * formListFilteredByTemplate;
	NSMutableArray * formNameList;
	
	UITableView *formTable;
	UIButton *createFormButton;
	UIButton *resumeFormButton;
	UIButton *viewFormButton;
	UIButton *deleteFormButton;
	
	FormEditorViewController *formEditorViewController;
}

// Member Objects
@property (nonatomic, retain) NSMutableArray * formList;
@property (nonatomic, retain) NSMutableArray * formListFilteredByGroup;
@property (nonatomic, retain) NSMutableArray * formListFilteredByTemplate;
@property (nonatomic, retain) NSMutableArray * formNameList;

// Interface Objects
@property (nonatomic, retain) IBOutlet UITableView *formTable;
@property (nonatomic, retain) IBOutlet UIButton *createFormButton;
@property (nonatomic, retain) IBOutlet UIButton *resumeFormButton;
@property (nonatomic, retain) IBOutlet UIButton *viewFormButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteFormButton;

@property (nonatomic, retain) IBOutlet FormEditorViewController *formEditorViewController;

- (IBAction)newFormWithSelectedTemplate;
- (IBAction)editSelectedForm;
- (IBAction)viewSelectedForm;
- (IBAction)deleteSelectedForm;

@end
