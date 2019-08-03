# tstamp

Unix filter to add timestamps to data feeds.

## Usage

    tail [-format strftime_format] [-utc] some.log | tstamp

* -format - A `strftime`-style date/time format (default is %Y-%m-%dT%H:%M:%S)
* -utc - Use UTC (default is your local timezone)


## Why?

Because I got angry one day that logs I was trying to follow didn't have
timestamps in them.
