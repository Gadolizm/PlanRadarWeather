//
//  WeatherAPIClient.h
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// Minimal Objective-C network client (spec requirement).
@interface WeatherAPIClient : NSObject
+ (instancetype)shared;

/// Fetch raw JSON for a city from OpenWeather (HTTPS).
/// Reads OPENWEATHER_API_KEY from Info.plist.
/// - completion: (data, response, error) — HTTP handling is left to Swift wrapper.
- (void)fetchWeatherForCity:(NSString *)city
                 completion:(void (^)(NSData * _Nullable data,
                                      NSURLResponse * _Nullable response,
                                      NSError  * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END