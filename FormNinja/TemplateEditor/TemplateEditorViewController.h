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
    IBOutlet UIButton *addFieldButton, *saveButton, *publishButton, *deleteButton;
    BOOL displayKeyboard;
    CGPoint offset;
    IBOutlet UITextField *labelField;
    
    NSArray *testArray;//TEMPORARY PROPERTY, NOT BACKED BY @PROPERTY!
    
    NSString *saveUrl;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSMutableArray *templateData, *fieldViews;
@property(nonatomic, retain) IBOutlet UIButton *addFieldButton, *saveButton, *publishButton, *deleteButton;
@property(nonatomic, retain) IBOutlet UITextField *labelField;

-(IBAction) newFieldButtonTouched;
- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
-(void) setTemplateDataWithArray:(NSArray *)newData;
-(NSArray *) reduceTemplateToArray;
-(IBAction) saveButtonPressed;
-(IBAction) deleteButtonPressed;
-(IBAction) publishButtonPressed;

-(IBAction) testLoadButtonPressed;
-(IBAction) testSaveButtonPressed;



@end
