HumanReadable
==================

Objective-C Class with utility functions for "human readable" numbers and dates.
Sample:

```objc
NSDate *myDate = [NSDate date];
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
fmt setDateFormat:@"yyyy-MM-DD"];
myDate = [fmt dateFromString:@"2012-07-26"];

NSLog(@"%@",[NHHumanReadable relativeHumanReadableDate:myDate]);
// will print something like... "5 days ago" or "1 month, 5 days ago", or "Wednesday 5:12PM", etc.

```