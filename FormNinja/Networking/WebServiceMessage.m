//
//  WebServiceMessage.m
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebServiceMessage.h"
#import "WebServiceMessageQueue.h"

@implementation WebServiceMessage
@synthesize messageDelegate;
@synthesize receivedData;
@synthesize queueDelegate;
@synthesize messageError;


-(WebServiceMessage *) init
{
    [super init];
    status=0;
    return self;
}

-(void)processMessage
{
    NSLog(@"WebServiceMessage: processMessage");
    //This class doesn't actually send any messages!  Only it's sub-classes will!
    NSLog(@"Error:  processMessage command sent to WebServiceMessage class (WebServiceMessage.m)");
}

-(void)addToQueue
{
    [[WebServiceMessageQueue sharedInstance] addMessageToQueue:self];
    status=1;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"WebServiceMessage: connectionDidReceiveResponse");
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"WebServiceMessage: connectionDidReceiveData");
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"WebServiceMessage: connectionDidFailWithError");
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [self.receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    //Handle error
    
    self.messageError=[NSError errorWithDomain:@"WebServiceMessage" 
                                          code:0 
                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"There was a connection error connecting to the server", @"NSLocalizedDescriptionKey",
                                                error, @"connectionError",
                                                nil
                                                ]];//The message needs to know about the error so it can be queried at need
    
    NSError *networkError=[NSError errorWithDomain:@"WebServiceMessage" 
                                              code:0 
                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"There was a connection error connecting to the server", @"NSLocalizedDescriptionKey",
                                                    error, @"connectionError",
                                                    self,@"forMessage",
                                                    nil
                                                    ]];//The queue needs to know from which message the error came, which requires an additional dictionary key
    
    [queueDelegate messageError:networkError];
}


-(int) status
{
    return status;
}

@end
