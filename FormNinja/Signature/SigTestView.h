//
//  SigTestView.h
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignatureViewController;

@interface SigTestView : UIViewController
{
	SignatureViewController *signatureViewController;
	UIImageView *resultImage;
	UIImageView *resultImageHalfSize;
	UIImageView *resultImageFullSize;
}
@property (nonatomic, retain) IBOutlet SignatureViewController *signatureViewController;
@property (nonatomic, retain) IBOutlet UIImageView *resultImageHalfSize;
@property (nonatomic, retain) IBOutlet UIImageView *resultImageFullSize;

- (IBAction)setResultImage;
- (IBAction)clearSignature;

@end
