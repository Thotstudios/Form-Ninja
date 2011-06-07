//
//  SyncManager.m
//  FormNinja
//
//  Created by Ollin on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SyncManager.h"
#import "AccountClass.h"
#import "JSON.h"

@implementation SyncManager

@synthesize userID, delegate;



#pragma mark - Instance Methods

- init {
    self = [super init];
    
    if (self) {
        self.userID = [AccountClass sharedAccountClass].userID;
    }
    
    return self;
}


//Syncs template to db
- (void) syncTemplate:(NSMutableArray *) array{
    //Convert nsdate object to string as json cannot parse nsdate objects
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:0]] autorelease];
    [dict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"creation date"]] forKey:@"creation date"];
    
    NSMutableArray *dbArray = [[[NSMutableArray alloc] initWithArray:array] autorelease];
    [dbArray removeObjectAtIndex:0];
    [dbArray insertObject:dict atIndex:0];
    
    //Get json string
    //TODO: add image support
    NSString *dbData = [dbArray JSONRepresentation]; 
    NSLog(@"committing %@", dbData);
}



#pragma mark - Dealloc

- (void)dealloc{
    [userID release];
    
    [super dealloc];
}


@end
