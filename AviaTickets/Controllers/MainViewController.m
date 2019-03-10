//
//  MainViewController.m
//  AviaTickets
//
//  Created by Denis Abramov on 07/02/2019.
//  Copyright © 2019 Denis Abramov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "APIManager.h"
#import "TicketsViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>
@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic,strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = NSLocalizedString(@"search_btn", "Search");
    
    _placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 200.0, [UIScreen mainScreen].bounds.size.width - 40.0, 180.0)];
    _placeContainerView.backgroundColor = [UIColor whiteColor];
    _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    _placeContainerView.layer.shadowOffset = CGSizeZero;
    _placeContainerView.layer.shadowRadius = 20.0;
    _placeContainerView.layer.shadowOpacity = 1.0;
    _placeContainerView.layer.cornerRadius = 8.0;
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:NSLocalizedString(@"departure_place", "Departire place") forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(20.0, 20.0, [UIScreen mainScreen].bounds.size.width - 80.0, 60.0);
    [_departureButton.layer setCornerRadius:8.0];
    _departureButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:7 animations:^{
        [self.departureButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
    }];
    [self.placeContainerView addSubview:_departureButton];
    
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:NSLocalizedString(@"arrive_place", "Arrive place") forState:UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(20.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 80.0, 60.0);
    [_arrivalButton.layer setCornerRadius:8.0];
    _arrivalButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:5 animations:^{
        [self.arrivalButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
    }];
    [self.placeContainerView addSubview:_arrivalButton];
    
    [self.view addSubview:_placeContainerView];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:NSLocalizedString(@"search_btn", "Search") forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _searchButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    _searchButton.layer.cornerRadius = 8.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.view addSubview:_searchButton];
   
    [UIView animateWithDuration:3 animations:^{
        [self.searchButton setBackgroundColor:[UIColor blackColor]];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)searchButtonDidTap:(UIButton *)sender {
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alas_alert", "Alas!") message:NSLocalizedString(@"not_ticket_alert", "not ticket") preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close_alert", "Close") style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController:placeViewController animated:YES];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton: _arrivalButton];
}
- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.code;
    }
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destination = iata;
    }
    [button setTitle: title forState:UIControlStateNormal];
}

@end
