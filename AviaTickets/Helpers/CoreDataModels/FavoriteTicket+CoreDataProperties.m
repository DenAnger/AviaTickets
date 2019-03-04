//
//  FavoriteTicket+CoreDataProperties.m
//  AviaTickets
//
//  Created by Denis Abramov on 04/03/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic returnDate;
@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic flightNumber;

@end
