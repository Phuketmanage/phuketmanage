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

## Tests

All closed issues have to be covered by tests except when mentionned that tests are not required.
```sh
rails t
rspec
```

## Coverage

```sh
open coverage/index.html
```

## Payment
The main principle is to be paid for closed tickets and for the standard workflow after training/learning, but not for the training/learning itself.

When approaching a task, you start by reviewing the ticket. If you have a general understanding how to solve the task, proceed and start the timer. If you don't understand it at first, study the question and begin working only when you feel prepared. Alternatively, if the ticket seems to big but you see that can complete a part of it, let us know, and we will break it down into smaller, more manageable tickets.

## Recommendations
Toggl Track - time tracking

## Troubleshooting
After assets update `rails assets:precompile` may be required
