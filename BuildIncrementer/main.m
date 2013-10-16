//
//  main.m
//  BuildIncrementer
//
//  Created by Dima Bart on 2013-10-16.
//  Copyright (c) 2013 Dima Bart. All rights reserved.
//

#import <Foundation/Foundation.h>

id plistAtFilepath(NSString *filepath);
BOOL writePlistToFilepath(id plist, NSString *filepath);
NSString *incrementBuildString(NSString *buildString);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 1) return 0; // Exit normally, no arguments provided
        
        const char *filestring = argv[1];
        
        NSString *filePath = [NSString stringWithUTF8String:filestring];
        NSMutableDictionary *plist = plistAtFilepath(filePath);
        if (!plist) {
            return 1;
        }
        
        NSString *currentBuild = [plist objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *newBuild     = incrementBuildString(currentBuild);
        
        [plist setObject:newBuild forKey:(NSString *)kCFBundleVersionKey];
        
        if (!writePlistToFilepath(plist, filePath)) {
            NSLog(@"Failure.");
            return 1;
        } else {
            NSLog(@"Success.");
        }
    }
    return 0;
}

id plistAtFilepath(NSString *filepath) {
    NSLog(@"Reading plist...");
    
    NSError *error = nil;
    NSData *plistData =  [NSData dataWithContentsOfFile:filepath options:0 error:&error];
    if (!plistData) {
        NSLog(@"Error reading plist: %@",error.localizedDescription);
        return nil;
    }
    
    NSError *plistError = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainersAndLeaves format:NULL error:&plistError];
    if (!plist) {
        NSLog(@"Error reading plist: %@",plistError.localizedDescription);
        return nil;
    }
    
    return plist;
}

BOOL writePlistToFilepath(id plist, NSString *filepath) {
    NSLog(@"Writing plist...");
    
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if (!plistData) {
        NSLog(@"Error creating plist: %@",error.localizedDescription);
        return NO;
    }
    
    NSError *writeError = nil;
    if (![plistData writeToFile:filepath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Error writing plist: %@",writeError.localizedDescription);
        return NO;
    }
    
    return YES;
}

NSString *incrementBuildString(NSString *buildString) {
    NSLog(@"Current build version: %@",buildString);
    
    NSMutableArray *numberComponents = [[buildString componentsSeparatedByString:@"."] mutableCopy];
    NSUInteger components = [numberComponents count];
    
    int number = [[numberComponents lastObject] intValue];
    NSString *newBuildNumber = [NSString stringWithFormat:@"%i",++number];
    [numberComponents replaceObjectAtIndex:components-1 withObject:newBuildNumber];
    
    NSString *newBuild = [numberComponents componentsJoinedByString:@"."];
    NSLog(@"New build version:     %@",newBuild);
    
    return newBuild;
}

//        // Regex version
//        NSLog(@"Opening file: %@",filePath);
//
//        NSError *error = nil;
//        NSMutableString *fileContents = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//        if (!fileContents) {
//            NSLog(@"Error, no file contents: %@",error.localizedDescription);
//            return 1;
//        } else {
//            NSLog(@"Reading file...");
//        }
//
//        NSError *regexError = nil;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<key>CFBundleVersion</key>.+?<string>(.+?)</string>" options:NSRegularExpressionDotMatchesLineSeparators error:&regexError];
//        if (!regex) {
//            NSLog(@"Error: %@",regexError.localizedDescription);
//            return 1;
//        } else {
//            NSLog(@"Parsing regex...");
//        }
//
//        [regex enumerateMatchesInString:fileContents options:0 range:NSMakeRange(0, fileContents.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//            NSUInteger captures = [result numberOfRanges];
//            if (captures > 0) {
//                NSRange captureRange = [result rangeAtIndex:1];
//                NSString *buildNumber = [fileContents substringWithRange:captureRange];
//                NSLog(@"Current build version: %@",buildNumber);
//
//                NSMutableArray *numberComponents = [[buildNumber componentsSeparatedByString:@"."] mutableCopy];
//                NSUInteger components = [numberComponents count];
//
//                int number = [[numberComponents lastObject] intValue];
//                NSString *newBuildNumber = [NSString stringWithFormat:@"%i",++number];
//                [numberComponents replaceObjectAtIndex:components-1 withObject:newBuildNumber];
//
//                NSString *finalVersionString = [numberComponents componentsJoinedByString:@"."];
//                NSLog(@"New build version:     %@",finalVersionString);
//                [fileContents replaceCharactersInRange:captureRange withString:finalVersionString];
//
//                NSLog(@"Incremented version number.");
//                NSLog(@"Writing file...");
//
//                NSError *error = nil;
//                if (![fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
//                    NSLog(@"Failed to write file: %@",error.localizedDescription);
//                    return;
//                } else {
//                    NSLog(@"Success!");
//                    return;
//                }
//            } else {
//                NSLog(@"No regex captures. Increment failed.");
//                return;
//            }
//        }];

