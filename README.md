# Dynavity


## Setting up XcodeGen

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate Xcode project files. As such, a prerequisite is to install XcodeGen.

1. Install XcodeGen
```sh
brew install XcodeGen
```

2. Create a copy of `Dynavity/settings.yml.sample` named `Dynavity/settings.yml`.
```sh
cp Dynavity/settings.yml.sample Dynavity/settings.yml
```

3. Open `Dynavity/settings.yml` and replace `DEVELOPMENT_TEAM` and `PRODUCT_BUNDLE_IDENTIFIER` with your Team ID and a unique product bundle identifier respectively.
One way to get your Team ID is by going to the Build settings in Xcode, choosing your team, then viewing the source file of `project.pbxproj`.

You can now generate your project settings by navigating to the directory containing `project.yml`, and executing `xcodegen`.

### Automating project files generation

To automate the process, the following githooks can be added so that the `xcodegen` command will be executed on checkouts / pulls.

Warning: The following commands will overwrite whatever githooks you previously had for `post-checkout` and `post-merge`.

Assuming you are at the root directory of the repository, execute the following commands:

```sh
echo -e '#!/bin/sh\nxcodegen --spec Dynavity/project.yml --use-cache' > .git/hooks/post-checkout

chmod +x .git/hooks/post-checkout

echo -e '#!/bin/sh\nxcodegen --spec Dynavity/project.yml --use-cache' > .git/hooks/post-merge

chmod +x .git/hooks/post-merge

```

## Setting up CocoaPods

[CocoaPods](https://github.com/CocoaPods/CocoaPods) is used to manage third-party dependencies such as Firebase.
Before opening the project in Xcode, run the following command in the project root directory (`Dynavity/`).

```sh
pod install
```

Please take note of the following to avoid issues when building the project:
- Once `pod install` is done, do **not** re-run `xcodegen`. If you need to do so, re-run `pod install` after each `xcodegen`.
- Open the project in Xcode using only `Dynavity.xcworkspace` and **not** `Dynavity.xcodeproj`.
