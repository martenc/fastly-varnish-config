backends:
- name: azure faux cdn
  address: 168.61.69.232
  auto_loadbalance: false
  between_bytes_timeout: 10000
  client_cert: 
  comment: ''
  connect_timeout: 1000
  error_threshold: 0
  first_byte_timeout: 15000
  healthcheck: periodic faux cdn check
  hostname: 
  ipv4: 168.61.69.232
  ipv6: 
  max_conn: 200
  port: 83
  request_condition: ''
  shield: sjc-ca-us
  ssl_ca_cert: 
  ssl_client_cert: 
  ssl_client_key: 
  ssl_hostname: 
  use_ssl: false
  weight: 100
cache_settings: []
comment: ''
conditions: []
deployed: 
directors: []
domains:
- name: cdn.thrillservice.com
  comment: ''
gzips: []
headers: []
healthchecks:
- name: periodic faux cdn check
  check_interval: 15000
  comment: ''
  expected_response: 200
  host: acura.com
  http_version: '1.1'
  initial: 4
  method: GET
  path: http://sdvn.cloudapp.net:83/AcuraWebfonts/index.html
  threshold: 3
  timeout: 5000
  window: 5
inherit_service_id: 
matches: []
origins: []
request_settings: []
response_objects: []
service_id: ER2x9TWeMrhwx4XwOeLbl
settings:
  general.default_host: sdvn.cloudapp.net
  general.default_pci: 0
  general.default_ttl: 3600
staging: 
testing: 
vcls:
- name: redundancy
  content: |-
    sub vcl_recv {
    #FASTLY recv
       if (req.request != "HEAD" && req.request != "GET" && req.request != "FASTLYPURGE") {
         return(pass);
       }
       return(lookup);
    }
    sub vcl_fetch {
      /* handle 5XX (or any other unwanted status code) */
      if (beresp.status >= 500 && beresp.status < 600) {
        /* deliver stale if the object is available */
        if (stale.exists) {
          return(deliver_stale);
        }
        if (req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
          restart;
        }
        /* else go to vcl_error to deliver a synthetic */
        error 503;
      }
      /* set stale_if_error and stale_while_revalidate (customize these values) */
      set beresp.stale_if_error = 86400s;
      set beresp.stale_while_revalidate = 60s;
    #FASTLY fetch
     if ((beresp.status == 500 || beresp.status == 503) && req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
       restart;
     }
     if(req.restarts > 0 ) {
       set beresp.http.Fastly-Restarts = req.restarts;
     }
     if (beresp.http.Set-Cookie) {
       set req.http.Fastly-Cachetype = "SETCOOKIE";
       return (pass);
     }
     if (beresp.http.Cache-Control ~ "private") {
       set req.http.Fastly-Cachetype = "PRIVATE";
       return (pass);
     }
     /* this code will never be run, commented out for clarity */
     /* if (beresp.status == 500 || beresp.status == 503) {
       set req.http.Fastly-Cachetype = "ERROR";
       set beresp.ttl = 1s;
       set beresp.grace = 5s;
       return (deliver);
     } */
     if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~"(s-maxage|max-age)") {
       # keep the ttl here
     } else {
       # apply the default ttl
       set beresp.ttl = 3600s;
     }
     return(deliver);
    }
    sub vcl_hit {
    #FASTLY hit
     if (!obj.cacheable) {
       return(pass);
     }
     return(deliver);
    }
    sub vcl_miss {
    #FASTLY miss
     return(fetch);
    }
    sub vcl_deliver {
    #FASTLY deliver
     return(deliver);
    }
    sub vcl_error {
    #FASTLY error
     /* handle 503s */
     if (obj.status >= 500 && obj.status < 600) {
       /* deliver stale object if it is available */
       if (stale.exists) {
         return(deliver_stale);
       }
       /* otherwise, return a synthetic */
       /* optional, rewrite status code */
       /* set obj.status = 200; */
       /* set obj.response = "OK"; */
       /* include your HTML response here */
       synthetic {"<!DOCTYPE html>There is a problem with the origin: <br>http://sdvn.cloudapp.net:83/</html>"};
       return(deliver);
     }
    }
    sub vcl_pass {
    #FASTLY pass
    }
  main: true
wordpress: []
