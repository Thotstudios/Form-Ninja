//
//  SyncManager.h
//  FormNinja
//
//  Created by Paul Salazar on 6/6/11.
//  Copyright 2011 Thot Studios. All rights reserved.
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


+ (SyncManager *) sharedSyncManager;

- (NSString *) formatTemplate:(NSMutableArray *) array;
- (void) addTemplateToSyncList:(NSMutableArray *) dataArray;

- (void) saveList;


@end


//Sync protocol
@protocol SyncDelgate <NSObject>

- (void) syncDidSucceed;
- (void) syncDidFailWithError:(int) error;

@end