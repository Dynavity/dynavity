# Dynavity


## Setting up the project

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate Xcode project files. As such, a prerequisite is to install XcodeGen.

1. Install XcodeGen
```sh
brew install XcodeGen
```

2. Open `Dynavity/settings.yml.sample` and replace `DEVELOPMENT_TEAM` and `PRODUCT_BUNDLE_IDENTIFIER` with your Team ID and a unique product bundle identifier respectively.
One way to get your Team ID is by going to the Build settings in Xcode, choosing your team, then viewing the source file of `project.pbxproj`.

3. Rename `Dynavity/settings.yml.sample` to `Dynavity/settings.yml`
```sh
cp Dynavity/settings.yml.sample Dynavity/settings.yml
```

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
