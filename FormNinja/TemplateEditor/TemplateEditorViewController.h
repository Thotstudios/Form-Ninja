//
//  TemplateEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stringFieldViewController.h"


@interface TemplateEditorViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *templateData, *fieldViews;
    IBOutlet UIButton *addFieldButton;
}

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) NSMutableArray *templateData, *fieldViews;
@property(nonatomic, retain) IBOutlet UIButton *addFieldButton;

-(IBAction) newFieldButtonTouched;

@end
