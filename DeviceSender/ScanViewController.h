//
//  ScanViewController.h
//  DeviceSender
//
//  Created by Laur Neagu on 07/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol ScanViewControllerDelegate;

@interface ScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL touchToFocusEnabled;

- (BOOL) isCameraAvailable;
- (void) startScanning;
- (void) stopScanning;
- (void) setTorch:(BOOL) aStatus;

@end


@protocol ScanViewControllerDelegate <NSObject>

@optional

- (void) scanViewController:(ScanViewController *) aCtler didTapToFocusOnPoint:(CGPoint) aPoint;
- (void) scanViewController:(ScanViewController *) aCtler didSuccessfullyScan:(NSString *) aScannedValue;

@end