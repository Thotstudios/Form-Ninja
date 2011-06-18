//
//  ParentElement.h
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface TemplateElement : UIViewController <UITextFieldDelegate>
{
	id delegate;
	NSMutableDictionary * dictionary;
	BOOL allowEditing;
	UITextField *labelField;
	UISegmentedControl *labelAlignmentControl;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableDictionary * dictionary;
@property BOOL allowEditing;
@property (nonatomic, retain) IBOutlet UITextField *labelField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *labelAlignmentControl;

- (void)setDictionary:(NSMutableDictionary*)arg;
- (void) editNextElement;

- (NSIndexPath *) indexPath;
-(BOOL) isValid;

- (IBAction)reset;
- (IBAction)moveUp;
- (IBAction)moveDown;
- (IBAction)addRow;
- (IBAction)deleteRow;
- (IBAction)segmentedControlValueDidChange:(UISegmentedControl*)segmentedControl;

@end
