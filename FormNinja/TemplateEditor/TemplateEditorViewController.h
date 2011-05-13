//
//  TemplateEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stringFieldViewController.h"


@interface TemplateEditorViewController : UIViewController <UITextFieldDelegate, stringFieldViewControllerDelegate> {
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *templateData, *fieldViews;
    IBOutlet UIButton *addFieldButton;
    BOOL displayKeyboard;
    CGPoint offset;
    IBOutlet UITextField *labelField;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSMutableArray *templateData, *fieldViews;
@property(nonatomic, retain) IBOutlet UIButton *addFieldButton;
@property(nonatomic, retain) IBOutlet UITextField *labelField;

-(IBAction) newFieldButtonTouched;
- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
-(void) setTemplateDataWithArray:(NSMutableArray *)newData;
-(NSArray *) reduceTemplateToArray;

@end
