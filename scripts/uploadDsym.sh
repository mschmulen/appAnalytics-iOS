#!/bin/sh

pwd;

echo "## Upload dSYMs"

# du size of the asset
# du -hs ../Homer/Embedded



echo "## echo the build/Release-iphoneos folder:"
ls build/Release-iphoneos

echo "## size of AppAnalytics.framework.dSYM"
du -hs build/Release-iphoneos/AppAnalytics.framework.dSYM

echo "## echo the build/AppAnalytics.build/Release-iphoneos/ folder:"
ls build/AppAnalytics.build/Release-iphoneos/

# echo "size ofbuild/AppAnalytics.build/Release-iphoneos/ "
# ls build/AppAnalytics.build/Release-iphoneos/


# build_Release=`build/Release-iphoneos`;
# AppAnalytics_framework_dsym=`build/Release-iphoneos/AppAnalytics.framework.dSYM`;
#
#
# echo "echo the build/Release-iphoneos folder:"
# ls $build_Release
#
# echo "echo the build/Release-iphoneos folder:"
# du -hs $AppAnalytics_framework_dsym


# Finally
echo "🏁  Done. 🆒"

