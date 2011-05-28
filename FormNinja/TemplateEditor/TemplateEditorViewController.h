//
//  TemplateEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "templateGroupViewController.h"

@class TemplateEditorViewController;
@protocol TemplateEditorViewControllerDelegate <NSObject>
@optional

-(void) publishButtonPressed:(TemplateEditorViewController *)editor;
-(void) saveButtonPressed:(TemplateEditorViewController *)editor;
-(void) deleteButtonPressed:(TemplateEditorViewController *)editor;


/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
 - (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end

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
@property(nonatomic, retain) id <TemplateEditorViewControllerDelegate> delegate;

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up;
//-(void) setTemplateDataWithArray:(NSArray *)newData;

-(NSDictionary *)getDictionaryValue;
-(void)setByDictionary:(NSDictionary *) aDictionary;



-(IBAction) newGroupButtonTouched;
-(IBAction) saveButtonPressed;
-(IBAction) deleteButtonPressed;
-(IBAction) publishButtonPressed;
-(void) redoHeightsAnimated:(bool) animated;

//-(IBAction) testLoadButtonPressed;
//-(IBAction) testSaveButtonPressed;

-(CGPoint) generateAnimationPositionFromFrame:(CGRect) frame;

@end
