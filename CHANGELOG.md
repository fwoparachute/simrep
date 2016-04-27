# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
### Changed
- Added Perks now appropriately gives your costume level in perk points not costume level + 1.
- Bank Accounts now start with 5 Venthian marks instead of 10.

### Fixed

### Broken
- Version numbers. They'll catch up after the event, but for now don't trust them.

## [1.7.3](v1.7.3) - 2016-3-26
### Added
- Link to this repo.

## [1.7.2](v1.7.2) - 2016-3-20
### Fixed
- NPC Shifts can be reversed for editing without crashing the app.

## [1.7.1](v1.7.1) - 2016-3-20
### Fixed
- Removed January's non-maintenance maintenance message.


## [1.7.0](v1.7.0) - 2016-3-20
### Added
- Ghost detection: ghosts no longer earn experience after they die, and instead earn 5 TU instead of the normal 2.

### Changed
- Added a bunch of UI improvements to Admin, namely select boxes are now select2 boxes and amazing.
  + Bank Accounts are (generally) sorted by owner name instead of by id

### Fixed
- Updated wicked_pdf binary to fix compatibility for something that broke since 1.5.11
- Mass Killing from Admin no longer crashes the app (corrected date->weekend)
- Paid NPC Shifts can have their payments reversed so that their times are editable (this is a lie!)
- Printing a PDF of your character sheet will no longer use up a cleaning coupon

## [1.6.0](v1.6.0) - 2016-3-17
### Added
- Temporary Effects (like increased perm chance for one event)
- Events come with a base willpower. Character Sheets display base willpower.

### Changed
- Cleaned up the override options in BankAccount
- Consolidated and cleaned up `BankTransaction#[post|reverse]_transaction`
- Eager loading in many of the Admin pages should speed up app performance

### Fixed
- Failed transactions no longer raise an exception to crash the app.
- `BankTransaction#reverse_transaction` changes the account balances too.

## [1.5.12](v1.5.12) - 2016-3-17
### Fixed
- Awarding attendance (like when printing a character sheet) requires an explicit override to change pay/clean awards.

## [1.5.11](v1.5.11) - 2016-1-9
### Added
- Versions get their own page on admin for easier reviewing.

### Fixed
- Some spelling fixes.
- Synced local DB to Heroku.

## [1.5.6](v1.5.6) - 2016-1-2
### Fixed
- NPC Shifts are more lenient in determining if they have a linked bank_transaction.

## [1.5.4](v1.5.4) - 2016-1-2
### Fixed
- NPC Shifts before v1.4.0 would throw errors because they couldn't track the bank_transaction associated with them.

## [1.5.3](v1.5.3) - 2016-1-1
### Fixed
- I mistyped in the routes file which broke everything.
- Added ALL the favicons, which should silence routing issues ("I can't find this icon") which were obscuring more important routing issues ("I can't post bank transactions")
- Prettier error pages.

## [1.5.2](v1.5.2) - 2016-1-1
### Fixed
- Fixed a permissions issue when trying to send transactions introduced by [0d995a6](0d995a6) in [1.4.0](v1.4.0).

## [1.5.1](v1.5.1) - 2015-12-31
### Fixed
- Fixed a permissions issue when calculating character deaths.

## [1.5.0](v1.5.0) - 2015-12-30
### Added
- Rollbar integration

### Fixed
- Cleaned up internals for Death and CharacterEvents
- Added `revert_attendence_awards` to CharacterEvent

## [1.4.2](v1.4.2) - 2015-12-30
### Fixed
- Proper links in Changelog
- Deploys to Heroku trigger assets compiling

## [1.4.1](v1.4.1) - 2015-12-30
### Added
- Changelog

## [1.4.0](v1.4.0) - 2015-12-30
This was a HUGE rewrite with about 54 commits since the last push.
Since I don't have a testing strategy yet, it's likely some things are broken.
### Changed
- NPC Shifts have been totally reworked. They track which event they're attached
  to and automatically pay out at their closing. Granularity has been dropped to 15 minutes, so partial payments are a thing.
- Reworked navigation for admins/back office.

### Added
- Each model has an admin page now, some of them have less than useful defaults.
- Exposed version history on admin side for most models (as well as who changed them). Need to use the console for reverts.

### Fixed
- Removed some disabled links and routes to edit pages
- Cleaned the crap out of the admin edit pages. Hooray CSS.
- Nicer flash messages
- Massive speedups on pages that load several characters (and everything along with them).
- Faster experience calculations
- Prettier datetimes.

## [1.3.7](v1.3.7) - 2015-10-04
### Added
- There are some aws settings hanging out after my initial attempt. Eventually will get back to them.
- Version file :)
- Added rspec skeletons, didn't write any tests.

## [1.3.5](v1.3.5) - 2015-10-04
### Fixed
- Deaths are calculated on the fly and properly account for the current event.

## [1.3.4](v1.3.4) - 2015-10-04
### Added
- Used at the November Event.