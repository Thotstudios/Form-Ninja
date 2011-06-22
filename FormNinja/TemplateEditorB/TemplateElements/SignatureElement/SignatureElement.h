//
//  SignatureElement.h
//  Dev
//
//  Created by Chad Hatcher on 5/26/11.
//  Copyright 2011 Thot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TemplateElement.h"

@interface SignatureElement : TemplateElement
{
	UIButton *requestButton;
	UIButton *confirmButton;
	UIImageView *imageView;
}
@property (nonatomic, retain) IBOutlet UIButton *requestButton;
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
- (IBAction)requestSignature;
- (IBAction)confirmSignature;
-(void) success:(UIImage*)image;

@end
