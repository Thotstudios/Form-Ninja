//
//  formGroupViewController.h
//  FormNinja
//
//  Created by Programmer on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "formFieldParentViewController.h"

@class formGroupViewController;
@protocol formGroupViewControllerDelegate <NSObject>
@required

-(void) errorCreatingGroup:(formGroupViewController *)group fromField:(formFieldParentViewController *)field withDictionary:(NSDictionary *)dictionary;

@end

@interface formGroupViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UILabel *groupLabel;
@property (nonatomic, retain) NSMutableArray *fieldArray;
@property (nonatomic, retain) NSDictionary *dictValue;

-(void)setByDict:(NSDictionary *) aDict;
-(NSDictionary *)getDictValue;

@end
