//
//  FBBinary.h
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FBBinary : NSObject {
    NSString *xID;
    NSString *contentType;
    NSData *data;
}


-(id) initWithXMLNode:(NSXMLNode*)node;
-(void) dealloc;
-(NSData*) data;

@property(readwrite, copy) NSString *xID;
@property(readwrite, copy) NSString *contentType;

@end
