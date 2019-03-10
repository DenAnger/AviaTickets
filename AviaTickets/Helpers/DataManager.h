//
//  DataManager.h
//  AviaTickets
//
//  Created by Denis Abramov on 07/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Airport.h"
#import "City.h"
#import "Country.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeAirport,
    DataSourceTypeCity,
    DataSourceTypeCountry
} DataSourceType;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;

@property (nonatomic, strong, readonly) NSArray *airports;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *countries;

- (City *)cityForIATA:(NSString *) iata;
- (City *)cityForLocation:(CLLocation *) location;

@end
