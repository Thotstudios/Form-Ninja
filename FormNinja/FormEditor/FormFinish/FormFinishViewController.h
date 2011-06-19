//
//  FormFinishViewController.h
//  FormNinja
//
//  Created by Ollin on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol FormFinishDelegate <NSObject>

@required
-(void)formFinishConfirmedWithLocation:(BOOL) getLocation;
-(void)formFinishAbort;

@end

@interface FormFinishViewController : UIViewController {

}

@property (nonatomic, assign) id <FormFinishDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *accuracyLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *geoSign;

- (IBAction) abortFinishButtonPressed;
- (IBAction) confirmFinishButtonPressed;

@end
