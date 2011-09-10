//
//  LoginConnectionHandler.m
//  FormNinja
//
//  Created by Programmer on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginConnectionHandler.h"
#import "Constants.h"
#import "JSON.h"


@implementation LoginConnectionHandler

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *) password
{
    //as documented at:  https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html%23//apple_ref/doc/uid/20001836-170129
	
	//create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseWebServiceUrl,loginUserUrl]]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	//create the post data for the request
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",username, password];
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
		[self.regDelegate registrationReturnedWithResult:false andErrors:[NSArray arrayWithObject:[NSString stringWithFormat:@"unableToCreateConnection"]]];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    //NSString *HTMLCode=[[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
	//NSDictionary *jsonDict = [[request responseString] JSONValue]; 
    
    NSString *response=[[NSString alloc] initWithBytes:[self.receivedData bytes] length:[self.receivedData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Received response: %@", response);
    NSDictionary *responseDictionary = [response JSONValue];
    bool success=([(NSString *)[responseDictionary valueForKey:@"accepted"] isEqualToString:@"True"]);
    if(success)
    {
        [self.logDelegate loginSucceeded];
    }
    else
    {
        [self.logDelegate loginFailedWithErrors:[responseDictionary valueForKey:@"error"]];
    }
         
    
    // release the connection, and the data object
    [connection release];
    [self.receivedData release];
}

@end
