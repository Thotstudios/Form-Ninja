//
//  TemplateEditorViewController.h
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateEditorController : UIViewController <UITableViewDelegate, UITableViewDataSource>
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

- (void) newTemplateWithName:(NSString*)name group:(NSString*)group;
- (void) editTemplateAtPath:(NSString*)pathArg;

- (IBAction)save;
- (IBAction)clear;
- (IBAction)addSection;
- (IBAction)toggleEditing;

@end
