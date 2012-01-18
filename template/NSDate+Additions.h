//
// NSDate+Additions.h
// tvclient
//
// Created by Bryce Redd on 10/7/10.
// Copyright 2010 i.TV LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Additions)

- (NSDate *) dateRoundedDownToHalfHour;
- (NSTimeInterval) value;
- (NSString *) englishString;
- (NSString*) shortEnglishString;

+ (NSDateFormatter*) yearFormatter;
+ (NSDateFormatter*) monthFormatter;
+ (NSDateFormatter *) dateTimeFormatter;
+ (NSDateFormatter *) dateFormatter;
+ (NSDateFormatter*) dayFormatter;
+ (NSDateFormatter *) timeFormatter;
+ (NSDateFormatter *) newsDateTimeFormatter;

+ (NSDate *) dateFromISODateTimeString:(NSString *)string;
+ (NSDate *) dateFromDateTimeString:(NSString *)string;
+ (NSString *) dateTimeStringFromDate:(NSDate *)date;
+ (NSString *) yearStringFromDate:(NSDate *)date;
+ (NSString *) dateStringFromDate:(NSDate *)date;
+ (NSString *) timeStringFromDate:(NSDate *)date;
+ (NSString*)humanTimeStringFromDate:(NSDate*)date;
+ (NSDateFormatter *) timeFormatter;
+ (NSString *) newsDateStringFromDate:(NSDate *)date;
+ (NSTimeInterval) roundedDownToSlot:(NSTimeInterval)date;
+ (NSTimeInterval) nextSlot:(NSTimeInterval)slot;
+ (NSTimeInterval) previousSlot:(NSTimeInterval)slot;
+ (NSTimeInterval) slot:(NSTimeInterval)slot ahead:(NSInteger)slots;

@end
