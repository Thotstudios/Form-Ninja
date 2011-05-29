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
	NSMutableArray * elementTypes;
    id callback;
	SEL selector;
	UITableView * table;
	float frameHeight;
	float frameYPosition;
	UIDeviceOrientation orientation;
}

//@property (retain, nonatomic) UIAlertView * alert;
@property (retain, nonatomic) id callback;
@property SEL selector;

@property (nonatomic, retain) UITableView * table;

//@property (retain, nonatomic) NSString * type;
@property (retain, nonatomic) NSMutableArray * elementTypes;

-(id) initWithDelegate:(id)delegateArg selector:(SEL)selectorArg;

// Class Methods:
+(TemplateElement*) elementOfType:(NSString*)arg;
+(void) registerTemplateElement:(id)className name:(NSString*)name;

@end
