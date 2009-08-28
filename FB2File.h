//
//  FB2File.h
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FBBinary.h"
#import "NSXMLNodeAddition.h"

NSXMLDocument *openFB2File(NSURL *furl);
void closeFB2File(NSXMLDocument *);
NSMutableArray * getAuthors(NSXMLDocument *_xmlDoc);
NSString *getTitle(NSXMLDocument *_xmlDoc);
FBBinary *getCoverPage(NSXMLDocument *_xmlDoc);

