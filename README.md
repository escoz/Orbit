# Orbit

[![CI Status](http://img.shields.io/travis/Eduardo Scoz/Orbit.svg?style=flat)](https://travis-ci.org/Eduardo Scoz/Orbit)
[![Version](https://img.shields.io/cocoapods/v/Orbit.svg?style=flat)](http://cocoadocs.org/docsets/Orbit)
[![License](https://img.shields.io/cocoapods/l/Orbit.svg?style=flat)](http://cocoadocs.org/docsets/Orbit)
[![Platform](https://img.shields.io/cocoapods/p/Orbit.svg?style=flat)](http://cocoadocs.org/docsets/Orbit)

## Usage

Orbit is a simple dependency injection for your Obj-C projects. Say goodbye to singletons everywhere.

Orbit simplifies creation of domains and viewControllers on your class, by forcing you to follow simple and 
straightforward rules on how objects can be created. 

- it only supports property injection
- it always uses the init: initializer for classes
- it doesnt support recursion when creating objects.
- it currently doesnt support protocols

Orbit is a great way to quickly cleanup object sharing and singletons in your application.

More documentation will come.

## Requirements

## Installation

Orbit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Orbit"

## Author

Eduardo Scoz, eduardoscoz@gmail.com

## License

Orbit is available under the MIT license. See the LICENSE file for more info.

