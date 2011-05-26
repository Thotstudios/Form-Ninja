//
//  stringFieldViewController.h
//  FormNinja
//
//  Created by Programmer on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parentFieldViewController.h"


@interface stringFieldViewController : parentFieldViewController <UITextFieldDelegate> {
    id <parentFieldViewControllerDelegate> delegate;
    IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
    IBOutlet UITextField *fieldNameTextField, *minLengthTextField, *maxLengthTextField;
    
}


@property (nonatomic, retain) IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
@property (nonatomic, retain) IBOutlet UITextField *fieldNameTextField, *minLengthTextField, *maxLengthTextField;
@property (nonatomic, assign) id <parentFieldViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDictionary *dictValue;

-(void)setByDictionary:(NSDictionary *) aDictionary;
-(NSDictionary *) getDictionaryData;

//UI functionality
-(IBAction) removeButtonPressed;
-(IBAction) addButtonPressed;
-(IBAction) moveUpButtonPressed;
-(IBAction) moveDownButtonPressed;


@end