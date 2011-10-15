//
//  LoginMessage.m
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginMessage.h"
#import "Constants.h"
#import "JSON.h"
#import "WebServiceMessage.h"

@implementation LoginMessage
@synthesize loginDelegate;
@synthesize username, password;

-(void)processMessageWithUserToken:(NSString *)userToken andPassToken:(NSString *)passToken
{
    //as documented at:  https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html%23//apple_ref/doc/uid/20001836-170129
	
	//create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseWebServiceUrl,loginUserUrl]]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	//create the post data for the request
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",self.username, self.password];
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
		self.receivedData=[NSMutableData alloc];
	}
	else {
        status=4;
        [self.loginDelegate loginFailedWithError:[NSError errorWithDomain:@"LoginMessage" code:0 userInfo:
                                                       [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"Unable to generate connection", @"NSLocalizedDescriptionKey",
                                                        nil
                                                        ]]];
        
		[self.queueDelegate messageError:[NSError errorWithDomain:@"LoginMessage" code:0 userInfo:
                                          [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Unable to generate connection", @"NSLocalizedDescriptionKey",
                                           self,@"forMessage",
                                           nil
                                           ]]];
		//[self.regDelegate registrationReturnedWithResult:false andErrors:[NSArray arrayWithObject:[NSString stringWithFormat:@"unableToCreateConnection"]]];
	}
    
    /*
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(theConnection){
		//Create the NSMutableData to hold the received data
		//received data is an instance variable declared elsewhere
		self.receivedData=[NSMutableData data] ;
	}
	else {
		
	}*/
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
    bool success=([(NSString *)[responseDictionary valueForKey:@"accepted"] isEqualToString:@"true"]);
    NSLog(@"%@", [responseDictionary valueForKey:@"accepted"]);
    if(!success)
    {
        status=4;
        [self.loginDelegate loginFailedWithError:[NSError errorWithDomain:@"LoginMessage" 
                                                                          code:1 
                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                @"Server rejected login", @"NSLocalizedDescriptionKey",
                                                                                responseDictionary, @"serverResponse",
                                                                                nil
                                                                                ]]];
        [self.queueDelegate messageError:[NSError errorWithDomain:@"LoginMessage" 
                                                             code:1 
                                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   @"Server rejected login", @"NSLocalizedDescriptionKey",
                                                                   responseDictionary, @"serverResponse",
                                                                   self, @"forMessage",
                                                                   nil
                                                                   ]]];
        //[self.regDelegate registrationReturnedWithResult:true andErrors:[responseDictionary objectForKey:@"error"]];
    }
    else
    {
        [self.loginDelegate loginSuccessful];
        
        [self.queueDelegate messageGaveUsernameToken:(NSString *)[responseDictionary valueForKey:@"userKey"] 
                                       passwordToken:(NSString *)[responseDictionary valueForKey:@"passKey"] 
                                            withTime:[NSDate dateWithTimeIntervalSinceNow:((int)[responseDictionary valueForKey:@"days"]*24*60*60)]];

        [self.queueDelegate messageFinishedSuccessfully:self];
    }
    [connection release];
    [self.receivedData release];
}

+(LoginMessage *) loginWithUsername:(NSString *)username andPassword:(NSString *)password withDelegate:(id <LoginMessageDelegate, MessageDelegate>) delegate
{
    NSLog(@"LoginMessage: loginWithUser");
    /*RegistrationMessage *message=[[RegistrationMessage alloc] init];
     [message registerNewUserWithUserName:username andPassword:password andFName:fName andLName:lName andEmail:email andZip:zip andZipExt:zipExt andPhoneNumber:phoneNumber andCompany:company andSecurityQuestion:securityQuestion andSecurityAnswer:securityAnswer andDelegate:delegate] ;
     [message autorelease];*/
    LoginMessage *message=[[LoginMessage alloc] init];
    
    message.username=username;
    message.password=password;
    
    message.loginDelegate=delegate;
    message.messageDelegate=delegate;
    
    [message addToQueue];
    [message autorelease];
    
    return message;
}

@end
