//
//  NSDataAddition.m
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "NSDataAddition.h"

@implementation NSData (Base64)
-(NSData*) initWithBase64String:(NSString*)string
{
    NSMutableData *data;
    NSData *origData;
    const unsigned char *origBytes;
    int origLength, ptr;
    BOOL eodata = NO;
    int bitsInInt;
    unsigned int outInt = 0;
    
    origData = [string dataUsingEncoding:NSASCIIStringEncoding];
    origBytes = [origData bytes];
    origLength = [origData length];
    data = [NSMutableData dataWithCapacity:(origLength*3/4 + 1)];
    ptr = 0;
    
    bitsInInt = 0;
    while (ptr < origLength) {
        unsigned char bits;
        unsigned char c = origBytes[ptr++];
        if ((c >= 'A') && (c <= 'Z'))
            bits = c - 'A';
        else if ((c >= 'a') && (c <= 'z'))
            bits = c - 'a' + 26;
        else if (isdigit(c))
            bits = c - '0' + 52;
        else if (c == '+')
            bits = 62;
        else if (c == '/')
            bits = 63;
        else if (c == '=')
            eodata = YES;
        else
            continue;
        
        if (eodata)
            break;

        outInt = (outInt << 6) | bits;
        bitsInInt += 6;
        if (bitsInInt >= 8) {
            unsigned char outByte = (outInt >> (bitsInInt - 8)) & 0xff;
            [data appendBytes:&outByte length:1];
            bitsInInt -= 8;
        }
    }
    
    self = [self initWithData:data];
    return self;
}

@end