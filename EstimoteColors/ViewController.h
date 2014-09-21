//
//  ViewController.h
//  EstimoteColors
//
//  Created by Dawid Pośliński on 21.09.2014.
//  Copyright (c) 2014 Dawid Pośliński @Generio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"

typedef enum : int
{
	ESTScanTypeBluetooth,
	ESTScanTypeBeacon
	
} ESTScanType;

@interface ViewController : UIViewController <ESTBeaconManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;


@end

