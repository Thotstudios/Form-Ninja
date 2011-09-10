//
//  WebServiceLink.m
//  FormNinja
//
//  Created by Programmer on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebServiceLink.h"
#import "RegistrationConnectionHandler.h"
#import "LoginConnectionHandler.h"

@implementation WebServiceLink
@synthesize regDelegate;
@synthesize logDelegate;
@synthesize receivedData;


+(RegistrationConnectionHandler *)registerUserWithDelegate:(id <registrationDelegate>)delegate andUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer
{
    RegistrationConnectionHandler *reg=[[RegistrationConnectionHandler alloc] init];
    [reg setRegDelegate:delegate];
    [reg registerNewUserWithUserName:username andPassword:password andFName:fName andLName:lName andEmail:email andZip:zip andZipExt:zipExt andPhoneNumber:phoneNumber andCompany:company andSecurityQuestion:securityQuestion andSecurityAnswer:securityAnswer];
    return reg;
}

+(LoginConnectionHandler *) loginWithUserName:(NSString *)username andPassword:(NSString *) password withDelegate:(id<loginDelegate>)delegate
{
    LoginConnectionHandler *log=[[LoginConnectionHandler alloc] init];
    [log setLogDelegate:delegate];
    [log loginWithUsername:username andPassword:password];
    return log;
}

/*
-(void)createRequest
{
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
}
*/

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [self.receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    // release the connection, and the data object
    [connection release];
    [self.receivedData release];
}

@end
