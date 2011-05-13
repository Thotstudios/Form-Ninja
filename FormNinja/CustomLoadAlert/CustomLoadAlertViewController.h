//
//  CustomLoadAlertViewController.h
//  iPlace HD
//
//  Created by Ollin on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 Custom load alert is meant to cover the entire view and display a alert label and activity indicator.
 This class is mainly used to notify users of backend work/initialization and prevent them from doing any
 possbile harmful action.
*/
@interface CustomLoadAlertViewController : UIViewController {
	UILabel *alertLabel; //Label displayed while load alert is visible onscreen
	UIActivityIndicatorView *activityIndicator;
}


@property (nonatomic, retain) IBOutlet UILabel *alertLabel; 
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator; 


- (void) startActivityIndicator;
- (void) stopActivityIndicator;


@end
