//
//  SigTestView.h
//  FormNinja
//
//  Created by Hackenslacker on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignatureView;

@interface SigTestView : UIViewController
{
	SignatureView *signatureView;
	UIImageView *resultImage;
	UIImageView *resultImageHalfSize;
	UIImageView *resultImageFullSize;
}
@property (nonatomic, retain) IBOutlet SignatureView *signatureView;
@property (nonatomic, retain) IBOutlet UIImageView *resultImageHalfSize;
@property (nonatomic, retain) IBOutlet UIImageView *resultImageFullSize;

- (IBAction)setResultImage;
- (IBAction)clearSignature;
- (IBAction)getSignature;

@end
