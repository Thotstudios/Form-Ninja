//
//  SyncManager.m
//  FormNinja
//
//  Created by Ollin on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SyncManager.h"
#import "AccountClass.h"

@implementation SyncManager

@synthesize userID;



#pragma mark - Instance Methods

- init {
    self = [super init];
    
    if (self) {
        self.userID = [AccountClass sharedAccountClass].userID;
    }
    
    return self;
}



#pragma mark - Dealloc

- (void)dealloc{
    [userID release];
    
    [super dealloc];
}


@end
