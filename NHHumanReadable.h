//
//  NHHumanReadable.h
//  FailedBankCD
//
//  Created by Jim Kass on 7/26/12.
//  Copyright (c) 2012 New Hollywood Revolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHHumanReadable : NSObject

+(NSString *)humanReadableTime:(double)seconds;
+(NSString *)humanReadableTime:(double)seconds withAccuracy:(int)accuracy;
+(NSString *)relativeHumanReadableDate:(NSDate *)date;
+(NSString *)relativeHumanReadableDate:(NSDate *)date withAccuracy:(int)accuracy;

@end
