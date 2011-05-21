//
//  FormManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FormManagerViewController : UIViewController
{
    
	UIViewController *formEditorViewController;
}
@property (nonatomic, retain) IBOutlet UIViewController *formEditorViewController;
- (IBAction)newFormWithSelectedTemplate;

@end
