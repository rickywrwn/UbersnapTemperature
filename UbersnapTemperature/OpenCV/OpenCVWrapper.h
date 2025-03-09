//
//  OpenCVWrapper.h
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

// Method to adjust image temperature
+ (UIImage *)adjustTemperature:(UIImage *)image withTemperature:(float)temperature;

@end

NS_ASSUME_NONNULL_END

#endif /* OpenCVWrapper_h */
