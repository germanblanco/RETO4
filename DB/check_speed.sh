SELECT 
   max(creation_time),
   min(creation_time),
   count(1)
FROM
   http_request_time;
