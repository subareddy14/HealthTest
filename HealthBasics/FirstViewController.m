//
//  FirstViewController.m
//  HealthBasics
//
//  Created by admin on 22/12/15.
//  Copyright © 2015 admin. All rights reserved.
//

#import "FirstViewController.h"
#import "GSHealthKitManager.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)healthIntegrationButtonSwitched:(UISwitch *)sender {
    
    if (sender.isOn) {
        [[GSHealthKitManager sharedManager] requestAuthorization];
    } else {
        // Possibly disable HealthKit functionality in your app.
    }
    
    
   
    
   
}

- (IBAction)readAgeButtonPressed:(id)sender {
    
    NSDate *birthDate = [[GSHealthKitManager sharedManager] readBirthDate];
    
    if (birthDate == nil) {
        // Either user didn't set the date, or an error occured. Simply return.
        return;
    }
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthDate
                                       toDate:[NSDate date]
                                       options:0];
    
    self.ageLabel.text = [@(ageComponents.year) stringValue];
    //[[GSHealthKitManager sharedManager] writeWeightSample:self.weightTextField.text.floatValue];
}

- (IBAction)writeWorkoutButtonPressed:(id)sender {
     //In a real world app, you would obtain reference to a relevant model object and pass it to following method.
   [[GSHealthKitManager sharedManager] requestAuthorization];
   [[GSHealthKitManager sharedManager]writeWeightSample:self.weightTextField.text.floatValue];
  
}

@end
