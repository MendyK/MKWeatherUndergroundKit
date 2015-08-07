//
//  NSString+Reversal.m
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//
//  Licensed under the MIT license.
#import "NSString+Reversal.h"

@implementation NSString (Reversal)
- (NSString *)mk_reverseString: (NSString *)stringToReverse
{
    NSString *myString = stringToReverse;
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[myString length]];
    
    [myString enumerateSubstringsInRange:NSMakeRange(0,[myString length])
                                 options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                              usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                  [reversedString appendString:substring];
                              }];
    return reversedString;
}

- (double)mk_safeDoubleValue
{
    //To be further implemented
    if (self.length == 0) {
        return 0;
    }
    return [self doubleValue];
}
@end
