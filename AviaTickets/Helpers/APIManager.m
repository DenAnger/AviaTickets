//
//  APIManager.m
//  AviaTickets
//
//  Created by Denis Abramov on 19/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import "APIManager.h"
#import "DataManager.h"
#import "Ticket.h"
#import "PlaceViewController.h"
#import "MainViewController.h"
#import "MapPrice.h"

#define API_TOKEN @"59013ee67128c3be9defe7b2efacb7f0"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="

@implementation APIManager

+ (instancetype)sharedInstance {
	static APIManager *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[APIManager alloc] init];
	});
	return instance;
}

- (void)cityForCurrentIP:(void (^)(City * city))completion {
	[self IPAddressWithCompletion:^(NSString *IpAddress) {
		[self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, IpAddress] withCompletion:^(id _Nullable result) {
			NSDictionary *json = result;
			NSString *iata = [json valueForKey:@"iata"];
			
			if (iata) {
				City *city = [[DataManager sharedInstance] cityForIATA:iata];
				
				if (city) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completion(city);
					});
				}
			}
		}];
	}];
}

- (void)IPAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
	[self load:API_URL_IP_ADDRESS withCompletion:^(id _Nullable result) {
		NSDictionary *json = result;
		completion([json valueForKey:@"ip"]);
	}];
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	});
	[[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		});
		completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
	}]resume];
}

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion {
	NSString *urlString = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery(request), API_TOKEN];
	[self load:urlString withCompletion:^(id  _Nullable result) {
		NSDictionary *response = result;
		
		if (response) {
			NSDictionary *json = [[response valueForKey:@"data"] valueForKey:request.destination];
			NSMutableArray *array = [NSMutableArray new];
			
			for (NSString *key in json) {
				NSDictionary *value = [json valueForKey:key];
				Ticket *ticket = [[Ticket alloc] initWithDictionary:value];
				ticket.from = request.origin;
				ticket.to = request.destination;
				[array addObject:ticket];
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(array);
			});
		}
	}];
}

NSString *SearchRequestQuery(SearchRequest request) {
	NSString *result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destination];
	if (request.departDate && request.returnDate) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM";
		result = [NSString stringWithFormat:@"%@&depart_date=%@&return_date=%@", result, [dateFormatter stringFromDate:request.departDate], [dateFormatter stringFromDate:request.returnDate]];
	}
	return result;
}

- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion {
	static BOOL isLoading;
	if (isLoading) { return; }
	isLoading = YES;
	[self load:[NSString stringWithFormat:@"%@%@", API_URL_MAP_PRICE, origin.code] withCompletion:^(id _Nullable result) {
		NSArray *array = result;
		NSMutableArray *prices = [NSMutableArray new];
		if (array) {
			for (NSDictionary *mapPriceDictionary in array) {
				MapPrice *mapPrice = [[MapPrice alloc] initWithDictionary:mapPriceDictionary withOrigin:origin];
				[prices addObject:mapPrice];
			}
			isLoading = NO;
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(prices);
			});
		}
	}];
}

@end
