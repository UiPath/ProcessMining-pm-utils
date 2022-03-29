# pm-utils
Utility functions for process mining related dbt projects.

## Installation instructions
See the instructions *How do I add a package to my project?* in the [dbt documentation](https://docs.getdbt.com/docs/building-a-dbt-project/package-management). The pm-utils is a public git repository, so the packages can be installed using the git syntax:

```
packages:
  - git: "https://github.com/UiPath/ProcessMining-pm-utils.git"
    revision: [tag name of the release]
```

This package contains some date/time conversion macros. You can override the default format that is used in the macros by defining variables in your `dbt_project.yml`. The following shows an example configuration of all the possible variables and the default values used:

```
vars:
  # Date and time formats.
  # For SQL Server defined by integers and for Snowflake defined by strings.
  date_format: 23     # default: SQL Server: 23, Snowflake: 'YYYY-MM-DD'
  time_format: 14     # default: SQL Server: 14, Snowflake: 'hh24:mi:ss.ff3'
  datetime_format: 21 # default: SQL Server: 21, Snowflake: 'YYYY-MM-DD hh24:mi:ss.ff3'
```

## Contents
This dbt package contains macros for SQL functions to run the dbt project on multiple databases and for generic tests. The databases that are currently supported are Snowflake and SQL Server.

- [Multiple databases](#Multiple-databases)
  - [date_from_timestamp](#date_from_timestamp-source)
  - [datediff](#datediff-source)
  - [string_agg](#string_agg-source)
  - [timestamp_from_date](#timestamp_from_date-source)
  - [timestamp_from_parts](#timestamp_from_parts-source)
  - [to_boolean](#to_boolean-source)
  - [to_date](#to_date-source)
  - [to_double](#to_double-source)
  - [to_integer](#to_integer-source)
  - [to_time](#to_time-source)
  - [to_timestamp](#to_timestamp-source)
  - [to_varchar](#to_varchar-source)
- [Generic tests](#Generic-tests)
  - [test_attribute_length](#test_attribute_length-source)
  - [test_edge_count](#test_edge_count-source)
  - [test_equal_rowcount](#test_equal_rowcount-source)
  - [test_exists](#test_exists-source)
  - [test_not_negative](#test_not_negative-source)
  - [test_one_column_not_null](#test_one_column_not_null-source)
  - [test_type_boolean](#test_type_boolean-source)
  - [test_type_date](#test_type_date-source)
  - [test_type_double](#test_type_double-source)
  - [test_type_integer](#test_type_integer-source)
  - [test_type_timestamp](#test_type_timestamp-source)
  - [test_unique_combination_of_columns](#test_unique_combination_of_columns-source)
- [Generic](#Generic)
  - [optional](#optional-source)
  - [left_from_char](#left_from_char-source)
- [Process mining tables](#Process-mining-tables)
  - [generate_edge_table](#generate_edge_table-source)
  - [generate_variant](#generate_variant-source)

### Multiple databases

#### date_from_timestamp ([source](macros/multiple_databases/date_from_timestamp.sql))
This macro extracts the date part from a datetime attribute. 

Usage: 
`{{ pm_utils.date_from_timestamp('[expression]') }}`

#### datediff ([source](macros/multiple_databases/datediff.sql))
This macro computes the difference between two date, time, or datetime expressions based on the specified `datepart` and returns an integer value. The datepart can be any of the following values: year, quarter, month, week, day, hour, minute, second, millisecond.

Usage: 
`{{ pm_utils.datediff('[datepart]', '[start_date_expression]', '[end_date_expression]') }}`

#### string_agg ([source](macros/multiple_databases/string_agg.sql))
This macro aggregates string attributes separated by the given delimiter. If no delimiter is specified, strings are separated by a comma followed by a space. This macro can only be used as an aggregate function.

Usage:
`{{ pm_utils.string_agg('[expression]', '[delimiter]') }}`

#### timestamp_from_date ([source](macros/multiple_databases/timestamp_from_date.sql))
This macro creates a timestamp based on only a date attribute. The time part of the timestamp is set to 00:00:00. 

Usage:
`{{ pm_utils.timestamp_from_date('[expression]') }}`

#### timestamp_from_parts ([source](macros/multiple_databases/timestamp_from_parts.sql))
This macro create a timestamp based on a date and time attribute.

Usage: 
`{{ pm_utils.timestamp_from_parts('[date_expression]', '[time_expression]') }}`

#### to_boolean ([source](macros/multiple_databases/to_boolean.sql))
This macro converts an attribute to a boolean attribute.

Usage: 
`{{ pm_utils.to_boolean('[expression]') }}`

#### to_date ([source](macros/multiple_databases/to_date.sql))
This macro converts an attribute to a date attribute.

Usage: 
`{{ pm_utils.to_date('[expression]') }}`

Variables:
- date_format

#### to_double ([source](macros/multiple_databases/to_double.sql))
This macro converts an attribute to a double attribute.

Usage: 
`{{ pm_utils.to_double('[expression]') }}`

#### to_integer ([source](macros/multiple_databases/to_integer.sql))
This macro converts an attribute to an integer attribute.

Usage: 
`{{ pm_utils.to_integer('[expression]') }}`

#### to_time ([source](macros/multiple_databases/to_time.sql))
This macro converts an attribute to a time attribute.

Usage: 
`{{ pm_utils.to_time('[expression]') }}`

Variables:
- time_format

#### to_timestamp ([source](macros/multiple_databases/to_timestamp.sql))
This macro converts an attribute to a timestamp attribute.

Usage: 
`{{ pm_utils.to_timestamp('[expression]') }}`

Variables:
- datetime_format

#### to_varchar ([source](macros/multiple_databases/to_varchar.sql))
This macro converts an attribute to a string attribute.

Usage: 
`{{ pm_utils.to_varchar('[expression]') }}`

### Generic tests

#### test_attribute_length ([source](macros/generic_tests/test_attribute_length.sql))
This generic test evaluates whether the values of the column have a particular length.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.attribute_length:
          length: 'Length'
```

#### test_edge_count ([source](macros/generic_tests/test_edge_count.sql))
This generic test evaluates whether the number of edges is as expected based on the event log. The expected number of edges is equal to the number of events plus the number of cases, since also edges from the source node and to the sink node are taken into account.

Usage:
```
models:
  - name: Edge_table_A
    tests:
      - pm_utils.edge_count:
          event_log: 'Event_log_model'
          case_ID: 'Case_ID'
```

#### test_equal_rowcount ([source](macros/generic_tests/test_equal_rowcount.sql))
This generic test evaluates whether two models have the same number of rows.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.equal_rowcount:
          compare_model: 'Model_B'
```

#### test_exists ([source](macros/generic_tests/test_exists.sql))
This generic test evaluates whether a column is available in the model.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.exists
```

#### test_not_negative ([source](macros/generic_tests/test_not_negative.sql))
This generic test evaluates whether the values of the column are not negative.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.not_negative
```

#### test_one_column_not_null ([source](macros/generic_tests/test_one_column_not_null.sql))
This generic test evaluates whether exactly one out of the specified columns does contain a value. This test can be defined by two or more columns.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.one_column_not_null:
          columns:
            - 'Column_A'
            - 'Column_B'
```

#### test_type_boolean ([source](macros/generic_tests/test_type_boolean.sql))
This generic test evaluates whether an attribute is a boolean represented by the numeric values 0 and 1.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.type_boolean
```

#### test_type_date ([source](macros/generic_tests/test_type_date.sql))
This generic test evaluates whether an attribute is a date data type.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.type_date
```

#### test_type_double ([source](macros/generic_tests/test_type_double.sql))
This generic test evaluates whether an attribute is a double data type.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.type_double
```

#### test_type_integer ([source](macros/generic_tests/test_type_integer.sql))
This generic test evaluates whether an attribute is an integer data type.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.type_integer
```

#### test_type_timestamp ([source](macros/generic_tests/test_type_timestamp.sql))
This generic test evaluates whether an attribute is a timestamp data type.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.type_timestamp
```

#### test_unique_combination_of_columns ([source](macros/generic_tests/test_unique_combination_of_columns.sql))
This generic test evaluates whether the combination of columns is unique. This test can be defined by two or more columns.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.unique_combination_of_columns:
          combination_of_columns:
            - 'Column_A'
            - 'Column_B'
```

### Generic

#### left_from_char ([source](macros/generic/left_from_char.sql))
This macro extracts the string left from the character.

Usage: 
`{{ pm_utils.left_from_char('[expression]', '[character]') }}`

#### optional ([source](macros/generic/optional.sql))
This macro checks in a table whether a column is present. If the column is not present, it creates the column with `null` values. If the column is present, it selects the column from the table. Use this macro to allow for missing columns in your source tables when that data is optional. Use the optional argument `data_type` to indicate the data type of the column. Possible values are: `boolean`, `date`, `double`, `integer`, `time`, `datetime`, and `text`. When no data type is set, the optional column is considered to be text. 

Usage:
`{{ pm_utils.optional(source(source_name, table_name), '"Column_A"', 'data_type') }}`

Alternatively, you can use this macro for non-source data. Use instead of the source function, the ref function: `ref(table_name)`.

To keep the SQL in the model more readable, you can define a Jinja variable for the reference to the source table:

`{% set source_table = source(source_name, table_name) %}`

Variables:
- date_format
- time_format
- datetime_format

These variables are only required when the `data_type` is used with the values `date`, `time`, or `datetime`.

### Process mining tables

#### generate_edge_table ([source](macros/process_mining_tables/generate_edge_table.sql))
The edge table contains all transitions in the process graph. Each transition is indicated by the `From_activity` and the `To_activtiy` and for which case this transition took place. The edge table includes transitions from the source node and to the sink node.

The required input is an event log model with attributes describing the case ID, activity, and event order. With the argument `table_name` you indicate how to name the generated table. The generated table contains at least the following columns: `Edge_ID`, one according to the given case ID, `From_activity` and `To_activity`. It also generates a column `Unique_edge`, which contains the value 1 once per occurrence of an edge per case.

Optional input is a list of properties. This generates columns like `Unique_edge`, which contains the value 1 once per occurrence of an edge per the given property. The name of this column is `Unique_edge` concatenated with the property.

Usage:
```
{{ pm_utils.generate_edge_table(
    table_name = 'Edge_table',
    event_log_model = 'Event_log',
    case_ID = 'Case_ID', 
    activity = 'Activity', 
    event_order = 'Event_order',
    properties = ['Property1', 'Property2'])
}}
```

This generates the table `Edge_table` with columns `Edge_ID`, `Case_ID`, `From_activity`, `To_activity`, `Unique_edge`, `Unique_edge_Property1` and `Unique_edge_Property2`.

#### generate_variant ([source](macros/process_mining_tables/generate_variant.sql))
A variant is a particular order of activities that a case executes. The most occurring variant is named "Variant 1", the next most occurring one "Variant 2", etc. This macro generates a cases table with for each case the variant. 

The required input is an event log model with attributes describing the case ID, activity, and event order. With the argument `table_name` you indicate how to name the generated table. The generated table contains two columns: one according to the given case ID and `Variant`.

Usage:
```
{{ pm_utils.generate_variant(
    table_name = 'Cases_table_with_variant',
    event_log_model = 'Event_log',
    case_ID = 'Case_ID',
    activity = 'Activity',
    event_order = 'Event_order')
}}
```

This generates the table `Cases_table_with_variant` with columns `Case_ID` and `Variant`.
