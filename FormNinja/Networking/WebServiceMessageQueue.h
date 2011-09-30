//
//  WebServiceMessageQueue.h
//  FormNinja
//
//  Created by Programmer on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceMessage.h"

@interface WebServiceMessageQueue : NSObject <QueueDelegate> {
    int queueStatus;//Should be a private variable, not set except from inside queue.  NOT THREAD SAFE
                    //0:  Empty - no messages present
                    //1:  Processing Queue
                    //2:  Queue Paused (currently unused)
                    //3:  Error:  Queue Paused
}

@property (nonatomic, retain) NSMutableArray *messageQueue;
@property (nonatomic, retain) NSError *error;

+(id)sharedInstance;
-(int)queueStatus;
-(void)processNextMessage;
-(void)resumeProcessingQueue;
-(void)addMessageToQueue:(WebServiceMessage *) message;
-(BOOL)removeMessageFromQueue:(WebServiceMessage *)message;


@end
