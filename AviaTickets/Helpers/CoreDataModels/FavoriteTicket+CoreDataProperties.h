//
//  FavoriteTicket+CoreDataProperties.h
//  AviaTickets
//
//  Created by Denis Abramov on 04/03/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataClass.h"

@interface FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) int64_t price;
@property (nonatomic) int16_t flightNumber;

@end
