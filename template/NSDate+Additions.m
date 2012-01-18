//
//  NSDate+Additions.m
//  tvclient
//
//  Created by Bryce Redd on 10/7/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import "NSDate+Additions.h"
#import "NSDate+Utilities.h"
#import "ISO8601DateFormatter.h"

@interface NSDate(Additions_Private) 
+(NSDateFormatter*) dateTimeFormatter;
+(NSDateFormatter*) dateFormatter;
+(NSDateFormatter*) timeFormatter;
+(NSDateFormatter*) humanTimeFormatter;
@end

@implementation NSDate(Additions)

static ISO8601DateFormatter* dateTimeISOFormatter = nil;
static NSDateFormatter* dateTimeFormatter = nil;
static NSDateFormatter* newsDateTimeFormatter = nil;
static NSDateFormatter* dateFormatter = nil;
static NSDateFormatter* timeFormatter = nil;
static NSDateFormatter* humanTimeFormatter = nil;
static NSDateFormatter* weekdayTimeFormatter = nil;
static NSDateFormatter* shortWeekdayTimeFormatter = nil;
static NSDateFormatter* yearFormatter = nil;
static NSDateFormatter* monthFormatter = nil;
static NSDateFormatter* dayFormatter = nil;

+ (void) load {

	@autoreleasepool {
		[self dateTimeFormatter];
		[self dateFormatter];
		[self timeFormatter];
		[self newsDateTimeFormatter];
	}
}

+(ISO8601DateFormatter*) dateTimeISOFormatter {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateTimeISOFormatter = [ISO8601DateFormatter new];
	});
	
	return dateTimeISOFormatter;
}

+(NSDateFormatter*) yearFormatter {
	if(!yearFormatter) {
		yearFormatter = [NSDateFormatter new];
		[yearFormatter setDateFormat:@"yyyy"];
	}
	return yearFormatter;
}

+(NSDateFormatter*) monthFormatter {
	if(!monthFormatter) {
		monthFormatter = [NSDateFormatter new];
		[monthFormatter setDateFormat:@"MMM"];
	}
	return monthFormatter;
}

+(NSDateFormatter*) dateTimeFormatter {
	if(!dateTimeFormatter) {
		dateTimeFormatter = [NSDateFormatter new];
		[dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		[dateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];		
	}
	return dateTimeFormatter;
}

+(NSDateFormatter*) dateFormatter {
	if(!dateFormatter) {
		dateFormatter = [NSDateFormatter new];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];		
	}
	return dateFormatter;
}
+(NSDateFormatter*) timeFormatter {
	if(!timeFormatter) {
		timeFormatter = [NSDateFormatter new];
		[timeFormatter setDateFormat:@"HH:mm"];
		[timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];		
	}
	return timeFormatter;
}
+(NSDateFormatter*) newsDateTimeFormatter {
	if(!newsDateTimeFormatter) {
		newsDateTimeFormatter = [NSDateFormatter new];
		[newsDateTimeFormatter setDateFormat:@"MMM dd"];
		[newsDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];		
	}
	return newsDateTimeFormatter;
}
+(NSDateFormatter*) humanTimeFormatter {
	if(!humanTimeFormatter) {
		humanTimeFormatter = [NSDateFormatter new];
		[humanTimeFormatter setDateFormat:@"h:mm aa"];
		//[humanTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];		
	}
	return humanTimeFormatter;
}
+(NSDateFormatter*) weekdayTimeFormatter {
	if(!weekdayTimeFormatter) {
		weekdayTimeFormatter = [NSDateFormatter new];
		[weekdayTimeFormatter setDateFormat:@"EEEE"];
	}
	return weekdayTimeFormatter;
}
+(NSDateFormatter*) shortWeekdayTimeFormatter {
	if(!shortWeekdayTimeFormatter) {
		shortWeekdayTimeFormatter = [NSDateFormatter new];
		[shortWeekdayTimeFormatter setDateFormat:@"EEE"];
	}
	return shortWeekdayTimeFormatter;
}

+(NSDateFormatter*) dayFormatter {
    if(dayFormatter) {
        dayFormatter = [NSDateFormatter new];
        [dayFormatter setDateFormat:@"dd"];
    }
    return dayFormatter;
}

// uses dateTimeFormatter
+(NSDate*)dateFromDateTimeString:(NSString*)string {
	@synchronized([self dateTimeFormatter]) {
		return [[self dateTimeFormatter] dateFromString:string];
	}
}

+(NSString*)dateTimeStringFromDate:(NSDate*)date {
	@synchronized([self dateTimeFormatter]) {
		return [[self dateTimeFormatter] stringFromDate:date];
	}
}

+ (NSDate *) dateFromISODateTimeString:(NSString *)string {
	@synchronized([self dateTimeISOFormatter]) {
		//NSLog(@"parsing: %@ -> %@", string, [[self dateTimeISOFormatter] dateFromString:string]);
		return [[self dateTimeISOFormatter] dateFromString:string];
	}
}



+ (NSString *)yearStringFromDate:(NSDate *)date {
	@synchronized([self yearFormatter]) {
		return [[self yearFormatter] stringFromDate:date];
	}
}


// uses dateFormatter
+(NSString*)dateStringFromDate:(NSDate*)date {
	@synchronized([self dateFormatter]) {
		return [[self dateFormatter] stringFromDate:date];
	}
}

+(NSString*)newsDateStringFromDate:(NSDate*)date {
	@synchronized([self newsDateTimeFormatter]) {
		return [[self newsDateTimeFormatter] stringFromDate:date];
	}
}


+(NSString*)humanTimeStringFromDate:(NSDate*)date {
	@synchronized([self humanTimeFormatter]) {
		return [[self humanTimeFormatter] stringFromDate:date];
	}
}

// uses timeFormatter
+(NSString*)timeStringFromDate:(NSDate*)date {
	@synchronized([self timeFormatter]) {
		return [[self timeFormatter] stringFromDate:date];
	}
}

+(NSTimeInterval)roundedDownToSlot:(NSTimeInterval)date {
	
	// Force round down to a 30 minute slot. Also make sure 
	// there aren't any sub-seconds on the time interval.
	
	NSTimeInterval seconds = floorl(date);
	NSTimeInterval rounded = seconds - ((int)seconds % ((int)30*60));
	return rounded;
}

+(NSTimeInterval)nextSlot:(NSTimeInterval)slot {
	return [self slot:slot ahead:1];
}

+(NSTimeInterval)previousSlot:(NSTimeInterval)slot {
	return [self slot:slot ahead:-1];
}

+(NSTimeInterval)slot:(NSTimeInterval)slot ahead:(NSInteger)slots {
	
	// If you want to know when something is x slots ahead of where you are
	
	return slot + (slots*30*60);
}

- (NSDate*) dateRoundedDownToHalfHour {
	NSTimeInterval seconds = floorl([self timeIntervalSinceReferenceDate]);
	NSTimeInterval rounded = seconds - ((int)seconds % ((int)30*60));
	return [NSDate dateWithTimeIntervalSinceReferenceDate:rounded];
}

- (NSString*)englishString {
	if([self isToday]) {
		return @"Today";
	}
	if([self isYesterday]) {
		return @"Yesterday";
	}
	if([self isTomorrow]) {
		return @"Tomorrow";
	}
	
	NSString* day = [[NSDate weekdayTimeFormatter] stringFromDate:self];
	
	if([[[NSDate date] dateAtStartOfDay] daysBeforeDate:self] > 6) {
		day = [NSString stringWithFormat:@"Next %@", day];
	} else if ([self isEarlierThanDate:[NSDate date]]) {
		day = [NSString stringWithFormat:@"Last %@", day];
	}
	
	return day;
}

- (NSString*)shortEnglishString {
	if([self isToday]) {
		return @"Today";
	}
	
	NSString* day = [[NSDate shortWeekdayTimeFormatter] stringFromDate:self];
	
	if([[[NSDate date] dateAtStartOfDay] daysBeforeDate:self] > 6) {
		day = [NSString stringWithFormat:@"Next %@", day];
	} else if ([self isEarlierThanDate:[NSDate date]]) {
		day = [NSString stringWithFormat:@"Last %@", day];
	}
	
	return day;
}

// for comparing
-(NSTimeInterval)value {
	return [self timeIntervalSinceReferenceDate];
}

@end
