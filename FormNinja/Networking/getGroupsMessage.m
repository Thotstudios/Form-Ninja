//
//  getGroupsMessage.m
//  FormNinja
//
//  Created by Programmer on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "getGroupsMessage.h"
#import "Constants.h"
#import "JSON.h"
#import "WebServiceMessage.h"


@implementation GetGroupsMessage
@synthesize groupsDelegate;

+(GetGroupsMessage *)getGroupsWithDelegate:(id<GetGroupsMessageDelegate,MessageDelegate>)delegate
{
    GetGroupsMessage *message=[[GetGroupsMessage alloc] init];
    message.messageDelegate=delegate;
    message.groupsDelegate=delegate;
//    message.queueDelegate=[WebServiceMessage
    [message addToQueue];
    return message;
}

-(void)processMessageWithUserToken:(NSString *)userToken andPassToken:(NSString *)passToken
{
    if (userToken==nil || passToken==nil) {
        //throw error
        NSLog(@"GetGroupsMessage.m processMessageWithUserToken:  tokens were nil!");
        [self.queueDelegate messageRequiresLogin:self];
        
        [self.messageDelegate messageRequiresLogin:self];
        status=5;
    }
    else
    {
        
    }
}

@end
