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
	UITableView *templateTableView;
	UITableView *groupTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *groupTableView;
@property (nonatomic, retain) NSMutableArray * groupNameList;
@property (nonatomic, retain) NSString * selectedGroupName;

@property (nonatomic, retain) IBOutlet UITableView *templateTableView;
@property (nonatomic, retain) NSMutableArray * templateNameList;
@property (nonatomic, retain) NSMutableArray * templatePathList;
@property (nonatomic, retain) NSString * selectedTemplateName;
@property (nonatomic, retain) NSString * selectedTemplatePath;


- (IBAction)deleteSelectedTemplate;
@end
