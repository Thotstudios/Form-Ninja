//
//  formFieldParentViewController.h
//  FormNinja
//
//  Created by Programmer on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class formFieldParentViewController;
@protocol formFieldParentViewControllerDelegate <NSObject>
@required

-(void) errorCreatingField:(formFieldParentViewController *)field withDictionary:(NSDictionary *)dictionary;
-(void) setByDictCalledForParentField:(formFieldParentViewController *)field WithDictionary:(NSDictionary *)aDict;
-(void) getDictCalledForParentField:(formFieldParentViewController *)field;

@end

@interface formFieldParentViewController : UIViewController {
    
}

@property (nonatomic, assign) id <formFieldParentViewControllerDelegate> delegate;

-(formFieldParentViewController *) allocFieldFromDictionary:(NSDictionary *)dictionary;

-(void)setByDict:(NSDictionary *) aDict;
-(NSDictionary *)getDictValue;

@end
