//
//  NSDataAddition.h
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSData (Base64)
-(NSData*) initWithBase64String:(NSString*)string;
@end