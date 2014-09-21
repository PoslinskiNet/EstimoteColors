//
//  ViewController.m
//  EstimoteColors
//
//  Created by Dawid Pośliński on 21.09.2014.
//  Copyright (c) 2014 Dawid Pośliński @Generio. All rights reserved.
//

#import "ViewController.h"

#define EstimoteR = @"1234"
#define EstimoteG = @"1234"
#define EstimoteB = @"1234"

@interface ViewController () {
	float redColor;
	float greenColor;
	float blueColor;
	NSString *beaconName1;
	NSString *beaconName2;
	NSString *beaconName3;
}

@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	redColor = 0;
	greenColor = 0;
	blueColor = 0;
	
	self.beaconManager = [[ESTBeaconManager alloc] init];
	self.beaconManager.delegate = self;
	
	/*
	 * Creates sample region object (you can additionaly pass major / minor values).
	 *
	 * We specify it using only the ESTIMOTE_PROXIMITY_UUID because we want to discover all
	 * hardware beacons with Estimote's proximty UUID.
	 */
	self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
													  identifier:@"EstimoteSampleRegion"];
	
	/*
	 * Starts looking for Estimote beacons.
	 * All callbacks will be delivered to beaconManager delegate.
	 */
	if (self.scanType == ESTScanTypeBeacon)
	{
		[self.beaconManager startRangingBeaconsInRegion:self.region];
	}
	else
	{
		[self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.region];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	/*
	 *Stops ranging after exiting the view.
	 */
	[self.beaconManager stopRangingBeaconsInRegion:self.region];
	[self.beaconManager stopEstimoteBeaconDiscovery];
}

- (void)updateBackgroundColor
{
	int b = 0;
	for (ESTBeacon *beacon in self.beaconsArray) {
		b++;
		switch (b) {
			case 1:
				beaconName1 = beacon.macAddress;
				redColor = [self colorValueFor:beacon.rssi];
			break;
			
			case 2:
				beaconName2 = beacon.macAddress;
				greenColor = [self colorValueFor:beacon.rssi];
			break;

			case 3:
				beaconName3 = beacon.macAddress;
				blueColor = [self colorValueFor:beacon.rssi];
			break;
		}
	}
	
	self.redLabel.text = [NSString stringWithFormat:@"%@ %0.2f",beaconName1,redColor];
	self.greenLabel.text = [NSString stringWithFormat:@"%@ %0.2f",beaconName2,greenColor];
	self.blueLabel.text = [NSString stringWithFormat:@"%@ %0.2f",beaconName3,blueColor];
	
	[self.view setBackgroundColor:[UIColor
								 colorWithRed:(CGFloat)redColor/255
								 green:(CGFloat)greenColor/255
								 blue:(CGFloat)blueColor/255
								 alpha:1]];
}

- (float)colorValueFor:(NSInteger)distance
{
	float color = 0;
	long dis = 100-(-distance-50)*2;
	if ( dis < 100 )
	{
		color = 255*dis/100;
	}
	
	return color;
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
	self.beaconsArray = beacons;
	
	[self updateBackgroundColor];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
	self.beaconsArray = beacons;
	
	[self updateBackgroundColor];
}

@end
