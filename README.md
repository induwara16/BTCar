# BTCar
Simple but powerful cross platform app to control Bluetooth powered RC cars, but can also function as a SPP client.

## Features
* Easy to use control interface with 8 preset commands.
* Preset actions can be easily configured through settings.
* Ability to send custom commands and view incoming data from the target device.
* Cross platform (currently tested on Linux and Android only; may work on Windows, iOS and Mac support is not planned yet).

## Requirements
* Linux system or Android device that supports Bluetooth.
* Bluez5 support for Linux.
* Android version must be 7.1 or higher (Qt documentation says 8.0 or above, but BTCar was successfully tested on a 7.1 device).

## Installation
Executables and packages are not created yet, you can build the source code yourself using QtCreator. Make sure you have installed atleast Qt 6.4 or above, and the QtConnectivity package (Found under "Additional libraries" in the maintenance tool).
