; extends

((string_literal) @injection.content
  (#lua-match? @injection.content "^\"[%s\n]*(SELECT|select|WITH|with|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|TRUNCATE|truncate|MERGE|merge|REPLACE|replace|UPSERT|upsert|PRAGMA|pragma|EXPLAIN|explain)")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((raw_string_literal
  (string_content) @injection.content)
  (#lua-match? @injection.content "^[%s\n]*(SELECT|select|WITH|with|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|TRUNCATE|truncate|MERGE|merge|REPLACE|replace|UPSERT|upsert|PRAGMA|pragma|EXPLAIN|explain)")
  (#set! injection.language "sql"))
