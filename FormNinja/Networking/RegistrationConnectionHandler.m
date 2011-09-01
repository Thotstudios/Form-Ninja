//
//  RegistrationConnectionHandler.m
//  FormNinja
//
//  Created by Programmer on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegistrationConnectionHandler.h"
#import "Constants.h"
#import "JSON.h"


@implementation RegistrationConnectionHandler


-(void)registerNewUserWithUserName:(NSString *) username andPassword:(NSString *) password andFName:(NSString *)fName andLName:(NSString *)lName andEmail:(NSString *)email andZip:(NSString *)zip andZipExt:(NSString *)zipExt andPhoneNumber:(NSString *)phoneNumber andCompany:(NSString *)company andSecurityQuestion:(NSString *)securityQuestion andSecurityAnswer:(NSString *)securityAnswer
{
    //as documented at:  https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html%23//apple_ref/doc/uid/20001836-170129
	
	//create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseWebServiceUrl,registerUserUrl]]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	//create the post data for the request
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&password2=%@&fname=%@&lname=%@&email=%@&zip=%@&zipext=%@&phoneNumber=%@&company=%@&securityQuestion=%@&securityAnswer=%@",username, password, password, fName, lName, email, zip, zipExt, phoneNumber, company, securityQuestion, securityAnswer];
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
    // release the connection, and the data object
    bool success=([(NSString *)[responseDictionary valueForKey:@"registered"] isEqualToString:@"true"]);
    if(success)
    {
        [self.regDelegate registrationReturnedWithResult:true andErrors:[responseDictionary objectForKey:@"error"]];
    }
    else
    {
        [self.regDelegate registrationReturnedWithResult:false andErrors:Nil];
    }
    [connection release];
    [self.receivedData release];
}

@end
