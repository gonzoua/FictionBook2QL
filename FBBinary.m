//
//  FBBinary.m
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "FBBinary.h"
#import "NSXMLNodeAddition.h"
#import "NSDataAddition.h"

@implementation FBBinary

-(id) initWithXMLNode:(NSXMLNode*)node
{
    [super init];
    
    [self setXID:[node stringForXPath:@"./@id" error:nil]];
    [self setContentType:[node stringForXPath:@"./@content-type" error:nil]];
    data = [[NSData alloc] initWithBase64String:[node stringValue]];
    
    return self;
}

-(void) dealloc
{
    [data release];
    [super dealloc];
}

-(NSData*) data
{
    return [NSData dataWithData:data];
}

@synthesize xID;
@synthesize contentType;

@end
