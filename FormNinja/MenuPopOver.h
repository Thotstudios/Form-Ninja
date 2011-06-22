//
//  MenuPopOver.h
//  FormNinja
//
//  Created by Paul Salazar on 6/10/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuPopOver : UITableViewController {
    NSArray *menuOptions;
    
    int menuType;
    
    int selectedAction;
}


@property (nonatomic, retain) NSArray *menuOptions;
@property (nonatomic) int selectedAction;
@property (nonatomic) int menuType;

@end
