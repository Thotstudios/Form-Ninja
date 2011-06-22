//
//  FileWriter.m
//  FormNinja
//
//  Created by Chad Hatcher on 6/20/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import "FileWriter.h"
#import "Constants.h"

@implementation FileWriter

+(void) installDemoTemplateName:(NSString*)name
{
	NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString * fromPath = [NSString stringWithFormat:@"%@/%@", resourcePath, name];
	NSString * toPath = [NSString stringWithFormat:@"%@/%@", TEMPLATE_PATH, name];
	[[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
}

+(void) installDemoFormName:(NSString*)name
{
	NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString * fromPath = [NSString stringWithFormat:@"%@/%@", resourcePath, name];
	NSString * toPath = [NSString stringWithFormat:@"%@/%@", FORM_PATH, name];
	[[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
}

+(void) installDemoFiles
{
	if(!USE_DEMONSTRATION_FILES) return;
	
	[FileWriter installDemoTemplateName:@"Demonstration-W-2.xml"];
	[FileWriter installDemoTemplateName:@"Demonstration-Customer Evaluation.xml"];
	
	[FileWriter installDemoFormName:@"Demonstration-Customer Evaluation-Thot Studios-Customer Evaluation-1308608473.xml"];
}

@end
