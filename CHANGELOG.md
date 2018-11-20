# 3.0.0

* Returns the last value of any formula cells instead of returning a `Spreadsheet::Formula`.
* Returns the URL of any link cells instead of returning a `Spreadsheet::Link`.

# 2.0.0

* `parse` now returns an actual nested `Array`, not array-like `Spreadsheet::Row` records.

# 1.0.0

* `send_excel` now supports a `filename:` argument, e.g. `send_excel(data, filename: "salaries.xls")`.
