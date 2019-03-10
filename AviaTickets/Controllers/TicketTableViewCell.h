//
//  TicketTableViewCell.h
//  AviaTickets
//
//  Created by Denis Abramov on 20/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "FavoriteTicket+CoreDataClass.h"
#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

@end
