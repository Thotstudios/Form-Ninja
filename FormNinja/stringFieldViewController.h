//
//  stringFieldViewController.h
//  FormNinja
//
//  Created by Programmer on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class stringFieldViewController;
@protocol stringFieldViewControllerDelegate <NSObject>
@required

/*- (BOOL)foo:(Foo *)foo willDoSomethingAnimated:(BOOL)flag;
- (void)foo:(Foo *)foo didDoSomethingAnimated:(BOOL)flag;*/
@end

@interface stringFieldViewController : UIViewController {
    id <stringFieldViewControllerDelegate> delegate;
    IBOutlet UISlider *minLengthSlider, *maxLengthSlider;
    IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
    IBOutlet UITextField *fieldNameTextField;
}

@property (nonatomic, retain) IBOutlet UISlider *minLengthSlider, *maxLengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *minLengthLabel, *maxLengthLabel;
@property (nonatomic, retain) IBOutlet UITextField *fieldNameTextField;
@property (nonatomic, assign) id <stringFieldViewControllerDelegate> delegate;

-(IBAction) changeTypeButtonPressed;
-(IBAction) removeButtonPressed;

@end
