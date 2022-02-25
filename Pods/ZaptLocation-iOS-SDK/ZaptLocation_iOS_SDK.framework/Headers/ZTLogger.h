//
//  ZTLogger.h
//  Pods
//
//  Created by BRUNO CARNEIRO on 25/07/19.
//

#import <Foundation/Foundation.h>

@interface ZTLogger : NSObject

@property BOOL debugLogEnabled;

- (void) debugLog: (NSString*) format, ...;

@end

