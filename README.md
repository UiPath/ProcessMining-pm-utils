# pm-utils
Utility functions for process mining related dbt projects.

## Installation instructions
See the instructions *How do I add a package to my project?* in the [dbt documentation](https://docs.getdbt.com/docs/building-a-dbt-project/package-management). The pm-utils is a public git repository, so the packages can be installed using the git syntax:

```
packages:
  - git: "https://github.com/UiPath-Process-Mining/pm-utils.git" # git URL
    revision: [tag name of the release]
```

To use the macros of this package, you may need to define variables in your `dbt_project.yml`. Per macro is indicated which variables need to be defined. The following shows an example configuration of the variables:

```
vars:
  # Name of the schema where the transformations run.
  schema: "my_schema"
  # Date and time formats.
  # For SQL Server defined by integers and for Snowflake defined by strings.
  date_format: 23 # SQL Server: 23, Snowflake: 'YYYY-MM-DD'
  time_format: 8 # SQL Server: 8, Snowflake: 'hh24:mi:ss'
  datetime_format: 20 # SQL Server: 20, Snowflake: 'YYYY-MM-DD hh24:mi:ss.ff3'
```

## Contents
This dbt package contains macros for SQL functions to run the dbt project on multiple databases and for generic tests. The databases that are currently supported are Snowflake and SQL Server.

- [Multiple databases](#Multiple-databases)
  - [date_from_timestamp](#date_from_timestamp-source)
  - [left_from_char](#left_from_char-source)
  - [string_agg](#string_agg-source)
  - [timestamp_from_date](#timestamp_from_date-source)
  - [timestamp_from_parts](#timestamp_from_parts-source)
  - [to_date](#to_date-source)
  - [to_double](#to_double-source)
  - [to_integer](#to_integer-source)
  - [to_time](#to_time-source)
  - [to_timestamp](#to_timestamp-source)
  - [to_varchar](#to_varchar-source)
- [Generic tests](#Generic-tests)
  - [test_edgecount](#test_edgecount-source)
  - [test_equal_rowcount](#test_equal_rowcount-source)
  - [test_exists](#test_exists-source)
  - [text_startplacecount_sinkplacecount](#test_startplacecount_sinkplacecount-source)
  - [test_type_boolean](#test_type_boolean-source)
  - [test_type_date](#test_type_date-source)
  - [test_type_double](#test_type_double-source)
  - [test_type_integer](#test_type_integer-source)
  - [test_type_timestamp](#test_type_timestamp-source)
  - [test_unique_combination_of_columns](#test_unique_combination_of_columns-source)
  - [test_values_nonnegative](#test_values_nonnegative-source)

### Multiple databases

#### date_from_timestamp ([source](macros/multiple_databases/date_from_timestamp.sql))
This macro extracts the date part from a datetime attribute. 

Usage: 
`{{ date_from_timestamp([expression]) }}`

#### left_from_char ([source](macros/multiple_databases/left_from_char.sql))
This macro extracts the string left from the character.

Usage: 
`{{ left_from_char([attribute], [character]) }}`

#### string_agg ([source](macros/multiple_databases/string_agg.sql))
This macro aggregates string attributes separated by the given delimiter. If no delimiter is specified, strings are separated by a comma followed by a space. This macro can only be used as an aggregate function.

Usage:
`{{ string_agg([expression], [delimiter]) }}`

#### timestamp_from_date ([source](macros/multiple_databases/timestamp_from_date.sql))
This macro creates a timestamp based on only a date attribute. The time part of the timestamp is set to 00:00:00. 

Usage:
`{{ timestamp_from_date([expression]) }}`

#### timestamp_from_parts ([source](macros/multiple_databases/timestamp_from_parts.sql))
This macro create a timestamp based on a date and time attribute.

Usage: 
`{{ timestamp_from_parts([date_expression], [time_expression]) }}`

#### to_date ([source](macros/multiple_databases/to_date.sql))
This macro converts an attribute to a date attribute.

Usage: 
`{{ to_date([expression]) }}`

Variables: 
- date_format

#### to_double ([source](macros/multiple_databases/to_double.sql))
This macro converts an attribute to a double attribute.

Usage: 
`{{ to_double([expression]) }}`

#### to_integer ([source](macros/multiple_databases/to_integer.sql))
This macro converts an attribute to an integer attribute.

Usage: 
`{{ to_integer([expression]) }}`

#### to_time ([source](macros/multiple_databases/to_time.sql))
This macro converts an attribute to a time attribute.

Usage: 
`{{ to_time([expression]) }}`

Variables: 
- time_format

#### to_timestamp ([source](macros/multiple_databases/to_timestamp.sql))
This macro converts an attribute to a timestamp attribute.

Usage: 
`{{ to_timestamp([expression]) }}`

Variables: 
- datetime_format

#### to_varchar ([source](macros/multiple_databases/to_varchar.sql))
This macro converts an attribute to a string attribute.

Usage: 
`{{ to_varchar([expression]) }}`

### Generic tests

#### test_edgecount ([source](macros/generic_tests/test_edgecount.sql))
This generic test evaluates whether the number of edges coincide with the number of cases and events.

Usage:
```
models:
  - name: Edge_table_A
    tests:
	  - pm_utils.edgecount:
       	case_model: Case_table_A
       	event_model: Event_table_A
```

Variables:
- schema

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

Variables: 
- schema

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

#### text_startplacecount_sinkplacecount ([source](macros/generic_tests/test_startplacecount_sinkplacecount.sql))
This generic test evaluates whether every case has a startplace and a sinkplace.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.startplacecount_sinkplacecount:
          compare_model: 'Model_B'
```

Variables:
- schema


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

Variables: 
- schema

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

Variables: 
- schema

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

Variables: 
- schema

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

Variables: 
- schema

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

#### test_values_nonnegative ([source](macros/generic_tests/test_values_nonnegative.sql))
This generic test whether the values of the column are nonnegative.

Usage:
```
models:
  - name: Model_A
    tests:
      - pm_utils.values_nonnegative:
          column_name: "'Column_A'"
```
