	//
//  WebServiceLink.h
//  FormNinja
//
//  Created by Programmer on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RegistrationConnectionHandler.h"
@class RegistrationConnectionHandler;
@class LoginConnectionHandler;

@protocol registrationDelegate
@required
- (void)registrationReturnedWithResult:(BOOL) result andErrors:(NSDictionary *)errors;//if result is false, then registration failed and errors is an array of the error keys:
/*
 Possible Registration Errors from server:
 
 usernameExists
 usernameInvalid
 passwordMismatch
 passwordInvalid
 emailExists
 emailInvalid
 zipInvalid
 phoneNumberInvalid
 
 Additionally, you may get the following value if there was an error with the connection
 unableToCreateConnection
 connectionError
 
 */
@end

@protocol loginDelegate

-(void) loginSucceeded;
-(void) loginFailedWithErrors:(NSDictionary *)errors;

@end

@interface WebServiceLink : NSObject {
}

@property(assign) id <registrationDelegate> regDelegate;
@property(assign) id <loginDelegate> logDelegate;
@property(nonatomic, retain) NSMutableData *receivedData;

+(RegistrationConnectionHandler *)registerUserWithDelegate:(id <registrationDelegate>) delegate andUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer;

+(LoginConnectionHandler *) loginWithUserName:(NSString *)username andPassword:(NSString *) password withDelegate:(id <loginDelegate>) delegate;

@end
