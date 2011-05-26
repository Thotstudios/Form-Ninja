//
//  formStringFieldViewController.h
//  FormNinja
//
//  Created by Programmer on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "formFieldParentViewController.h"

@interface formStringFieldViewController : UIViewController <UITextFieldDelegate>{
    
}

@property (nonatomic, assign) id <formFieldParentViewControllerDelegate> delegate;

//Data
@property (nonatomic, retain) NSDictionary *dictValue;
@property (nonatomic, assign) NSInteger minLength, maxLength;

//UI
@property (nonatomic, retain) IBOutlet UILabel *fieldLabel, *minChars, *maxChars;
@property (nonatomic, retain) IBOutlet UITextField *fieldText;
@property (nonatomic, retain) IBOutlet UIButton *indicator;

-(IBAction) indicatorButtonPressed;

-(void)setByDict:(NSDictionary *) aDict;
-(NSDictionary *)getDictValue;

@end
