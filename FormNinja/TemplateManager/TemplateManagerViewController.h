//
//  TemplateManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateManagerViewController : UIViewController
{
	UITableViewController *groupTableViewController;
	UITableViewController *templateTableViewController;
}
@property (nonatomic, retain) IBOutlet UITableViewController *groupTableViewController;
@property (nonatomic, retain) IBOutlet UITableViewController *templateTableViewController;

@end
