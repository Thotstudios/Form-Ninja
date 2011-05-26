//
//  templateGroupViewController.h
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parentFieldViewController.h"
#import "fieldSelectionViewController.h"

@class templateGroupViewController;
@protocol templateGroupViewControllerDelegate <NSObject>
@required

-(void) removeGroupButtonPressed:(templateGroupViewController *)group;
-(void) addGroupButtonPressed:(templateGroupViewController *)group;
-(void) moveGroupUpButtonPressed:(templateGroupViewController *)group;
-(void) moveGroupDownButtonPressed:(templateGroupViewController *)group;
-(void) changedHeightForGroup:(templateGroupViewController *) group;

/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
 - (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end

@interface templateGroupViewController : UIViewController <parentFieldViewControllerDelegate, fieldSelectionViewControllerDelegate> {
    
}

@property(nonatomic, retain) IBOutlet UIView *bottomControlsView;
@property(nonatomic, retain) IBOutlet UITextField *groupLabel;
@property(nonatomic, retain) NSMutableArray *fieldViewControllers;
@property(nonatomic, retain) id <templateGroupViewControllerDelegate> delegate;
@property(nonatomic, retain) NSDictionary *dictValue;

-(void) redoHeights;

-(NSDictionary *) getDictionaryData;
-(void)setByDictionary:(NSDictionary *) aDictionary;

-(IBAction) moveGroupUpButtonPressed;
-(IBAction) moveGroupDownButtonPressed;
-(IBAction) addGroupButtonPressed;
-(IBAction) addFieldButtonPressed;
-(IBAction) removeGroupButtonPressed;



@end
