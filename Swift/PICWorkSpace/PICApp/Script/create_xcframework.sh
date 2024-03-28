#!/bin/bash


cd ../

rm -rf Output
mkdir Output

xcodebuild clean \
    -workspace PICApp.xcworkspace \
    -scheme PIC
xcodebuild archive \
    -workspace PICApp.xcworkspace \
    -scheme PIC  \
    -configuration Release \
    -sdk iphoneos \
    -destination='generic/platform=iOS' \
    -archivePath Output/ios-device \
    ENABLE_BITCODE=NO \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
xcodebuild -create-xcframework \
    -framework Output/ios-device.xcarchive/Products/Library/Frameworks/PIC.framework \
    -output Output/PIC.xcframework
cd Output
open .

echo "🎉 archive complete"
