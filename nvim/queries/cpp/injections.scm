; extends

((string_literal
  (string_content) @injection.content)
  (#lua-match? @injection.content "^[%s\n]*(SELECT|select|WITH|with|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|TRUNCATE|truncate|MERGE|merge|REPLACE|replace|UPSERT|upsert|PRAGMA|pragma|EXPLAIN|explain)")
  (#set! injection.language "sql"))

((raw_string_literal
  delimiter: (raw_string_delimiter) @_delimiter
  (raw_string_content) @injection.content)
  (#eq? @_delimiter "sql")
  (#set! injection.language "sql"))

((raw_string_literal
  (raw_string_content) @injection.content)
  (#lua-match? @injection.content "^[%s\n]*(SELECT|select|WITH|with|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|TRUNCATE|truncate|MERGE|merge|REPLACE|replace|UPSERT|upsert|PRAGMA|pragma|EXPLAIN|explain)")
  (#set! injection.language "sql"))
