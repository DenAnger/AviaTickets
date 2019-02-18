//
//  City.m
//  AviaTickets
//
//  Created by Denis Abramov on 07/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import "City.h"

@implementation City

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"coutry_code"];
        _code = [dictionary valueForKey:@"code"];
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}

@end
