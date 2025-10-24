# BCC-Blindfold

> A blindfold script for RedM and VorpCore Framework

## Features

- Blindfold the nearest player
- Blindfold yourself!
- Commands to blindfold
- Item to blindfold
- Chance to break free
- Features are all configurable!

## Commands

- /blindfold
  - adds blindfold to nearest player
- /blindfoldme
  - adds blindfold to yourself
- /unblindfold
  - removes blindfold from nearest player
- /unblindfoldme
  - removed blindfold from yourself (if you placed it on yourself)

## Install

- Download this repo
- Copy and paste `bcc-blindfold` folder to `resources/bcc-blindfold`
- Add `ensure bcc-blindfold` to your `server.cfg` file
- By default the blindfold item will be added to the database on the first script start (unless `Config.autoSeedDatabase` is disabled). You can also seed or verify items manually from the server console (see below).
- Add image to vorp_inventory from items/blindfold.png
- Now you are ready to go!

## Database seeding

- The resource will attempt to seed the `blindfold` item into your `items` table on first start by default. If you have `Config.autoSeedDatabase = false` seeding will be skipped automatically.
- Console-only commands provided for manual control:
  - `bcc-blindfold:seed` — force the seeder to run (server console only)
  - `bcc-blindfold:verify` — check whether the required items exist in the `items` table (server console only)

## Need More Support?

- [BCC Discord](https://discord.gg/cQMJaTqcqJ)

## Coming Soon

- api's for other scripts to use (police, criminal, etc)
