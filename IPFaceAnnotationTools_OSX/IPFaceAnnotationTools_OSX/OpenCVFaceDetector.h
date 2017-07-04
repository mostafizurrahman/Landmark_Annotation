//
//  OpenCVFaceDetector.h
//  OpenCVFaceDetection
//
//  Created by IPV on 7/3/17.
//  Copyright © 2017 IPV. All rights reserved.
//

#ifndef OpenCVFaceDetector_h
#define OpenCVFaceDetector_h

#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/objdetect.hpp>

using namespace cv;
using namespace std;

class OpenCVFaceDetector {
public:
    
    //default face detector
    OpenCVFaceDetector(){};
    /*
     xmlFilePath : trining xml file path
    */
    
    OpenCVFaceDetector(string xmlFilePath) : haarcascadeXMLFilePath{xmlFilePath} {}
    
    bool loadCascadeClassifier();
    void setImageFilePath(string imageFilePath);
    vector<cv::Rect> detectFace();

private:
    CascadeClassifier cascadeClassifier;
    string haarcascadeXMLFilePath;
    string imageFilePath;
    vector<cv::Rect> mFaceRect;
    
};

bool OpenCVFaceDetector::loadCascadeClassifier() {
    bool flag = cascadeClassifier.load(haarcascadeXMLFilePath);
    if (!flag) {
        cout << "Unable to load" << haarcascadeXMLFilePath << endl;
    }
    return flag;
}

void OpenCVFaceDetector::setImageFilePath(string imgFilePath){
    imageFilePath = imgFilePath;
}

vector<cv::Rect> OpenCVFaceDetector::detectFace() {
    Mat image = imread(imageFilePath,IMREAD_GRAYSCALE);
    cascadeClassifier.detectMultiScale(image, mFaceRect, 1.1, 6,
                                       0,
                                       cv::Size(20, 20),
                                       cv::Size());
    return mFaceRect;
}

#endif /* OpenCVFaceDetector_h */
