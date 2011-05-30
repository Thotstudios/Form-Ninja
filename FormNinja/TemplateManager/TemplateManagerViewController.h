//
//  TemplateManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemplateEditorController;

@interface TemplateManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
	NSMutableArray * groupNameList;
	NSMutableArray * templateList;
	NSMutableArray * filteredTemplateList;
	
	UITableView *templateTable;
	UITableView *groupTable;
	
	UIButton *deleteTemplateButton;
	UIButton *copyTemplateButton;
	UIButton *editTemplateButton;
	UIButton *createTemplateButton;
	
	TemplateEditorController *templateEditor;
	
	
	UIViewController *oldTemplateEditorViewController; // TODO: remove
}

// Data Members
@property (nonatomic, retain) NSMutableArray * groupNameList;
@property (nonatomic, retain) NSMutableArray * templateList;
@property (nonatomic, retain) NSMutableArray * filteredTemplateList;

// Interface Members
@property (nonatomic, retain) IBOutlet UITableView *groupTable;
@property (nonatomic, retain) IBOutlet UITableView *templateTable;

@property (nonatomic, retain) IBOutlet UIButton *deleteTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *copyTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *editTemplateButton;
@property (nonatomic, retain) IBOutlet UIButton *createTemplateButton;

@property (nonatomic, retain) IBOutlet TemplateEditorController *templateEditor;

// Instance Methods
- (BOOL) isTemplateAtIndexPublished:(NSUInteger)index;
- (BOOL) isSelectedTemplatePublished;
- (void) disableButtons;
- (void) enableButtons;
  
- (IBAction)deleteSelectedTemplate;
- (IBAction)copySelectedTemplate;
- (IBAction)editSelectedTemplate;
- (IBAction)createTemplate;


@property (nonatomic, retain) IBOutlet UIViewController *oldTemplateEditorViewController; // TODO: remove
- (IBAction)createTemplateWithOldEditor; // TODO: remove

@end
