# Changelog

## Unreleased

* Add `ESV.parse(data, header_converters:)` [#9]

[#9]: https://github.com/barsoom/excel-esv/pull/9

## 3.0.0 (Nov 20, 2018)

* Returns the last value of any formula cells instead of returning a `Spreadsheet::Formula`.
* Returns the URL of any link cells instead of returning a `Spreadsheet::Link`.

## 2.0.0 (Nov 19, 2018)

* `parse` now returns an actual nested `Array`, not array-like `Spreadsheet::Row` records.

## 1.0.0 (Dec 8, 2017)

* `send_excel` now supports a `filename:` argument, e.g. `send_excel(data, filename: "salaries.xls")`.
