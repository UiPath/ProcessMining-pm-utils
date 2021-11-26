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
  # Set the used database. Supported options: "sqlserver", "snowflake".
  database: "sqlserver"
  # Name of the schema where the transformations run.
  schema: "my_schema"
  # Date and time formats.
  # For SQL Server defined by integers and for Snowflake defined by strings.
  date_format: 23 # sqlserver: 23, snowflake: 'YYYY-MM-DD'
  time_format: 8 # sqlserver: 8, snowflake: 'hh24:mi:ss'
  datetime_format: 20 # sqlserver: 20, snowflake: 'YYYY-MM-DD hh24:mi:ss.ff3'
```

## Contents
This dbt package contains macros for SQL functions to run the dbt project on multiple databases and for generic tests. The databases that are currently supported are Snowflake and SQL Server.

- [Multiple databases](#Multiple-databases)
  - [date_from_timestamp](#date_from_timestamp-source)
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
  - [test_equal_rowcount](#test_equal_rowcount-source)
  - [test_exists](#test_exists-source)
  - [test_type_boolean](#test_type_boolean-source)
  - [test_type_date](#test_type_date-source)
  - [test_type_double](#test_type_double-source)
  - [test_type_integer](#test_type_integer-source)
  - [test_type_timestamp](#test_type_timestamp-source)
  - [test_unique_combination_of_columns](#test_unique_combination_of_columns-source)

### Multiple databases

#### date_from_timestamp ([source](macros/multiple_databases/date_from_timestamp.sql))
This macro extracts the date part from a datetime attribute. 

Usage: 
`{{ date_from_timestamp([expression]) }}`

Variables:
- database

#### string_agg ([source](macros/multiple_databases/string_agg.sql))
This macro aggregates string attributes separated by the given delimiter. This macro can only be used as an aggregate function.

Usage:
`{{ string_agg([expression], [delimiter]) }}`

Variables:
- database

#### timestamp_from_date ([source](macros/multiple_databases/timestamp_from_date.sql))
This macro creates a timestamp based on only a date attribute. The time part of the timestamp is set to 00:00:00. 

Usage:
`{{ timestamp_from_date([expression]) }}`

Variables:
- database

#### timestamp_from_parts ([source](macros/multiple_databases/timestamp_from_parts.sql))
This macro create a timestamp based on a date and time attribute.

Usage: 
`{{ timestamp_from_parts([date_expression], [time_expression]) }}`

Variables: 
- database

#### to_date ([source](macros/multiple_databases/to_date.sql))
This macro converts an attribute to a date attribute.

Usage: 
`{{ to_date([expression]) }}`

Variables: 
- database
- date_format

#### to_double ([source](macros/multiple_databases/to_double.sql))
This macro converts an attribute to a double attribute.

Usage: 
`{{ to_double([expression]) }}`

Variables: 
- database

#### to_integer ([source](macros/multiple_databases/to_integer.sql))
This macro converts an attribute to an integer attribute.

Usage: 
`{{ to_integer([expression]) }}`

Variables: 
- database

#### to_time ([source](macros/multiple_databases/to_time.sql))
This macro converts an attribute to a time attribute.

Usage: 
`{{ to_time([expression]) }}`

Variables: 
- database
- time_format

#### to_timestamp ([source](macros/multiple_databases/to_timestamp.sql))
This macro converts an attribute to a timestamp attribute.

Usage: 
`{{ to_timestamp([expression]) }}`

Variables: 
- database
- datetime_format

#### to_varchar ([source](macros/multiple_databases/to_varchar.sql))
This macro converts an attribute to a string attribute.

Usage: 
`{{ to_varchar([expression]) }}`

Variables: 
- database

### Generic tests

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
              table: "'Model_A'"
              column: "'Column_A'"
```

Variables: 
- database
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
              table: "'Model_A'"
              column: "'Column_A'"
```

Variables: 
- database
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
              table: "'Model_A'"
              column: "'Column_A'"
```

Variables: 
- database
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
              table: "'Model_A'"
              column: "'Column_A'"
```

Variables: 
- database
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
            - '"Column_A"'
            - '"Column_B"'
```
