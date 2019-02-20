//
//  MainViewController.h
//  AviaTickets
//
//  Created by Denis Abramov on 07/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destination;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface MainViewController : UIViewController


@end

