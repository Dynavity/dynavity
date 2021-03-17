# Dynavity


## Setting up the project

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate Xcode project files. As such, a prerequisite is to install XcodeGen.

1. Install XcodeGen
```sh
brew install XcodeGen
```

2. Open `Dynavity/settings.yml.sample` and fill in your actual DEVELOPMENT_TEAM ID.
One way to find this is by going to the Build settings and choosing your team, and then viewing the source file of `project.pbxproj` to get your team ID

3. Rename `Dynavity/settings.yml.sample` to `Dynavity/settings.yml`
```sh
mv Dynavity/settings.yml.sample Dynavity/settings.yml
```

You can know generate your project settings by navigating to the directory containing `project.yml`, and executing `xcodegen`.

### Automating project files generation

To automate the process, the following githooks can added so that the `xcodegen` command will be executed on checkouts / pulls.

Assuming you are at the root directory of the repository,

Warning: The following commands will overwrite whatever githooks you previously had for `post-checkout` and `post-merge`.

```sh
echo '#!/bin/sh\n xcodegen --spec Dynavity/project.yml' > .git/hooks/post-checkout

chmod +x .git/hooks/post-checkout

echo '#!/bin/sh\n xcodegen --spec Dynavity/project.yml' > .git/hooks/post-merge

chmod +x .git/hooks/post-merge

```
