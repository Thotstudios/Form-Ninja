//
//  TemplateEditorViewController.h
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateEditorController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
	UITableView *table;
	NSMutableArray * dataArray;
	NSMutableArray * viewArray;
	NSString * path;
}

// Interface Elments
@property (nonatomic, retain) IBOutlet UITableView *table;

// Data Members
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) NSMutableArray * viewArray;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) IBOutlet UIButton *addButton, *arrangeButton, *clearButton, *saveButton;

- (void) newTemplateWithName:(NSString*)name group:(NSString*)group;
- (void) editTemplateAtPath:(NSString*)pathArg;
-(void) generateViewArray;

- (IBAction)save;
- (IBAction)clear;
- (IBAction)addSection;
- (IBAction)toggleEditing;

@end
