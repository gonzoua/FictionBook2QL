//
//  NSXMLNodeAddition.m
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "NSXMLNodeAddition.h"

@implementation NSXMLNode (oneChildXPath)

-(NSString *) stringForXPath:(NSString*)xpath error:(NSError**)error
{
    NSArray *nodes = [self nodesForXPath:xpath error:error];
    NSAssert([nodes count] <= 1, @"Bad count of elements in author node");
    if ([nodes count])
        return [[nodes objectAtIndex:0] stringValue];
    else
        return nil;
}

@end
