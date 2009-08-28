#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#include <Foundation/Foundation.h>
#import <Foundation/NSDebug.h> 


#import "FB2File.h"

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    NSZombieEnabled = YES;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // Load template HTML
    NSMutableString *templateFile = [NSMutableString stringWithContentsOfFile:[[NSBundle bundleWithIdentifier: @"com.bluezbox.fictionbook2ql"]
                                                                 pathForResource:@"fb2preview" ofType:@"html"]];

    NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
    // attach Images
    CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
    NSMutableDictionary *attachments = [NSMutableDictionary dictionary];
    NSMutableDictionary *imgProps;

    NSXMLDocument *_xmlDoc = openFB2File((NSURL *)url);

    if (_xmlDoc == nil)    {
        [pool release];
        [props release];
        return noErr;
    }
    
    NSMutableArray *authors = getAuthors(_xmlDoc);
    NSString *title = getTitle(_xmlDoc);
    FBBinary *coverImage = getCoverPage(_xmlDoc);
    NSMutableString *author;
    NSString *coverImageName;

    if (title == nil)
        title = @"Unknown title";

    if ([authors count] == 0) {
        author = @"Unknown author";
    }
    else {
        for(NSString *author in authors) {
            NSLog(@"Author: %@", author);
        }
    }

    // get cover page
    if (coverImage) {
        imgProps = [[NSMutableDictionary alloc] init];
        [imgProps setObject:[coverImage data] forKey:(NSString *)kQLPreviewPropertyAttachmentDataKey];
        [attachments setObject:imgProps forKey:[coverImage xID]];
        [imgProps release];
        coverImageName = [coverImage xID];
    }
    else {
        NSURL *imgURL = (NSURL *)CFBundleCopyResourceURL(bundle, (CFStringRef)@"book", CFSTR("png"), NULL);

        if (imgURL) {
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            if (imgData) {
                imgProps = [[NSMutableDictionary alloc] init];
                [imgProps setObject:imgData forKey:(NSString *)kQLPreviewPropertyAttachmentDataKey];
                [attachments setObject:imgProps forKey:[@"book" stringByAppendingPathExtension:@"png"]];
                [imgProps release];
            }

            [imgURL release];
            coverImageName = [NSString stringWithString:@"book.png"];
        }
    }

    [templateFile replaceOccurrencesOfString:@"{COVER}" 
                                  withString:coverImageName 
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [templateFile length])];
    

    NSMutableString *authorsHTML = [[NSMutableString alloc] init];
    for (NSString *author in authors) {
        [authorsHTML appendFormat:@"<h2>%@</h2>", author];
    }

    [templateFile replaceOccurrencesOfString:@"{AUTHORS}" 
                                  withString:authorsHTML 
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [templateFile length])];
    
    [authorsHTML release];
    
    [templateFile replaceOccurrencesOfString:@"{TITLE}" 
                                  withString:title 
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [templateFile length])];
    
    CFDataRef data = (CFDataRef)[templateFile dataUsingEncoding:NSUTF8StringEncoding];
    
    [props setObject:[NSNumber numberWithInt:400] forKey:(NSString *)kQLPreviewPropertyWidthKey];
    [props setObject:[NSNumber numberWithInt:600] forKey:(NSString *)kQLPreviewPropertyHeightKey];
    [props setObject:title forKey:(NSString *)kQLPreviewPropertyDisplayNameKey];
    [props setObject:attachments forKey:(NSString *)kQLPreviewPropertyAttachmentsKey];
    QLPreviewRequestSetDataRepresentation(preview, data, kUTTypeHTML, (CFDictionaryRef) props);
    
    [props release];
    closeFB2File(_xmlDoc);
    [pool release];

    return noErr;
}


void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
