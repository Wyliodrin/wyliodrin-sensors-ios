//
//  QRCode.m
//  DeviceSender
//
//  Created by Laur Neagu on 07/05/15.
//  Copyright (c) 2015 Laur Neagu. All rights reserved.
//

#import "QRCode.h"


static NSString* _qrCode = nil;

@implementation QRCode
+(void)load {
    _qrCode = [[NSString alloc] init];
}

+(NSString*)qrCode {
    return _qrCode;
}

+(void)setQRCode:(NSString*)givenQR{
    _qrCode = givenQR;
}
@end

