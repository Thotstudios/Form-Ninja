//
//  ParentElement.h
//  Dev
//
//  Created by Hackenslacker on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateElement : UIViewController <UITextFieldDelegate>
{
	id delegate;
	NSMutableDictionary * dictionary;
	UITextField *labelField;
	UISegmentedControl *labelAlignmentControl;
	int index;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableDictionary * dictionary;
@property (nonatomic, retain) IBOutlet UITextField *labelField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *labelAlignmentControl;

- (IBAction)segmentedControlValueDidChange:(UISegmentedControl*)segmentedControl;
- (IBAction)reset;
- (void)setDictionary:(NSMutableDictionary*)arg;
- (void)setIndex:(int)arg;
- (void) editNextElement;

@end
