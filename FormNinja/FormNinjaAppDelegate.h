//
//  FormNinjaAppDelegate.h
//  FormNinja
//
//  Created by Paul Salazar on 4/30/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class FormNinjaLoginViewController;

@interface FormNinjaAppDelegate : NSObject <UIApplicationDelegate> {

	UINavigationController *_navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet FormNinjaLoginViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
