//
//  TemplateEditorViewController.h
//  Dev
//
//  Created by Chad Hatcher on 5/21/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateEditorController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
	UITableView *table;
	UIButton *publishButton;
	NSMutableArray * dataArray;
	NSMutableArray * viewArray;
	NSString * path;
}

// Interface Elments
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton *publishButton;

// Data Members
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) NSMutableArray * viewArray;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) IBOutlet UIButton *addButton, *arrangeButton, *clearButton, *saveButton;

- (void) newTemplateWithName:(NSString*)name group:(NSString*)group;
- (void) editTemplateAtPath:(NSString*)pathArg;
-(void) generateViewArray;

- (IBAction)save;
- (IBAction)pressedPublish;
- (IBAction)addSection;
- (IBAction)toggleEditing;

@end
