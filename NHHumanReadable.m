//
//  NHHumanReadable.m
//  FailedBankCD
//
//  Created by Jim Kass on 7/26/12.
//  Copyright (c) 2012 New Hollywood Revolution. All rights reserved.
//

#import "NHHumanReadable.h"

@implementation NHHumanReadable

NSString *const NOW_STRING = @"seconds ago";

+(NSString *)humanReadableTime:(double)seconds
{
  return [self humanReadableTime:seconds withAccuracy:1];
}

/**
 * human_readable_time - just outputs a human formatted time from the
 * number of seconds supplied.  This is a port from an older PHP
 * function I wrote.
 *
 * @author Jim Kass
 */
+(NSString *)humanReadableTime:(double)seconds withAccuracy:(int) accuracy
{
  NSDictionary *units = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithDouble:floor(abs(seconds) / (60*60*24)%30)], @"months",
                         [NSNumber numberWithDouble:floor(abs(seconds) / (60*60)%24)], @"days",
                         [NSNumber numberWithDouble:floor(abs(seconds) / (60*60))], @"hours",
                         [NSNumber numberWithDouble:floor(abs(seconds) / (60))], @"minutes",
                         nil];
  
  NSMutableArray *parts = [[NSMutableArray alloc] init];
  
  for (NSString __strong *unit in [units allKeys])
  {
    NSNumber *value = [units objectForKey:unit];
  
    if ([value isEqualToNumber:[NSNumber numberWithInt:0]])
    {
      continue;
    }
    
    // make singular
    if ([value isEqualToNumber:[NSNumber numberWithInt:1]])
    {
      // note we need to declare unit strong to do this, so need to clean up after!
      unit = [unit stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"s"]];
    }

    
    [parts addObject:[NSString stringWithFormat:@"%@ %@",value, unit]];
    if ((int)[parts count] == accuracy)
    {
      break;
    }
  }
  units = nil; // prob. not needed

  if ([parts count] == 0) {
    return NOW_STRING;
  }
  return [parts componentsJoinedByString:@", "];  
}


+(NSString *)relativeHumanReadableDate:(NSDate *)date
{
  return [self relativeHumanReadableDate:date withAccuracy:1];
}


+(NSString *)relativeHumanReadableDate:(NSDate *)date withAccuracy:(int)accuracy
{
  NSString *string;
  NSDate *today = [NSDate date];

  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  // we use components so we can have more accurate results
  NSDateComponents *todayComponents = [calendar 
                                  components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) 
                                  fromDate:today];
  
  NSDateComponents *compareComponents = [calendar 
                                       components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) 
                                       fromDate:date];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:calendar.locale];
  [formatter setDateFormat:@"HH:mm"]; 
  if ([[calendar.locale localeIdentifier] isEqual:@"en_US"]) {
    [formatter setDateFormat:@"hh:mma"]; 
  }
  string = [formatter stringFromDate:date];
  
  double start_epoch = [date timeIntervalSince1970];
  double end_epoch   = [today timeIntervalSince1970];
  
  if (compareComponents.day == todayComponents.day)
  {
    // within the last 12 hours
    if (start_epoch >= end_epoch - ((60*60)*12) )
    {
      string = [self humanReadableTime:(end_epoch - start_epoch) withAccuracy:accuracy];
      if ([string isEqualToString:NOW_STRING]) {
        return string;
      }
      return [string stringByAppendingString:@" ago"];
    }
    return string;
  }
  else if (compareComponents.day == (todayComponents.day - 1))
  {
    // strange syntax but appears to work to prepend a string
    // "Yesterday at 10:00 AM"
    return [@"Yesterday at " stringByAppendingString:string];
  }
  else if (compareComponents.week == todayComponents.week) {
    [formatter setDateFormat:@"EEEE "];
    return [[formatter stringFromDate:date] stringByAppendingString:string];
  }
  else if (compareComponents.month == todayComponents.month) {
    string = [self humanReadableTime:(end_epoch - start_epoch) withAccuracy:accuracy];
    return string;
  }
  else if (compareComponents.year == todayComponents.year) {
    [formatter setDateFormat:@"MMMM dd"];
    return [formatter stringFromDate:date];
  }
  else {
    string = [self humanReadableTime:(end_epoch - start_epoch) withAccuracy:1]; // 24 months ago...
    return [string stringByAppendingString:@" ago"];
  }
}

@end
