//
//  TemplateManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateManagerViewController : UIViewController
{
	UITableView *templateTableView;
	UITableView *groupTableView;
	UIViewController *templateEditorViewController;

	UIButton *deleteButton;
	UIButton *modifyButton;
	UIButton *duplicateButton;
	UIButton *newButton;
}

@property (nonatomic, retain) IBOutlet UITableView *groupTableView;
@property (nonatomic, retain) NSMutableArray * groupNameList;
@property (nonatomic, retain) NSString * selectedGroupName;

@property (nonatomic, retain) IBOutlet UITableView *templateTableView;
@property (nonatomic, retain) NSMutableArray * templateNameList;
@property (nonatomic, retain) NSMutableArray * templatePathList;
@property (nonatomic, retain) NSString * selectedTemplateName;
@property (nonatomic, retain) NSString * selectedTemplatePath;

// Buttons
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIButton *modifyButton;
@property (nonatomic, retain) IBOutlet UIButton *duplicateButton;
@property (nonatomic, retain) IBOutlet UIButton *newButton;
// end Buttons


@property (nonatomic, retain) IBOutlet UIViewController *templateEditorViewController;


- (IBAction)deleteSelectedTemplate;
- (IBAction)modifySelectedTemplate;
- (IBAction)duplicateSelectedTemplate;
- (IBAction)createNewTemplate;

// TODO: Temporary test code.
- (IBAction)testAddTemplateFile;

@end
