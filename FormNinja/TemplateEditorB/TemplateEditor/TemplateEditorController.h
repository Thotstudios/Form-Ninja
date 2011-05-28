//
//  TemplateEditorViewController.h
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateEditorController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
	UITableView *table;
	UITextField *headerTextField;
	UIView *headerView;
	UIView *footerView;
}

@property (retain) id templateNameField;

// Interface Elments
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextField *headerTextField;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *footerView;

// Data Members
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic, retain) NSMutableArray * views;

@property (nonatomic, retain) id alert;

- (IBAction)addElement;
- (void) stopEditing;
- (void) startEditing;
- (IBAction)toggleEditing;

- (IBAction)dump;
- (IBAction)clear;
- (IBAction)save;

@end
