# ProcmonAnalyser

Tired of applying your filters on procmon again and again?

Have a pretty fixed way of starting the investigation?

You've come to the right place!

ProcmonAnalyser parses your procmon log file (csv) with pre-defined filters, and outputs every filter result to a different file.
Oh, and it also eliminates duplicates so you'll have a much-less messy filtered result.

## How to use
1. **start** procmon and capture what you need.
2. **save** the captured events in a csv format (not the defualt PML), with the default name (procmon.csv).
3. **run** ProcmonAnalyser.ps1 and wait for the filtered results to show up.

### Kibana Dashboard
I love Elastic. Naturally this csv file found its way to my index, and got a nice dashboard.
The dashboard simply has all the filters from the powershell script, shown in one place.

![example](https://raw.githubusercontent.com/h3xcalibur/ProcmonAnalyser/master/KibanaDashboards/kibana.jpeg)
![example](https://raw.githubusercontent.com/h3xcalibur/ProcmonAnalyser/master/KibanaDashboards/kibana2.jpeg)
![example](https://raw.githubusercontent.com/h3xcalibur/ProcmonAnalyser/master/KibanaDashboards/kibana3.jpeg)
![example](https://raw.githubusercontent.com/h3xcalibur/ProcmonAnalyser/master/KibanaDashboards/kibana4.jpeg)

## Keep in touch
This is only the beginning. Questions, requests, comments, and everything else will be happily recived

- [X] Upload basic working script
- [X] Elasticsearch dashboard from the filters
- [ ] MORE interesting filters

