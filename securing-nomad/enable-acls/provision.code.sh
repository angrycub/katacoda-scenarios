rm -f /provision_complete; while [ ! -x /usr/local/bin/provision.sh ]; do sleep 1; done; /usr/local/bin/provision.sh; /usr/local/bin/provision_scenario_post.sh; source ~/tls_environment
