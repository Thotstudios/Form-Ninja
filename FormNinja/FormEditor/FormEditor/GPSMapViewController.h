//
//  GPSMapViewController.h
//  FormNinja
//
//  Created by Paul Salazar on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPSMapViewController : UIViewController {
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityView;
    NSString *sigCoordinates;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSString *sigCoordinates;


-(IBAction) closeButtonAction;


@end
