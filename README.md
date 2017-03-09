![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
![Build Status](https://travis-ci.org/wayfindrltd/wayfindr-demo-ios.svg?branch=master)

# wayfindr-demo-ios
A repo for the Wayfindr demonstration iOS app

<img src="WayfindrLogo.png" width="265" height="auto"/>

## Purpose of the Wayfindr Demo iOS app

We know that there is a community of organisations and individuals worldwide interesting in exploring digital wayfinding for vision impaired people. We want to support these people who are planning to explore audio wayfinding in different types of built-environments, e.g. transport, retails, health, entertainment etc. We  have open-sourced the Wayfindr Demo mobile app that has been used in the Wayfindr trials so far, in order to provide developers, designers and researchers around the world with a free, open tool to conduct their research in context.

This app serves also as a demonstration of the [Guidelines for Mobile App Development](http://www.wayfindr.net/open-standard/guidelines/mobile-app-development/) as seen on the Wayfindr Open Standard. 

We invite all the interested parties to download the Wayfindr Demo mobile app, customise it based on their needs, run their experiments and then share new versions of the app with the Wayfindr open community.

We want the app to be an evolving tool for research and demonstration of wayfinding systems for the vision impaired. This app is not aimed to become a navigation product but a tool for research and demonstration.

To learn more, visit the [Wayfindr website](http://www.wayfindr.net).

## Dependencies

* [Xcode 8.0](https://itunes.apple.com/gb/app/xcode/id497799835?mt=12)
* [CocoaPods 1.2.0](https://www.cocoapods.org)

## Usage

#### Running the app with Xcode

The following steps are required to run the project:

    $ Make

You can then open the workspace file `Wayfindr Demo.xcworkspace`

### Connectivity Requirements

When the app initially launches, Internet connection is required. The beacon SDK used for this sample implementation requires Internet access before first attempt at beacon ranging. For ease of implementation this sample app always requires Internet access on launch.

Bluetooth needs to be turned on at all times in order to communicate with any of the beacons even passively.

## Architecture

### Overview

There are three modes to the Wayfindr app - *User* (displayed as *Wayfindr*), *Maintainer* and *Developer* modes. These are expressed as tabs in a `UITabViewController`. Each mode keeps a separate copy of the venue model and beacons interface. This is to make it easier to split these into separate apps in the future.

### Model

The Wayfindr app uses two data files to generate the model. The first is `DemoGraphData.graphml` which represents all of the beacons and the valid routes between them. The second is `DemoVenueData.json` which represents all the places of interest, e.g. entrances, exits and platforms at a station.

The `graphml` file is used to load the `WAYGraph` representation of the venue. The `json` is used to load the remaining metadata into the `WAYVenue` object. The `WAYGraph` and `WAYVenue` object are two of the most commonly used model objects.

The last commonly used model object is the `WAYBeacon`. This represents a single beacon and is a manufacturer independent abstraction.

### Controllers

The root controller for the app is `ModeSelectionTabViewController`. The root controller for the *User* mode is `UserActionTableViewController`. Similarly, the root controller for the *Maintainer* mode is `MaintainerActionSelectionTableViewController` just as the root view controller for the *Developer* mode is `DeveloperActionSelectionTableViewController`.

### Interface

The `BeaconInterface` is the go-between for the app and the beacons. To use a particular manufacturer's beacons, write a driver that implements the `BeaconInterface` protocol and calls the `BeaconInterfaceDelegate` as appropriate.

In general, the *User* mode of the app (displayed as *Wayfindr*) requires `WAYBeacon` objects to be provided with the `accuracy` measurement. This is used to determine the nearest beacon. All other optional beacon information except for `rssi` is not used at this point. RSSI (Recieved Signal Strength Indicator) can also be used to determine the nearest beacon.

The *Maintainer* mode of the app uses addional beacon information. That being said, it is intelligent about coalescing data when it sees the same beacon in a short amount of time.

The *Developer* mode of the app contains a set of tools useful when developing this app, conducting user testing, and preparing for  trials.

The `VenueInteface` is the abstraction of a venue. This is the mapping between your graph and your BeaconInterface. Implement your own model to use your BeaconInterface implementation and graph data. For more information on how this can be done, see section `Sample Data / Implementation`.

## Starting a New Trial

Below are the major steps needed to prepare the prototype for a trial in a new venue and/or with a new beacon manufacturer or protocol. For more information on examples of these steps, see section `Sample Data / Implementation`

- Create a `GraphML` and `JSON` file (or as results from an API call) that define the beacons, instructions, and metadata for the venue. 
- Create a `BeaconInterface` for interacting with the venue's beacons. 
- Create a `VenueInterface` that fetches the `GraphML` and `JSON` and prepares the appropriate `BeaconInterface`. 
- Initialize the `VenueInterface` at the root view controller for each mode.

### Sample Data / Implementation

The project contain sample data to explain how to construct the `GraphML` and `JSON` data files:

- See `DemoGraphData.graphml` for an example on how to structure your graph data.
- See `DemoVenueData.json`for an example on how to structure your JSON file.

An example of how to put these data files into use can be found in the class `DemoVenueInterface`.

Any mentions of "platforms" or "exits" found in the code are legacy from Wayfindr's previous trials in [Mainline Rail and Metro Stations](http://www.wayfindr.net/open-standard/guidelines/venue-types/mainline-rail-and-metro-stations/).

Information about the beacons parameters (e.g.major, minor, accuracy etc.) can be found in the [Wayfindr Open Standard](http://wayfindr.staging.wpengine.com/open-standard/wayfinding-technologies/bluetooth-low-energy-beacons/).

## Team

If you want to get in touch, you can reach us [here](mailto:hello@wayfindr.net).

* UX Design: [Georgios Maninis](mailto:georgios@wayfindr.net)
* Project Management: [Umesh Pandya](mailto:ume@wayfindr.net)


## License

The Wayfinder app is released under the MIT license. See LICENSE for details.
