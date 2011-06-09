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
}

// Interface Elments
@property (nonatomic, retain) IBOutlet UITableView *table;

// Data Members
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) NSMutableArray * viewArray;

- (void) newTemplateWithName:(NSString*)name group:(NSString*)group;

- (IBAction)save;
- (IBAction)clear;
- (IBAction)addSection;
- (IBAction)toggleEditing;

// TODO: temporary
- (IBAction)dump;

@end
