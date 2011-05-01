//
//  Form_NinjaAppDelegate.h
//  Form Ninja
//
//  Created by Hackenslacker on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Form_NinjaViewController;

@interface Form_NinjaAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Form_NinjaViewController *viewController;

@end
