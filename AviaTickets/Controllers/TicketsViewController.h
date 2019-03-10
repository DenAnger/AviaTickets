//
//  TicketsViewController.h
//  AviaTickets
//
//  Created by Denis Abramov on 20/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end
