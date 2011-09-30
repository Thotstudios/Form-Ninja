//
//  WebServiceMessage.h
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebServiceMessage;
@protocol QueueDelegate
@required
-(void)messageFinishedSuccessfully:(WebServiceMessage *)message;
-(void)messageError:(NSError *)error;

@end

@protocol MessageDelegate

-(void)messageError:(NSError *)messageError;

@end

@interface WebServiceMessage : NSObject {
    
    int status;//0=Forming message, 1=Waiting in queue, 2=processing (message sent, awaiting reply), 3=finished, ready for deallocation, 4=error
}

@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, assign) id <QueueDelegate> queueDelegate;
@property(nonatomic, assign) id <MessageDelegate> messageDelegate;
@property(nonatomic, retain) NSError *messageError;

-(void)processMessage;
-(int) status;
-(void)addToQueue;

@end
