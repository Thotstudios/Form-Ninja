//
//  TableElement.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/29/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface TableElement : TemplateElement <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *table;
	//NSMutableArray *data;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
//@property (nonatomic, retain) IBOutlet NSMutableArray *data;

- (IBAction)addTableItem;
- (IBAction)toggleEditing;

@end
