//
//  main.m
//  BuildIncrementer
//
//  Created by Dima Bart on 2013-10-16.
//  Copyright (c) 2013 Dima Bart. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Functions -
static id BIPlistAtFilepath(NSString *filepath) {
    NSError *error    = nil;
    NSData *plistData =  [NSData dataWithContentsOfFile:filepath options:0 error:&error];
    if (!plistData) {
        NSLog(@"Error reading plist: %@", error.localizedDescription);
        return nil;
    }
    
    NSError *plistError = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainersAndLeaves format:NULL error:&plistError];
    if (!plist) {
        NSLog(@"Error reading plist: %@", plistError.localizedDescription);
    }
    
    return plist;
}

static BOOL BIWritePlistToFilepath(id plist, NSString *filepath) {
    NSError *error    = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if (!plistData) {
        NSLog(@"Error creating plist: %@", error.localizedDescription);
        return NO;
    }
    
    NSError *writeError = nil;
    if (![plistData writeToFile:filepath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Error writing plist: %@", writeError.localizedDescription);
        return NO;
    }
    
    return YES;
}

static NSString * BIIncrementBuildString(NSString *buildString) {
    NSMutableArray *numberComponents = [[buildString componentsSeparatedByString:@"."] mutableCopy];
    NSUInteger components            = [numberComponents count];
    
    int buildNumber                  = [[numberComponents lastObject] intValue];
    NSString *newBuildNumber         = [NSString stringWithFormat:@"%i", ++buildNumber];
    
    [numberComponents replaceObjectAtIndex:components-1 withObject:newBuildNumber];
    return [numberComponents componentsJoinedByString:@"."];
}

#pragma mark - Main -
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 1) return 0; // Exit normally, no arguments provided
        
        const char *filestring = argv[1];
        
        NSString *filePath = [NSString stringWithUTF8String:filestring];
        NSMutableDictionary *plist = BIPlistAtFilepath(filePath);
        if (!plist) {
            return 1;
        }
        
        NSString *currentBuild = [plist objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *newBuild     = BIIncrementBuildString(currentBuild);
        
        [plist setObject:newBuild forKey:(NSString *)kCFBundleVersionKey];
        
        if (!BIWritePlistToFilepath(plist, filePath)) {
            NSLog(@"Failed to increment project property list at path: %s", filestring);
            return 1;
        }
    }
    return 0;
}
