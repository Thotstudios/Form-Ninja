//
//  SyncManager.h
//  FormNinja
//
//  Created by Ollin on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncDelgate;


@interface SyncManager : NSObject {
    NSString* userID;
    
    //Add protocol delegate
	id <SyncDelgate> delegate;
}


@property (nonatomic, retain) NSString *userID;

@property (nonatomic, assign) id <SyncDelgate> delegate;


- (void) syncTemplate:(NSMutableArray *) array;

@end


//Sync protocol
@protocol SyncDelgate <NSObject>

- (void) syncDidSucceed;
- (void) syncDidFailWithError:(int) error;

@end