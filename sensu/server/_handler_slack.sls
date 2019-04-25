
/etc/sensu/conf.d/slack.json:
  file.managed:
  - source: salt://sensu/files/handlers/slack.json
  - template: jinja
  - defaults:
    handler_name: "{{ handler_name }}"
    handler_setting: "config"
  - watch_in:
    - service: service_sensu_server
    - service: service_sensu_api
  - require_in:
    - file: sensu_conf_dir_clean

/etc/sensu/conf.d/handler_slack.json:
  file.managed:
  - source: salt://sensu/files/handlers/slack.json
  - template: jinja
  - defaults:
    handler_name: "{{ handler_name }}"
    handler_setting: "handler"
  - watch_in:
    - service: service_sensu_server
    - service: service_sensu_api
  - require_in:
    - file: sensu_conf_dir_clean

/etc/sensu/handlers/slack.rb:
  file.managed:
  - source: salt://sensu/files/plugins/handlers/notification/slack.rb
  - makedirs: True
  - mode: 700
  - user: sensu
  - watch_in:
    - service: service_sensu_server
    - service: service_sensu_api