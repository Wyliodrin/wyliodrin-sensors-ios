//
//  QRCode.h
//  DeviceSender
//
//  Created by Laur Neagu on 07/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCode : NSObject 
+(void)load;
+(NSString*)qrCode;
+(void)setQRCode:(NSString*)givenQR;
@end