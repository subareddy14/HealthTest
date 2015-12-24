//
//  GSHealthKitManager.h
//  HealthBasics
//
//  Created by admin on 22/12/15.
//  Copyright © 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HealthKit/HealthKit.h>

@interface GSHealthKitManager : NSObject
{


}

@property (nonatomic, retain) HKHealthStore *healthStore;
+(id)sharedManager;
-(void)requestAuthorization;
-(NSDate *)readBirthDate;
-(void)writeWorkoutDataFromModelObject:(id)workoutModelObject;
-(void)writeWeightSample:(int)weight;

@end
