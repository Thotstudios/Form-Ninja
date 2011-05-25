//
//  fieldSelectionViewController.h
//  FormNinja
//
//  Created by Programmer on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class fieldSelectionViewController;
@protocol fieldSelectionViewControllerDelegate <NSObject>
@required

-(void) fieldSelectionCancelButtonPressed:(fieldSelectionViewController *)controller;
-(void) fieldSelectionDidChooseFieldType:(NSString *)fieldType fromController:(fieldSelectionViewController *)controller;

/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
 - (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end

@interface fieldSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
}

@property(nonatomic, retain) NSArray *availableFields;
@property(nonatomic, assign) id <fieldSelectionViewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIPickerView *picker;

-(IBAction) cancelButtonPressed;
-(IBAction) selectButtonPressed;

@end
