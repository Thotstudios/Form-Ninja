//
//  FormEditorViewController.h
//  FormNinja
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class formGroupViewController;
@class formFieldParentViewController;

@class FormEditorViewController;
@protocol FormEditorViewControllerDelegate <NSObject>
@required

-(void) errorCreatingForm:(FormEditorViewController *)form fromGroup:(formGroupViewController *)group fromField:(formFieldParentViewController *)field withDictionary:(NSDictionary *)dictionary;

@end

@interface FormEditorViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UILabel *templateLabel, *formLabel, *timeLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSDictionary *dictValue;
@property (nonatomic, retain) NSMutableArray *fieldGroups;
@property (nonatomic, assign) id <FormEditorViewControllerDelegate> delegate;

-(void) rearrangeGroups;

-(void)setByDict:(NSDictionary *) aDict;
-(NSDictionary *)getDictValue;

@end
