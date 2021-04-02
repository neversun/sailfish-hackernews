![](https://raw.githubusercontent.com/neversun/sailfish-hackernews/master/dat/harbour-hackernews-86.png) Hacker News reader for Sailfish OS
=============================

A Hacker News reader for Sailfish OS written in Python and QML.

## Features

Read the awesome Hacker News of 'Y Combinator' within your jolla.

Supported types of items:
- top
- new
- show
- job

![](https://raw.githubusercontent.com/neversun/sailfish-hackernews/master/screenshot1.png)
![](https://raw.githubusercontent.com/neversun/sailfish-hackernews/master/screenshot2.png) 

## License

[MIT](https://github.com/neversun/sailfish-hackernews/blob/master/LICENSE)


## Development

## Prerequisites

> Ubuntu-based linux

1. install https://github.com/jordansissel/fpm
2. `apt-get install rpm`

## Build to VM

1. make make-virt

## Debug vm

```shell
> ssh -i '~/SailfishOS/vmshare/ssh/private_keys/Sailfish_OS-Emulator-latest/root' -p2223 root@localhost
> journalctl -alef -n all --full
```