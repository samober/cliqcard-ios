//
//  ISO8601DateValueTransformer.m
//  CliqCard
//
//  Created by Sam Ober on 6/14/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISO8601DateValueTransformer.h"

@implementation ISO8601DateValueTransformer

    + (Class)transformedValueClass {
        return [NSDate class];
    }
    
    + (BOOL)allowsReverseTransformation {
        return NO;
    }
    
    - (id)transformedValue:(id)value {
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
            formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierISO8601];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            
            return [formatter dateFromString:value];
        }
        return nil;
    }

@end
