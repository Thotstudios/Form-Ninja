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

@interface WebServiceLink : NSObject {
}

@property(assign) id <registrationDelegate> regDelegate;
@property(nonatomic, retain) NSMutableData *receivedData;

+(RegistrationConnectionHandler *)registerUserWithDelegate:(id <registrationDelegate>) delegate andUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer;

@end
