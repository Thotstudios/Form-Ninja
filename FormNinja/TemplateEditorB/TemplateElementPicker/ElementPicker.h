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
	UITableView * table;
    id callback;
	SEL selector;
	
	float tableWidth;
	float tableHeight;
	float horizontalMargin;
	
	NSMutableArray * elementList;
}

@property (nonatomic, retain) UITableView * table;
@property (nonatomic, retain) id callback;
@property SEL selector;
@property (nonatomic, retain) NSMutableArray * elementList;

-(id) initWithDelegate:(id)delegateArg selector:(SEL)selectorArg;

// Class Methods:
+(TemplateElement*) elementOfType:(NSString*)arg delegate:(id)delegate;

@end
