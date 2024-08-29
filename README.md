# Saily

## Modern. Fast. Beautiful.

**You are currently in the main-rootless-3.0 branch.**

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/SailyTeam/Saily/pulls)

Saily is a modern APT package manager designed for jailbroken devices running iOS/iPadOS 15 and above, using the **Dopamine** jailbreak.

If you are using RootHide or NathenLR, you may need to modify the jbroot and adopt some patches yourself. Forks or pull requests are welcome.

![Preview](Resources/main.jpeg)

## Saily Features

- [x] Unique UI for **both** iPhone and iPad
- [x] Import all your repositories from Cydia, Sileo, Zebra, and Installer
- [x] Add and manage repositories without limitation
- [x] Built to work alongside all your other package managers
- [x] Support for Web Depictions with dark mode
- [x] Support for Native Depictions with dark mode
- [x] Support for paid packages
- [x] Clear Version Control page listing all available versions and repositories
- [x] Clean and stable packaging using CI
- [x] Random device info for free packages
- [x] Fully open-sourced under the MIT License
- [x] Quick actions (e.g., respring, uicache) via the Settings page

## Bug Reports, Feature Requests, & Feedback

For support related to Saily, open up an issue. Before reporting an issue, check if it has already been reported to avoid duplicates.

[<img src="Resources/bugsnag.png" alt="" width="100"/>](https://www.bugsnag.com)

We use [Bugsnag](https://www.bugsnag.com/) for bug and crash tracking. [Privacy Licenses](https://docs.bugsnag.com/platforms/ios/appstore-privacy/) ensure that diagnostic data is anonymous and cannot trace back to you.

If your issue is related to a crash, include the following information in your report:

- Your Bugsnag ID (found in the Settings page or application log) provides a backtrace with code-level diagnostic data without privacy concerns.
- The application log, typically located at `/var/mobile/Documents/wiki.qaq.chromatic/Journal/`, can help track the issue. This plain text document may include sensitive information (e.g., searched text, repository URLs), so review it before uploading.

## Compiling the Project

For debugging with Xcode, simply open the workspace and click "Run." For real device debugging, you will need to update certifications and bundle identity. The debug build will not include license information, which is generated during the release build.

To compile for release, run the command line in the resources folder. Ensure you have dpkg installed for building the package, and python3 for license scanning. xcpretty is recommended for better output formatting. swiftlint and bartycrouch are optional.

- This product includes software developed by the Sileo Team.

#### "While the world sleeps, we dream."

---

Copyright © 2024 Saily Team. All Rights Reserved.