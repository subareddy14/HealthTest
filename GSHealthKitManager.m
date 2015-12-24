//
//  GSHealthKitManager.m
//  HealthBasics
//
//  Created by admin on 22/12/15.
//  Copyright © 2015 admin. All rights reserved.
//

#import "GSHealthKitManager.h"
#import <HealthKit/HealthKit.h>



@implementation GSHealthKitManager


+(GSHealthKitManager *)sharedManager{
    
    static GSHealthKitManager  *sharedMyManager=nil;
    
    static  dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager=[[self alloc]init];
        sharedMyManager.healthStore=[[HKHealthStore alloc]init];
    });
    
    return sharedMyManager;
    
}

- (void)requestAuthorization
{
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        // If our device doesn't support HealthKit -> return.
        return;
    }
    
    NSSet *shareObjectTypes = [NSSet setWithObjects:
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                               nil];
    
    // Read date of birth, biological sex and step count
    NSSet *readObjectTypes  = [NSSet setWithObjects:
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                               [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                               [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                             
                               [HKObjectType workoutType],
                             
                               nil];
   
    
    // Request access
    [self.healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                        readTypes:readObjectTypes
                                       completion:^(BOOL success, NSError *error) {
                                           
                                           if(success == YES)
                                           {
                                               
                                           
                                           }
                                           else
                                           {
                                              
                                           }
                                           
                                       }];

}


- (NSDate *)readBirthDate {
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];   // Convenience method of HKHealthStore to get date of birth directly.
    
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
    }
    
    return dateOfBirth;
}

- (void)writeWorkoutDataFromModelObject:(id)workoutModelObject
{
//    NSDate *startDate = [NSDate date];
//    NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 60 * 2];
//    NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
//     int  distanceInMeters = 57000.0f;
//    
//    HKQuantity *distanceQuantity = [HKQuantity quantityWithUnit:[HKUnit meterUnit] doubleValue:(double)distanceInMeters];
//    
//    HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeRunning
//                                                  startDate:startDate
//                                                    endDate:endDate
//                                                   duration:duration
//                                          totalEnergyBurned:nil
//                                              totalDistance:distanceQuantity
//                                                   metadata:nil];
//    
//    [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
//        NSLog(@"Saving workout to healthStore - success: %@", success ? @"YES" : @"NO");
//        if (error != nil) {
//            NSLog(@"error: %@", error);
//        }
//    }];
//
    
    // Some weight in gram
    double weightInGram = 83400.f;
    
    // Create an instance of HKQuantityType and
    // HKQuantity to specify the data type and value
    // you want to update
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weightInGram];
    
    // Create the concrete sample
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                     quantity:hkQuantity
                                                                    startDate:now
                                                                      endDate:now];
    
    // Update the weight in the health store
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        // ..
    }];
}

-(void)writeWeightSample:(int)weight {
    
    // Each quantity consists of a value and a unit.
    HKUnit *kilogramUnit = [HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo];
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:kilogramUnit doubleValue:weight];
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *now = [NSDate date];
    
    // For every sample, we need a sample type, quantity and a date.
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saving workout to healthStore - success: %@", success ? @"YES" : @"NO");

        if (!success) {
            NSLog(@"Error while saving weight (%d) to Health Store: %@.", weight, error);
        }
    }];
}



@end
