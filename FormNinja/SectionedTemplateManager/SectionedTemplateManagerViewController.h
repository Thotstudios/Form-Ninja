//
//  SectionedTemplateManagerViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SectionedTemplateManagerViewController : UIViewController {
    
	UIButton *deleteButton;
	UIButton *editButton;
	UIButton *newButton;
}
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) IBOutlet UIButton *newButton;
- (IBAction)pressedDeleteButton;
- (IBAction)pressedEditButton;
- (IBAction)pressedNewButton;

@end
