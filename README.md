# pm-utils
Utility functions for process mining related dbt projects.

## Installation instructions
See the instructions *How do I add a package to my project?* in the [dbt documentation](https://docs.getdbt.com/docs/building-a-dbt-project/package-management). The pm-utils is a public git repository, so the packages can be installed using the git syntax:

```
packages:
  - git: "https://github.com/UiPath/ProcessMining-pm-utils.git"
    revision: [tag name of the release]
```

This package contains some date/datetime conversion macros. You can override the default format that is used in the macros by defining variables in your `dbt_project.yml`. The following shows an example configuration of the possible date and time formatting variables and their default values:

```
vars:
  # Date and time formats.
  # For SQL Server defined by integers and for Snowflake defined by strings.
  date_format: 23     # default: SQL Server: 23, Snowflake: 'YYYY-MM-DD'
  time_format: 14     # default: SQL Server: 14, Snowflake: 'hh24:mi:ss.ff3'
  datetime_format: 21 # default: SQL Server: 21, Snowflake: 'YYYY-MM-DD hh24:mi:ss.ff3'
```

## Contents
This dbt package contains macros for SQL functions to run the dbt project on multiple databases. The databases that are currently supported are Snowflake and SQL Server.

- [SQL generators](#SQL-generators)
  - [create_index](#create_index-source)
  - [id](#id-source)
  - [mandatory](#mandatory-source)
  - [optional](#optional-source)
  - [optional_table](#optional_table-source)
  - [star](#star-source)
- [Data type cast functions](#Data-type-cast-functions)
  - [as_varchar](#as_varchar-source)
  - [to_boolean](#to_boolean-source)
  - [to_date](#to_date-source)
  - [to_double](#to_double-source)
  - [to_integer](#to_integer-source)
  - [to_timestamp](#to_timestamp-source)
  - [to_varchar](#to_varchar-source)
- [Date time functions](#Date-time-functions)
  - [date_from_timestamp](#date_from_timestamp-source)
  - [dateadd](#dateadd-source)
  - [datediff](#datediff-source)
  - [diff_weekdays](#diff_weekdays-source)
  - [timestamp_from_date](#timestamp_from_date-source)
  - [timestamp_from_parts](#timestamp_from_parts-source)
- [String functions](#String-functions)
  - [charindex](#charindex-source)
  - [concat](#concat-source)
- [Aggregate functions](#Aggregate-functions)
  - [stddev](#stddev-source)
  - [string_agg](#string_agg-source)
- [Tests](#Tests)
  - [test_equal_rowcount](#test_equal_rowcount-source)
  - [test_exists](#test_exists-source)
  - [test_not_negative](#test_not_negative-source)
  - [test_not_null](#test_not_null-source)
  - [test_one_column_not_null](#test_one_column_not_null-source)
  - [test_unique_combination_of_columns](#test_unique_combination_of_columns-source)
  - [test_unique](#test_unique-source)

### SQL generators

#### create_index ([source](macros/SQL_generators/create_index.sql))
This macro creates a clustered columnstore index on the current model for SQL Server. This macro should be used in a dbt post-hook.

Usage:
```
{{ config(
    post_hook="{{ pm_utils.create_index() }}"
) }}
```

In case you want to create the index on a source table, refer to the table using the source function in the argument. Use the macro in a pre-hook of the model where you use the source table.

```
{{ config(
    pre_hook="{{ pm_utils.create_index(source('[source_name]', '[source_table]')) }}"
) }}
```

#### id ([source](macros/SQL_generators/id.sql))
This macro generates an id field that can be used as a column for the current model.

Usage:
`{{ pm_utils.id() }}`

#### mandatory ([source](macros/SQL_generators/mandatory.sql))
Use this macro for the mandatory columns in your source tables. Use the optional argument `data_type` to indicate the data type of the column. Possible values are: `boolean`, `date`, `double`, `integer`, `datetime`, and `text`. When no data type is set, the column is considered to be text.

You can also set `id` as data type, which expects the values to be integers.

Usage:
`{{ pm_utils.mandatory(source('source_name', 'table_name'), '"Column_A"', 'data_type') }}`

To keep the SQL in the model more readable, you can define a Jinja variable for the reference to the source table:

`{% set source_table = source('source_name', 'table_name') %}`

Variables:
- date_format
- datetime_format

These variables are only required when the `data_type` is used with the values `date` or `datetime`.

#### optional ([source](macros/SQL_generators/optional.sql))
This macro checks in a table whether a column is present. If the column is not present, it creates the column with `null` values. If the column is present, it selects the column from the table. Use this macro to allow for missing columns in your source tables when that data is optional. Use the optional argument `data_type` to indicate the data type of the column. Possible values are: `boolean`, `date`, `double`, `integer`, `datetime`, and `text`. When no data type is set, the column is considered to be text.

You can also set `id` as data type, which creates the column with unique integer values if the column is not present. If the column is present in that case, the values are expected to be integers.

Usage:
`{{ pm_utils.optional(source('source_name', 'table_name'), '"Column_A"', 'data_type') }}`

Alternatively, you can use this macro for non-source data. Use instead of the source function the ref function: `ref(table_name)`. In that case, data type casting is not applied.

To keep the SQL in the model more readable, you can define a Jinja variable for the reference to the source table:

`{% set source_table = source('source_name', 'table_name') %}`

Variables:
- date_format
- datetime_format

These variables are only required when the `data_type` is used with the values `date` or `datetime`.

#### optional_table ([source](macros/SQL_generators/optional_table.sql))
This macro checks whether the source table is present. If the table is not present, it creates a table without records in your target schema. If the table is present, it selects the table from the source schema. Use this macro to allow for missing source tables when that data is optional.

Usage:
`{{ pm_utils.optional_table(source('source_name', 'table_name')) }}`

Note: you can only apply the macro for source tables in combination with the `optional()` macro applied to all its fields.

#### star ([source](macros/SQL_generators/star.sql))
This macro generates a select statement of all fields that are available on the given relation. This relation can be a source or a model in the dbt project. Optionally, you can provide a list of fields as the second argument that need to be excluded from the select statement.

You can choose to exclude fields from the select statement, for example:
- When you don't want to expose a field on next transformation steps.
- When you apply logic to a field and don't want to keep the original.
- When you join tables and a field with the same name is available on multiple tables.

Make sure to put the relation also in the from clause. Otherwise, the table from which you select can't be found.

Usage:

Select all fields from model `Table_A`.
```
select
    {{ pm_utils.star(ref('Table_A')) }}
from {{ ref('Table_A') }}
```

Select all fields from source `Table_A`.
```
select
    {{ pm_utils.star(source('sources', 'Table_A')) }}
from source('sources', 'Table_A')
```

Select all fields from `Table_A`, except for the field `Creation_date`. More fields can be added to the except list. Additional select statements can be written before and after the `star()` macro by separating the statements with a comma.
```
select
    {{ pm_utils.star(ref('Table_A'), except=['Creation_date']) }},
    {{ pm_utils.to_date('"Creation_date"') }} as "Creation_date"
from {{ ref('Table_A') }}
```

### Data type cast functions

#### as_varchar ([source](macros/data_type_cast_functions/as_varchar.sql))
This macro converts a string to the data type `nvarchar(2000)` for SQL Server. Use the macro `to_varchar()` to convert a field to this data type.

Usage: 
`{{ pm_utils.as_varchar('[expression]') }}`

#### to_boolean ([source](macros/data_type_cast_functions/to_boolean.sql))
This macro converts a field to a boolean field.

Usage: 
`{{ pm_utils.to_boolean('[expression]') }}`

#### to_date ([source](macros/data_type_cast_functions/to_date.sql))
This macro converts a field to a date field. The expression can be in a date or a datetime format.

Usage: 
`{{ pm_utils.to_date('[expression]') }}`

Variables:
- date_format

#### to_double ([source](macros/data_type_cast_functions/to_double.sql))
This macro converts a field to a double field.

Usage: 
`{{ pm_utils.to_double('[expression]') }}`

#### to_integer ([source](macros/data_type_cast_functions/to_integer.sql))
This macro converts a field to an integer field.

Usage: 
`{{ pm_utils.to_integer('[expression]') }}`

#### to_timestamp ([source](macros/data_type_cast_functions/to_timestamp.sql))
This macro converts a field to a timestamp field. 

Usage: 
`{{ pm_utils.to_timestamp('[expression]') }}`

Variables:
- datetime_format

#### to_varchar ([source](macros/data_type_cast_functions/to_varchar.sql))
This macro converts a field to the data type `nvarchar(2000)` for SQL Server. Use the macro `as_varchar()` to convert a string to the this data type.

Usage: 
`{{ pm_utils.to_varchar('[expression]') }}`

### Date time functions

#### date_from_timestamp ([source](macros/date_time_functions/date_from_timestamp.sql))
This macro extracts the date part from a datetime field. 

Usage: 
`{{ pm_utils.date_from_timestamp('[expression]') }}`

#### dateadd ([source](macros/date_time_functions/dateadd.sql))
This macro adds the specified number of units for the `datepart` to a date or datetime expression. The `datepart` can be any of the following values: year, quarter, month, week, day, hour, minute, second, millisecond. The number of units will be interpreted as an integer value.

Usage: 
`{{ pm_utils.dateadd('[datepart]', '[number]', '[date_expression]') }}`

#### datediff ([source](macros/date_time_functions/datediff.sql))
This macro computes the difference between two date or datetime expressions based on the specified `datepart` and returns an integer value. The datepart can be any of the following values: year, quarter, month, week, day, hour, minute, second, millisecond. Weeks are defined from Sunday to Saturday.

Usage: 
`{{ pm_utils.datediff('[datepart]', '[start_date_expression]', '[end_date_expression]') }}`

#### diff_weekdays ([source](macros/date_time_functions/diff_weekdays.sql))
This macro computes the number of days between a start and end date. It returns one day when the start and end date are on the same date. The Saturdays and Sundays are excluded from the number of days.

Usage: 
`{{ pm_utils.diff_weekdays('[start_date_expression]', '[end_date_expression]') }}`

#### timestamp_from_date ([source](macros/date_time_functions/timestamp_from_date.sql))
This macro creates a timestamp based on only a date field. The time part of the timestamp is set to 00:00:00. 

Usage:
`{{ pm_utils.timestamp_from_date('[expression]') }}`

#### timestamp_from_parts ([source](macros/date_time_functions/timestamp_from_parts.sql))
This macro creates a timestamp based on a date field and string containing the time field.

Variables:
- time_format

Usage: 
`{{ pm_utils.timestamp_from_parts('[date_expression]', '[time_expression]') }}`

### String functions

#### charindex ([source](macros/string_functions/charindex.sql))
This macro returns the starting position of the first occurrence of a string in another string. The search is not case-sensitive. If the string is not found, the function returns 0. This macro can be used to check whether a string contains another string.

Usage: 
`{{ pm_utils.charindex('[expression_to_find]', '[field]', '[start_location]') }}`

#### concat ([source](macros/string_functions/concat.sql))
This macro concatenates two or more strings together. In case a value is `null` it is concatenated as the empty string `''`. 

Usage: 
`{{ pm_utils.concat('"Field_A"', '"Field_B"') }}`

To pass a string as argument, make sure to use double quotes:
`{{ pm_utils.concat('"Field_A"', "' - '", '"Field_B"') }}`

### Aggregate functions

#### stddev ([source](macros/aggregate_functions/stddev.sql))
This macro computes the standard deviation of a set of values, `null` values are ignored in the calculation. This macro can only be used as an aggregate function. For SQL Server, at least one of the values provided should not be `null`.

Usage: 
`{{ pm_utils.stddev('[expression]') }}`

#### string_agg ([source](macros/aggregate_functions/string_agg.sql))
This macro aggregates string fields separated by the given delimiter. If no delimiter is specified, strings are separated by a comma followed by a space. This macro can only be used as an aggregate function. For SQL Server, the maximum supported length is 2000. 

Usage:
`{{ pm_utils.string_agg('[expression]', '[delimiter]') }}`

### Tests

#### test_equal_rowcount ([source](macros/tests/test_equal_rowcount.sql))
This generic test evaluates whether two models have the same number of rows.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.equal_rowcount:
          compare_model: 'Model_B'
```

#### test_exists ([source](macros/tests/test_exists.sql))
This generic test evaluates whether a model is available or if a column is available in the model. When used to check the existence of a column, the check is only executed when the model exists to prevent the same error occurring multiple times. You should add this test on the model level whenever the existence of the model is uncertain (e.g. source tests).

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.exists
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.exists
```

#### test_not_negative ([source](macros/tests/test_not_negative.sql))
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

#### test_not_null ([source](macros/tests/test_not_null.sql))
This generic test evaluates whether the values of the column are not null or empty. The test is only executed when the column exists on the table.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.not_null
```

#### test_one_column_not_null ([source](macros/tests/test_one_column_not_null.sql))
This generic test evaluates whether exactly one out of the specified columns does contain a value. This test can be defined by two or more columns. The test is only executed when all columns exist on the table.

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

#### test_unique_combination_of_columns ([source](macros/tests/test_unique_combination_of_columns.sql))
This generic test evaluates whether the combination of columns is unique. This test can be defined by two or more columns. The test is only executed when all columns exist on the table.

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

#### test_unique ([source](macros/tests/test_unique.sql))
This generic test evaluates whether the values of the column are unique. The test is only executed when the column exists on the table.

Usage:
```
models:
  - name: Model_A
    columns:
      - name: '"Column_A"'
        tests:
          - pm_utils.unique
```
