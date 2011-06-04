//
//  TableElementPicker.h
//  Dev
//
//  Created by Hackenslacker on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateElement;

@interface ElementPicker : UIAlertView <UITableViewDelegate, UITableViewDataSource>
{
	UIDeviceOrientation orientation;
	
	NSMutableArray * elementList;
	UITableView * table;
    id callback;
	SEL selector;
}

@property (nonatomic, retain) NSMutableArray * elementList;
@property (nonatomic, retain) UITableView * table;
@property (nonatomic, retain) id callback;
@property SEL selector;

-(id) initWithDelegate:(id)delegateArg selector:(SEL)selectorArg;

// Class Methods:
+(TemplateElement*) elementOfType:(NSString*)arg;

@end
