//
//  main.m
//  FormNinja
//
//  Created by Ollin on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "FileWriter.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if(USE_DEMONSTRATION_FILES)
		[FileWriter installDemoFiles];
	
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
