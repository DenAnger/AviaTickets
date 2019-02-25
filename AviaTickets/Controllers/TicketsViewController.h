//
//  TicketsViewController.h
//  AviaTickets
//
//  Created by Denis Abramov on 20/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;

@end

NS_ASSUME_NONNULL_END
