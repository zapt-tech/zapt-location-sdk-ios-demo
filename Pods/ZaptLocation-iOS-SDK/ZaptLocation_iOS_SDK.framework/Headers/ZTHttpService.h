//
//  ZTHttpService.h
//  Pods
//
//  Created by BRUNO CARNEIRO on 25/07/19.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "ZTLogger.h"

@interface ZTHttpService : NSObject

@property (retain) NSString *visitableId;
@property BOOL debugLogEnabled;
@property (retain, readonly) ZTLogger *logger;

- (instancetype)initWithVisitableId :(NSString *)visitableId;

- (void) createInitSDKRequest:(BOOL)disableSyncingForAnalytics;

- (void) createMeasurementsRequest:(NSMutableDictionary *)beacons withDisableSyncingForPositioning:(BOOL)disableSyncingForPositioning
    withDisableSyncingForAnalytics:(BOOL)disableSyncingForAnalytics;

- (void) createExitRequest:(NSString *)userId;

@end

