//
//  OpenCVWrapper.mm
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper

+ (UIImage *)adjustTemperature:(UIImage *)image withTemperature:(float)temperature {
    // Convert UIImage to cv::Mat
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    // Convert to BGR if needed
    if (cvImage.channels() == 1) {
        cv::cvtColor(cvImage, cvImage, cv::COLOR_GRAY2BGR);
    } else if (cvImage.channels() == 4) {
        cv::cvtColor(cvImage, cvImage, cv::COLOR_RGBA2BGR);
    }
    
    // Split the image into channels
    std::vector<cv::Mat> channels;
    cv::split(cvImage, channels);
    
    // Adjust temperature by modifying blue and red channels
    // Temperature < 0: cooler (more blue)
    // Temperature > 0: warmer (more red/yellow)
    float normalizedTemp = temperature / 100.0; // Assuming temperature is in range [-100, 100]
    
    if (normalizedTemp > 0) {
        // Warmer: increase red, decrease blue
        channels[2] = cv::min(channels[2] * (1 + normalizedTemp), 255);
        channels[0] = cv::max(channels[0] * (1 - normalizedTemp * 0.5), 0);
    } else {
        // Cooler: increase blue, decrease red
        normalizedTemp = -normalizedTemp;
        channels[0] = cv::min(channels[0] * (1 + normalizedTemp), 255);
        channels[2] = cv::max(channels[2] * (1 - normalizedTemp * 0.5), 0);
    }
    
    // Merge the channels back
    cv::merge(channels, cvImage);
    
    // Convert back to RGBA if needed
    cv::cvtColor(cvImage, cvImage, cv::COLOR_BGR2RGBA);
    
    // Convert cv::Mat back to UIImage
    UIImage *resultImage = MatToUIImage(cvImage);
    
    return resultImage;
}

@end
