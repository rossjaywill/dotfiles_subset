; extends

((string
  (string_content) @injection.content)
  (#lua-match? @injection.content "^[%s\n]*(SELECT|select|WITH|with|INSERT|insert|UPDATE|update|DELETE|delete|CREATE|create|ALTER|alter|DROP|drop|TRUNCATE|truncate|MERGE|merge|REPLACE|replace|UPSERT|upsert|PRAGMA|pragma|EXPLAIN|explain)")
  (#set! injection.language "sql"))
