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
}

// Interface Elments
@property (nonatomic, retain) IBOutlet UITableView *table;

// Data Members
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic, retain) NSMutableArray * views;

-(void) newTemplateWithName:(NSString*)name group:(NSString*)group;

- (IBAction)addElement;
- (void) stopEditing;
- (void) startEditing;
- (IBAction)toggleEditing;

- (IBAction)dump;
- (IBAction)clear;
- (IBAction)save;

@end
