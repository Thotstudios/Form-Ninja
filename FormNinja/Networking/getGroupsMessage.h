//
//  getGroupsMessage.h
//  FormNinja
//
//  Created by Programmer on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceMessage.h"
#import "Constants.h"

@protocol GetGroupsMessageDelegate

-(void)gotGroups:(NSArray *)groups;
-(void)getGroupsFailedWithError:(NSError *) error;

@end

@interface GetGroupsMessage : WebServiceMessage {
    
}

@property (nonatomic, assign) id <GetGroupsMessageDelegate> groupsDelegate;

+(GetGroupsMessage *)getGroupsWithDelegate:(id <GetGroupsMessageDelegate, MessageDelegate>)delegate;

@end
