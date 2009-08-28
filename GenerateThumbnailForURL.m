#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#include <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "FB2File.h"

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    NSImage *coverImage = nil;
    FBBinary *coverBinary = nil;
    
    if (QLThumbnailRequestIsCancelled(thumbnail))
        return noErr;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSXMLDocument *_xmlDoc = openFB2File((NSURL *)url);
    if (_xmlDoc == nil) {
        [pool release];
        return noErr;
    }
    
    coverBinary = getCoverPage(_xmlDoc);

    if (coverBinary)
        coverImage = [[NSImage alloc] initWithData:[coverBinary data]];

    if (coverImage == nil) {
        CFBundleRef bundle = QLThumbnailRequestGetGeneratorBundle(thumbnail);
        NSURL *imgURL = (NSURL *)CFBundleCopyResourceURL(bundle, (CFStringRef)@"book", CFSTR("png"), NULL);      
        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
    
        coverImage = [[NSImage alloc] initWithData:imgData];
    }

    if (coverImage) {
        NSData *data = [coverImage TIFFRepresentation];
        QLThumbnailRequestSetImageWithData(thumbnail, (CFDataRef)data, NULL);
        
    }

    [coverImage release];
    closeFB2File(_xmlDoc);

    [pool release];
    
    return noErr;
}


void CancelThumbnailGeneration(void* thisInterface, QLThumbnailRequestRef thumbnail)
{
    // implement only if supported
}