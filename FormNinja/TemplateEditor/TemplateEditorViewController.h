//
//  TemplateEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "templateGroupViewController.h"


@interface TemplateEditorViewController : UIViewController <UITextFieldDelegate,templateGroupViewControllerDelegate> {
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *templateData, *groupViews;
    BOOL displayKeyboard;
    CGPoint offset;
    IBOutlet UITextField *labelField;
    IBOutlet UIView *templateControlView;
    
    NSString *saveUrl;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSMutableArray *templateData, *groupViews;
@property(nonatomic, retain) IBOutlet UITextField *labelField;
@property(nonatomic, retain) IBOutlet UIView *templateControlView;
@property(nonatomic, retain) NSDictionary *dictValue;

//TEST PROPERTY -- DELETE!
@property(nonatomic, retain) NSDictionary *testDict;

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
//-(void) setTemplateDataWithArray:(NSArray *)newData;

-(NSDictionary *)getDictionaryValue;
-(void)setByDictionary:(NSDictionary *) aDictionary;



-(IBAction) newGroupButtonTouched;
-(IBAction) saveButtonPressed;
-(IBAction) deleteButtonPressed;
-(IBAction) publishButtonPressed;
-(void) redoHeights;

//-(IBAction) testLoadButtonPressed;
//-(IBAction) testSaveButtonPressed;

-(CGPoint) generateAnimationPositionFromFrame:(CGRect) frame;

@end
