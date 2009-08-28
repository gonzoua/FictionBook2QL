//
//  NSXMLNodeAddition.h
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSXMLNode (oneChildXPath)
-(NSString *) stringForXPath:(NSString*)xpath error:(NSError**)error;
@end
