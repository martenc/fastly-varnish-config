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
vcls: []
wordpress: []
