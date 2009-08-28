//
//  FB2File.m
//  FictionBook2QL
//
//  Created by Oleksandr Tymoshenko on 17/08/09.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "FB2File.h"


NSXMLDocument *openFB2File(NSURL *furl)
{
    NSXMLDocument *_xmlDoc = nil;
    NSError *err = nil;
    
    _xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
                                                   options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                     error:&err];    
    if (_xmlDoc == nil) {
        _xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
                                                       options:NSXMLDocumentTidyXML
                                                         error:&err];
    }
    
    return _xmlDoc;
}

void closeFB2File(NSXMLDocument *_xmlDoc)
{
    [_xmlDoc release];
}


NSMutableArray * getAuthors(NSXMLDocument *_xmlDoc)
{
    NSMutableArray *authors = [NSMutableArray array];
    NSArray *nodes = [_xmlDoc nodesForXPath:@"./FictionBook/description/title-info/author"
                                      error:nil];
    for(NSXMLNode *authorNode in nodes) {
        NSString *firstName = [authorNode stringForXPath:@"./first-name" error:nil];
        NSString *middleName = [authorNode stringForXPath:@"./middle-name" error:nil];
        NSString *lastName = [authorNode stringForXPath:@"./last-name" error:nil];
        NSString *nickname = [authorNode stringForXPath:@"./nickname" error:nil];
        NSMutableString *author = [NSMutableString string];
        if (firstName)
            [author appendString:firstName];
        if (middleName && [middleName length])
            [author appendFormat:@" %@", middleName];
        if (nickname && [nickname length])
            [author appendFormat:@" \"%@\"", nickname];
        if (lastName && [lastName length])
            [author appendFormat:@" %@", lastName];

        [authors addObject:author];
    }

    return authors;
}

NSString *getTitle(NSXMLDocument *_xmlDoc)
{
    NSArray *nodes = [_xmlDoc nodesForXPath:@"./FictionBook/description/title-info/book-title"
                             error:nil];    

    if ([nodes count] != 1)
        return nil;

    return [[nodes objectAtIndex:0] stringValue];
} 

FBBinary *getCoverPage(NSXMLDocument *_xmlDoc)
{
    NSMutableString *coverpage = nil;
    NSArray *nodes = [_xmlDoc nodesForXPath:@"./FictionBook/description/title-info/coverpage/image" 
                             error:nil];

    if ([nodes count]) {
        coverpage = [NSMutableString 
                     stringWithString:[[[nodes objectAtIndex:0] 
                                            attributeForName:@"l:href"] stringValue]];
        // strip # prefix
        NSRange range;
        range.location = 0;
        range.length = 1;
        [coverpage deleteCharactersInRange:range];    
    }
    else
        return nil;
 
    //
    //  Now, let's load binaries
    //
    nodes = [_xmlDoc nodesForXPath:@"./FictionBook/binary"
                             error:nil];

    for (NSXMLNode *node in nodes) {
        FBBinary *binary = [[FBBinary alloc] initWithXMLNode:node];

        if ([[binary xID] isEqualToString:coverpage])
            return [binary autorelease];

        [binary release];
    }

    return nil;
} 
