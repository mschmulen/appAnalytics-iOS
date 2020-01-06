dSYMs Readme
===


## Notes on File paths


// fetch from the archive folder 

```
ls /Users/schmulen/Library/Developer/Xcode/Archives/2019-12-20
```

```
ls /Users/schmulen/Library/Developer/Xcode/Archives/2019-12-20/AnalyticsSwiftUIExample 12-20-19, 8.22 AM.xcarchive/dSYMs
```



## Notes on Bitcode


TL;DR: dSYMS generated at build time has little value in the "bitcode enabled" era, you need to download dSYMs from Apple and upload them to your 3rd party crash reporter service as a post-build step after Apple has processed your upload.

#### Background
Symptom
Missing dSYMs / failed symbolication in 3rd party crash reporting console. I thought despite following Crashlytics install instructions the script was failing.

#### Bitcode - the fundamental issue
Turns out the 3rd party crash-reporting systems (like Crashlytics, or New Relic) have a fundamental problem with the current best practice for app distribution, which is bitcode-enabled apps. Historically these 3rd party crash report systems relied on build-time steps to upload build-time generated dSYMs. But since bitcode-enabling means the app store recompiles your apps, your build-time generated dSYMs, that you are trying to upload, are effectively useless.

As background, bitcode-enabled apps are "thinned" and thus re-compiled by Apple such that each device only gets the download bits it needs. You want to enable bitcode. It is a good thing. But, bitcode-enabled distribution messes up symbolication. No matter what dSYMs you generate at build time, the dSYMs won't actually correlate to crashes from App Store or TestFlight installed builds, as your crashes will be from App-store recompiled versions of your apps with new corresponding dSYMs.

So don't worry about the upload script working or not at build time. In fact, that step could be removed from your build process as it is just wasting your time and bandwidth.

The only case it might be useful is if you want to symbolicate crashes from locally-installed release versions instead of debugging them directly in Xcode.

#### Solutions
The solution is to wait "some time" (reportedly several minutes, via NewRelic documentation, in my experience a sleep of 120 seconds after fastlane upload but before I ran fastlane's download_dsyms action failed sometimes, a sleep of 300 seconds works reliably) after uploading your app (likely the duration of time the App Store says your build is "Processing"), then download the dSYMs from there and use your 3rd party crash reporters command-line upload script

Manual download / upload
The current recommended solutions from the 3rd party crash reporters (both NewRelic and Crashlytics documentation at least) is to either go to the App Store Connect page for the build and download dSYMs then upload, or using XCode's Organizer for the archive hit the "Download Debug Symbols" button, then upload them.

This does work, with manual dSYM downloads pushed out to your crash reporting vendor you will get symbolicated reports. It is a manual process though using either the Xcode GUI or the App Store Connect interface.

#### Fastlane automation
You may automate the process with Fastlane though, which is I believe the proper solution.

https://docs.fastlane.tools/actions/download_dsyms/#download_dsyms

```
lane :refresh_dsyms do
  download_dsyms                  # Download dSYM files from iTC
  upload_symbols_to_crashlytics   # Upload them to Crashlytics
  clean_build_artifacts           # Delete the local dSYM files
end
```

```
download_dsyms(version: "1.0.0", build_number: "345")
download_dsyms(version: "live")
download_dsyms(min_version: "1.2.3")
```

https://docs.fastlane.tools/actions/upload_symbols_to_crashlytics/

```
upload_symbols_to_crashlytics
upload_symbols_to_crashlytics(dsym_path: "./App.dSYM.zip")

fastlane action upload_symbols_to_crashlytics

fastlane run upload_symbols_to_crashlytics

fastlane run upload_symbols_to_crashlytics parameter1:"value1" parameter2:"value2"

```


## References 

https://stackoverflow.com/questions/54577202/how-to-run-upload-symbols-to-upload-dsyms-as-a-part-of-xcode-build-process



## Attic 


```
find ${DWARF_DSYM_FOLDER_PATH} -name "*.dSYM" | xargs -I \{\} ${PODS_ROOT}/Fabric/upload-symbols -gsp MyProjectFolder/GoogleService-Info.plist -p ios \{\}
```

