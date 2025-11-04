# Cross-Schema References in dbt: A Complete Guide

## Overview

One of the powerful features in dbt is the ability to reference tables and models from different schemas within your data warehouse. This capability enables modular data architecture where transformations can reference upstream data across organizational or functional boundaries. Understanding how to properly configure cross-schema references is essential for building scalable and maintainable dbt projects.

## The Challenge

By default, dbt creates all models within a single target schema defined in your `profiles.yml`. When you need to reference a table or model from a different schema—whether it's a staging database, a shared analytics schema, or an external source—you need explicit configuration to tell dbt where to find that reference and how to resolve it.

## The Solution: Schema Configuration and Macros

### Step 1: Configure the Model with Schema Override

The first part of the solution involves explicitly specifying which schema the model should reference. Add the `config()` function to your model file with the desired schema:

```sql
{{ config(
    schema="customer_schema",
)}}
```

This configuration tells dbt to create or reference this model in the `customer_schema` rather than the default target schema. This is particularly useful when:

- You have upstream models in a staging schema that you want to reference
- You're organizing models by business domain (customers, products, orders, etc.)
- You need to maintain separation between raw data, staging, and mart layers

### Step 2: Add the Generate Schema Name Macro

The critical piece that makes cross-schema references work seamlessly is the `generate_schema_name` macro. This macro must be added to your `macros` folder (typically `macros/generate_schema_name.sql`):

```jinja2
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```

### How the Macro Works

This macro intercepts the schema name generation process and implements conditional logic:

1. **`default_schema = target.schema`**: Captures the default schema from your target database connection (defined in `profiles.yml`)

2. **`if custom_schema_name is none`**: Checks if a custom schema was explicitly specified in the model's config

3. **Return Logic**:
   - If no custom schema is provided, use the default target schema
   - If a custom schema is provided, use it exactly as specified (trimmed of whitespace)

This approach gives you granular control: models without explicit schema configuration automatically use your target schema, while models with schema configuration override the default behavior.

## Key Considerations

**Schema Creation Permissions**: Ensure your database user has permissions to create schemas and tables in all referenced schemas.

**Environment-Specific Configuration**: You may want to conditionally set schemas based on environment (dev vs. prod). Extend the macro to check `target.name`:

```jinja2
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if target.name == 'prod' and custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
    {%- elif target.name == 'dev' -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name if custom_schema_name is not none else default_schema }}
    {%- endif -%}
{%- endmacro %}
```

**Documentation**: Clearly document your schema structure in your dbt project documentation so team members understand which models belong to which schemas.

## Conclusion

Cross-schema references in dbt are achieved through a combination of model-level configuration and a carefully crafted `generate_schema_name` macro. This pattern enables sophisticated data warehouse architecture while maintaining clean, readable dbt code. By centralizing schema name generation logic in a macro, you ensure consistency across your project and gain the flexibility to adjust schema resolution logic based on environment or other context.