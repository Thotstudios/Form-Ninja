//
//  TemplateManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TemplateEditorController;

@interface TemplateManagerViewController : UIViewController <UIActionSheetDelegate>
{
	UITableView *templateTableView;
	UITableView *groupTableView;
	UIViewController *templateEditorViewController;
	TemplateEditorController *templateEditorB;

	UIButton *deleteButton;
	UIButton *modifyButton;
	UIButton *duplicateButton;
	UIButton *newButton;
	UIViewController *signatureViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *groupTableView;
@property (nonatomic, retain) NSMutableArray * groupNameList;
@property (nonatomic, retain) NSString * selectedGroupName;

@property (nonatomic, retain) IBOutlet UITableView *templateTableView;
@property (nonatomic, retain) NSMutableArray * templateNameList;
@property (nonatomic, retain) NSMutableArray * templatePathList;
@property (nonatomic, retain) NSString * selectedTemplateName;

// Buttons
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIButton *modifyButton;
@property (nonatomic, retain) IBOutlet UIButton *duplicateButton;
@property (nonatomic, retain) IBOutlet UIButton *newButton;
// end Buttons


@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;
@property (nonatomic, retain) IBOutlet TemplateEditorController *templateEditorB;


- (IBAction)deleteSelectedTemplate;
- (IBAction)updateSelectedTemplate;
- (IBAction)duplicateSelectedTemplate;
- (IBAction)createNewTemplate;
- (IBAction)pushTemplateEditorB;

// TODO: Temporary test code.
- (IBAction)testAddTemplateFile;


@end
