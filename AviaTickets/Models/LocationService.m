//
//  LocationService.m
//  AviaTickets
//
//  Created by Denis Abramov on 24/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import "LocationService.h"
#import "MapPrice.h"
#import "APIManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationService ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation LocationService

- (instancetype)init {
	self = [super init];
	if (self) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		[_locationManager requestAlwaysAuthorization];
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[_locationManager startUpdatingLocation];
	} else if (status != kCLAuthorizationStatusNotDetermined) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"oops_alert", "Oops!") message:NSLocalizedString(@"not_city_alert", "Not City") preferredStyle: UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close_alert", "Close") style:(UIAlertActionStyleDefault) handler:nil]];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	if (!_currentLocation) {
		_currentLocation = [locations firstObject];
		[_locationManager stopUpdatingHeading];
		[[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
	}
}

@end
