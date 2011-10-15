//
//  RegistrationMessage.m
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegistrationMessage.h"
#import "WebServiceMessage.h"
#import "Constants.h"
#import "JSON.h"
#import "WebServiceMessageQueue.h"

@implementation RegistrationMessage
@synthesize regDelegate;
@synthesize username, password, fname, lname, email, zipExt, zip, phoneNumber, securityAnswer, securityQuestion, company;



-(void)processMessageWithUserToken:(NSString *)userToken andPassToken:(NSString *)passToken
{
    NSLog(@"RegistrationMessage: process message");
    //as documented at:  https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html%23//apple_ref/doc/uid/20001836-170129
	
	//create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseWebServiceUrl,registerUserUrl]]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	//create the post data for the request
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&password2=%@&fname=%@&lname=%@&email=%@&zip=%@&zipext=%@&phoneNumber=%@&company=%@&securityQuestion=%@&securityAnswer=%@",self.username, self.password, self.password, self.fname, self.lname, self.email, self.zip, self.zipExt, self.phoneNumber, self.company, self.securityQuestion, self.securityAnswer];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	//tell the request to use POST method and use the post data
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPBody:postData];	
	
	//create the connection with the request and start loading the data
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(theConnection){
		//Create the NSMutableData to hold the received data
		//received data is an instance variable declared elsewhere
		self.receivedData=[NSMutableData data] ;
        status=2;
	}
	else {
        status=4;
		[self.regDelegate registrationFailedWithError:[NSError errorWithDomain:@"RegistrationMessage" code:0 userInfo:
                                                       [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"Unable to generate connection", @"NSLocalizedDescriptionKey",
                                                        nil
                                                        ]]];
        
		[self.queueDelegate messageError:[NSError errorWithDomain:@"RegistrationMessage" code:0 userInfo:
                                                       [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"Unable to generate connection", @"NSLocalizedDescriptionKey",
                                                        self,@"forMessage",
                                                        nil
                                                        ]]];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Registration message: connectionDidFinishLoading");
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    //NSString *HTMLCode=[[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
	//NSDictionary *jsonDict = [[request responseString] JSONValue]; 
    
    NSString *response=[[NSString alloc] initWithBytes:[self.receivedData bytes] length:[self.receivedData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Received response: %@", response);
    NSDictionary *responseDictionary = [response JSONValue];
    // release the connection, and the data object
    bool success=([(NSString *)[responseDictionary valueForKey:@"registered"] isEqualToString:@"true"]);
    NSLog(@"%@", [responseDictionary valueForKey:@"registered"]);
    if(!success)
    {
        status=4;
        [self.regDelegate registrationFailedWithError:[NSError errorWithDomain:@"RegistrationMessage" 
                                                                          code:1 
                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                @"Server rejected registration", @"NSLocalizedDescriptionKey",
                                                                                responseDictionary, @"serverResponse",
                                                                                nil
                                                                                ]]];
        [self.queueDelegate messageError:[NSError errorWithDomain:@"RegistrationMessage" 
                                                                          code:1 
                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                @"Server rejected registration", @"NSLocalizedDescriptionKey",
                                                                                responseDictionary, @"serverResponse",
                                                                                self, @"forMessage",
                                                                                nil
                                                                                ]]];
        //[self.regDelegate registrationReturnedWithResult:true andErrors:[responseDictionary objectForKey:@"error"]];
    }
    else
    {
        [self.regDelegate registrationSuccessful];
        [self.queueDelegate messageFinishedSuccessfully:self];
    }
    [connection release];
    self.receivedData=nil;
    status=3;
}



+(RegistrationMessage *)registerNewUserWithUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer andDelegate:(id <RegistrationMessageDelegate, MessageDelegate>)delegate;
{
    NSLog(@"RegistrationMessage:registerNewUser");
    /*RegistrationMessage *message=[[RegistrationMessage alloc] init];
    [message registerNewUserWithUserName:username andPassword:password andFName:fName andLName:lName andEmail:email andZip:zip andZipExt:zipExt andPhoneNumber:phoneNumber andCompany:company andSecurityQuestion:securityQuestion andSecurityAnswer:securityAnswer andDelegate:delegate] ;
    [message autorelease];*/
    RegistrationMessage *message=[[RegistrationMessage alloc] init];
    
    message.username=username;
    message.password=password;
    message.fname=fName;
    message.lname=lName;
    message.email=email;
    message.zip=zip;
    message.zipExt=zipExt;
    message.phoneNumber=phoneNumber;
    message.company=company;
    message.securityQuestion=securityQuestion;
    message.securityAnswer=securityAnswer;
    
    message.regDelegate=delegate;
    message.messageDelegate=delegate;
    
    [message addToQueue];
    [message autorelease];
    
    return message;
}

@end
