# pm-utils
Utility functions for process mining related dbt projects.

## Installation instructions
See the instructions *How do I add a package to my project?* in the [dbt documentation](https://docs.getdbt.com/docs/building-a-dbt-project/package-management). The pm-utils is a public git repository, so the packages can be installed using the git syntax:

```
packages:
  - git: "https://github.com/UiPath-Process-Mining/pm-utils.git" # git URL
    revision: [tag name of the release]
```

## Contents
This dbt package contains macros for SQL functions to run the dbt project on multiple databases and for schema tests. The databases that are currently supported are Snowflake and SQL Server.

[Multiple databases](#Multiple-databases)
- [date_from_timestamp](#date_from_timestamp)
- [string_agg](#string_agg)

### Multiple databases

#### date_from_timestamp ([source](macros/multiple_databases/date_from_timestamp.sql))
This macro extracts the date part from a datetime attribute. 
- Snowflake: `to_date([expression])`
- SQL Server: `try_convert(date, [expression])`

Usage: `{{ date_from_timestamp([expression]) }}`

#### string_agg ([source](macros/multiple_databases/string_agg.sql))

#### timestamp_from_date ([source](macros/multiple_databases/timestamp_from_date.sql))

#### timestamp_from_parts ([source](macros/multiple_databases/timestamp_from_parts.sql))

#### to_date ([source](macros/multiple_databases/to_date.sql))

#### to_double ([source](macros/multiple_databases/to_double.sql))

#### to_integer ([source](macros/multiple_databases/to_integer.sql))

#### to_time ([source](macros/multiple_databases/to_time.sql))

#### to_timestamp ([source](macros/multiple_databases/to_timestamp.sql))

#### to_varchar ([source](macros/multiple_databases/to_varchar.sql))

### Schema tests

#### test_equal_rowcount ([source](macros/schema_tests/test_equal_rowcount.sql))

#### test_exists ([source](macros/schema_tests/test_exists.sql))

#### test_type_boolean ([source](macros/schema_tests/test_type_boolean.sql))

#### test_type_date ([source](macros/schema_tests/test_type_date.sql))

#### test_type_double ([source](macros/schema_tests/test_type_double.sql))

#### test_type_integer ([source](macros/schema_tests/test_type_integer.sql))

#### test_type_timestamp ([source](macros/schema_tests/test_type_timestamp.sql))

#### test_unique_combination_of_columns ([source](macros/schema_tests/test_unique_combination_of_columns.sql))
