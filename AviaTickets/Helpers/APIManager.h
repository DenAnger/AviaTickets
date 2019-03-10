//
//  APIManager.h
//  AviaTickets
//
//  Created by Denis Abramov on 19/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "MainViewController.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void(^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end
