# covid-19-stats
A (small) zsh script to display coronavirus statistics, using the API from <https://covid-tracker-us.herokuapp.com>, made by [Kilo59](https://github.com/Kilo59/coronavirus-tracker-api) and forked from [ExpDev07's API](https://github.com/ExpDev07/coronavirus-tracker-api).

## Usage:
```
$ covid-19 --help
covid-19 [all | usa]
covid-19 (--fatal | -f) XX [XX ...]
covid-19 (--loc | -l) XX [XX ...]
		where 'XX' is a valid ISO-3166-1 alpha-2 country code
covid-19 (--help | -h)
covid-19 (--version | -v)
```
### Main command
`$ covid-19` returns:
```
———————— COVID-19 STATUS ————————
Confirmed Cases:        6,632,985
Deaths:                   391,136
Recovered:                758,166
Fatality Rate:              34.0%
—————————————————————————————————
Last updated: 01:47:58
```
### Fatality rates
Use the `-f` or `--fatal` flag to get the global fatality rate[^1]

`$ covid-19 --fatal` or `$ covid-19 -f` returns:
```
Fatality Rate (Global): 34.0%
```

To get the fatality rate for a specific country, add the appropriate [ISO-3166-1 country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements).
`$ covid-19 -f US` returns:
```
Fatality Rate (US): 18.2%
```
You can get the rates for more than one country by adding additional country codes (use `00` to include the global rate):

`$ covid-19 -f US Gb br 00 aq tR AF` returns:
```Fatality Rate (US):      16.6%
Fatality Rate (GB):      97.0%
Fatality Rate (BR):     4.90%*
Fatality Rate (Global):  31.8%
Fatality Rate (AQ):        N/A
Fatality Rate (TR):      3.06%
Fatality Rate (AF):      8.18%
──────────────────────────────
* Alt. fatality formula used
Last updated: 12:33:03
```
__IMPORTANT:__
Recovery counts for many countries are missing or undercounted (see issue [#161 on ExpDev07's repo](https://github.com/ExpDev07/coronavirus-tracker-api/issues/161)). As such, there _will_ be incorrect values for fatality rates for many countries (such as Great Britain and Brazil in the example above). Please keep this in mind that this is not a bug with this script but an issue with the source database/API.

### General Statistics

To get statistics for a specific location, use the `-l` or `-loc` flag followed by the country code. As with fatality rates, you can add additional countries as arguments to get their statistics.

`covid-19 --loc US Gb br 00 aq tR AF` returns:
```───── COVID-19 STATUS: (US) ─────
Confirmed Cases:        2,137,731
Deaths:                   116,963
Recovered:                583,503
Fatality Rate:              16.6%

───── COVID-19 STATUS: (GB) ─────
Confirmed Cases:          299,600
Deaths:                    42,054
Recovered:                  1,259
Fatality Rate:              97.0%

───── COVID-19 STATUS: (BR) ─────
Confirmed Cases:          923,189
Deaths:                    45,241
Recovered:                      0
Fatality Rate:             4.90%*

──────── COVID-19 STATUS ────────
Confirmed Cases:        8,173,940
Deaths:                   443,685
Recovered:                950,238
Fatality Rate:              31.8%

───── COVID-19 STATUS: (AQ) ─────
Confirmed Cases:                0
Deaths:                         0
Recovered:                      0
Fatality Rate:                N/A

───── COVID-19 STATUS: (TR) ─────
Confirmed Cases:          181,298
Deaths:                     4,842
Recovered:                153,379
Fatality Rate:              3.06%

───── COVID-19 STATUS: (AF) ─────
Confirmed Cases:           26,310
Deaths:                       491
Recovered:                  5,508
Fatality Rate:              8.18%
─────────────────────────────────
Last updated: 12:40:24
```

(See note above regarding fatality rates)

## Prerequisites
This script requires [jq](https://stedolan.github.io/jq/download/) and [curl](https://curl.haxx.se/download.html). I've only tested this on macOS, but it *should* work on any *nix variants including Linux (although it may require a few tiny tweaks). You'll also need to have `zsh` installed for the interpreter to work properly.

## License

See [LICENSE.md](LICENSE.md) for the license. Please link to this repo somewhere in your project :).


[^1]: Calculated using `fatalities / (fatalities + recovered)` as per [WorldMeters.info](https://www.worldometers.info/coronavirus/coronavirus-death-rate/#correct) and the [American Journal of Epidemiology](https://academic.oup.com/aje/article/162/5/479/82647) For countries where there are no recorded recoveries, but there are recorded deaths (such as Brazil/`BR` in the example above), the alternative fatality formula of `cases / fatalities` is used and noted by an asterisk (`*`).
