//
//  LoginMessage.h
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceMessage.h"

@protocol LoginMessageDelegate

-(void)loginSuccessful;
-(void)loginFailedWithError:(NSError *) error;

@end

@interface LoginMessage : WebServiceMessage {
    /*
     RegistrationMessage error domain codes:
     0:  Unable to create connection
     1:  Server rejected connection
     */   
}

@property (nonatomic, assign) id <LoginMessageDelegate> loginDelegate;
@property (nonatomic, retain) NSString *username, *password;

+(LoginMessage *) loginWithUsername:(NSString *)username andPassword:(NSString *)password withDelegate:(id <LoginMessageDelegate, MessageDelegate>) delegate;

@end
