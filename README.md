# Phuketmanage

Property management website that allow to manage houses and bookings. It helps with keeping track of all incomes and expenses, providing owners with access to reports, and assists in organizing internal company work for rental, maintenance as well as tenants' check in/out.

## Main structure
Houses - list of houses, from here can go to Balance | Bookings | House Details | Prices | Photos.

Bookinngs - all bookings that cann be filtered by date or house.

Timeline - calendar that show houses occupancy, cleanings schedule.

Check in/out - information for guests relation manager to help with check in or check out process.

Balannce - finantial report. Can see transactionns for company or for selected owner.

Reports - some reports and analytics.

Water - water meter reading to control connsomption.

Users - have different roles: manager, accounting, guest relation, owner, client, maid, gardener, transfer

Jobs - jobs that company staff have to accomplish. Allow to keep record on main points of process.

## Installation

```sh
rake db:setup
```

## Quick login:

```
https://localhost:3000/unlock
```

## Work

The idea is that we do not commit directly to master, only through a pull request, so the master can simply be reset to the current version in the repository

#### 1. Download
```sh
git fetch --all -p
git checkout master
git reset --hard origin/master
bundle install
```

#### 2. Start changes in branch
```sh
git checkout -b [branch-name]
```

#### 3. Commit

```sh
git add -A
git commit -m [commit description]
git push -u origin [branch-name]
```

If have small changes after commit ammend them no need to create new commit
```sh
git add xxx xxx
git commit --amend --no-edit
git push -f
```

#### Conventional Commits

The commit message should be structured as follows:

```
<type>[optional scope]: <description>

[optional body]
```

Types: `fix:` used when a commit represents a bug fix, `feat:` introduces a new feature, `chore:` anything that isn’t outside-user-facing, `ci:`, `docs:`, `style:`, `refactor:`, `test:`.

Scope is a noun describing where changes was made.

`!` after the type/scope introduces a breaking changes. Example: `feat(search): add filters`

## Tests

All closed issues have to be covered by tests except when mentionned that tests are not required.
```sh
rails t
rspec
```

## Rspec system tests

By default system tests will use `:rack_test` driver without JS support to run tests faster.

To run tests that rely on JS: add `js: true`. It will run those tests with `:selenium_chrome_headless` driver. Examples:

- In describe block (will run all tests inside using chrome):

```ruby
describe 'whole test block needs js', js: true do
```

- In 'it' block to activate engine only for specific test:

```ruby
it "runs specific test that needs js", js: true do
```

Add `js_visual: true` to use selenium_chrome driver (will open browser window).

### Screenshots

The default systems tests (without `js: true` or `js_visual: true`) will not save screenshots. Both options (js, js_visual) will save screenshot in 'tmp/screenshots' to help you identify the problem, so you can use it for debug purpose. Example:

```sh
Failures:

  1) Search when hide checkbox checked hides unavailable houses
     Failure/Error: expect(page).to have_selector('div.col.wrong', count: 3, visible: true)
       expected to find css "div.col.wrong" 3 times but there were no matches

     [Screenshot Image]: /phuketmanage/tmp/screenshots/failures_r_spec_some_failed_test_409.png
```

## Coverage

```sh
open coverage/index.html
```

## Database graphic schema
```sh
open erd.pdf
```

## Recommendations
Toggl Track - time tracking

## Payment
The main principle is to be paid for closed tickets and for the standard workflow after training/learning, but not for the training/learning itself.

When approaching a task, you start by reviewing the ticket. If you have a general understanding how to solve the task, proceed and start the timer. If you don't understand it at first, study the question and begin working only when you feel prepared. Alternatively, if the ticket seems to big but you see that can complete a part of it, let us know, and we will break it down into smaller, more manageable tickets.
