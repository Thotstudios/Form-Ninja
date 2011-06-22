//
//  AccountClass.h
//  FormNinja
//
//  Created by Chad Hatcher on 5/13/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountClass : NSObject
{
    
	NSString * userID;
	NSString * username;
	NSString * passwordHash;
	NSString * firstName;
	NSString * lastName;
	NSString * emailAddress;
	NSString * companyName;
	NSString * phoneNumber;
	NSString * securityQuestion;
	NSString * securityAnswer;
	NSString * zipCode;
	NSString * zipCodeExt;
}

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * passwordHash;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * securityQuestion;
@property (nonatomic, retain) NSString * securityAnswer;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * zipCodeExt;


- (void) saveWithDict:(NSDictionary *) userDict;
- (void) save;
- (void) invalidate;

+ (AccountClass *) sharedAccountClass;
+ (void) logout;
+ (void) invalidateAccountInformation;

@end

/*
 USERID
 USERNAME
 PASSWORD
 FNAME
 LNAME
 EMAIL
 COMPANY
 PHONE NUMBER
 SECURITYQUESTION
 SECURITYANSWER
 ZIPCODE
 ZIPCODEEXT
 
 */