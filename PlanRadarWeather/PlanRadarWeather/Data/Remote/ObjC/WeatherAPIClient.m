//
//  WeatherAPIClient.m
//  PlanRadarWeather
//
//  Created by Haitham Gado on 11/10/2025.
//


#import "WeatherAPIClient.h"

@implementation WeatherAPIClient

+ (instancetype)shared {
    static WeatherAPIClient *s; static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [WeatherAPIClient new]; });
    return s;
}

- (void)fetchWeatherForCity:(NSString *)city
                 completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {

    NSString *apiKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"OPENWEATHER_API_KEY"];
    if (apiKey.length == 0) {
        NSError *e = [NSError errorWithDomain:@"WeatherAPIClient"
                                         code:-1
                                     userInfo:@{NSLocalizedDescriptionKey:
                                                @"Missing OPENWEATHER_API_KEY in Info.plist"}];
        completion(nil, nil, e);
        return;
    }

    NSString *encoded = [city stringByAddingPercentEncodingWithAllowedCharacters:
                         [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:
        @"https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@",
        encoded, apiKey];

    NSURL *url = [NSURL URLWithString:urlStr];

    // Default session is fine for this assessment (no custom config needed).
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:completion] resume];
}
@end