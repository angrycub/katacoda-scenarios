echo "Additional scenario specific provisioning..."

mkdir -p /opt/consul/ca /etc/consul.d/tls
cd /opt/consul/ca
consul tls ca create > /dev/null
consul tls cert create -server > /dev/null
consul tls cert create -client > /dev/null
cp consul-agent-ca.pem /etc/consul.d/tls
cp dc1-server-consul-0* /etc/consul.d/tls
cp dc1-client-consul-0* /etc/consul.d/tls

mkdir -p /opt/nomad/ca /etc/nomad.d/tls
cd /opt/nomad/ca
consul tls ca create -domain=nomad > /dev/null
consul tls cert create -domain=nomad -dc=global -server > /dev/null
consul tls cert create -domain=nomad -dc=global -client > /dev/null
cp nomad-agent-ca.pem /etc/nomad.d/tls
cp global-server-nomad-0* /etc/nomad.d/tls
cp global-client-nomad-0* /etc/nomad.d/tls

cat > ~/tls_environment <<EOF
echo "Preloading TLS Environment Variables..."
export CONSUL_CAPATH="/etc/consul.d/tls/consul-agent-ca.pem"
export CONSUL_CLIENT_CERT="/etc/consul.d/tls/dc1-server-consul-0.pem"
export CONSUL_CLIENT_KEY="/etc/consul.d/tls/dc1-server-consul-0-key.pem"
export CONSUL_HTTP_ADDR="https://127.0.0.1:8501"
export NOMAD_CAPATH="/etc/nomad.d/tls/nomad-agent-ca.pem"
export NOMAD_CLIENT_CERT="/etc/nomad.d/tls/global-server-nomad-0.pem"
export NOMAD_CLIENT_KEY="/etc/nomad.d/tls/global-server-nomad-0-key.pem"
export NOMAD_ADDR="https://127.0.0.1:4646"

echo $ export CONSUL_CAPATH="/etc/nomad.d/tls/nomad-agent-ca.pem"
echo $ export CONSUL_CLIENT_CERT="/etc/consul.d/tls/dc1-server-consul-0.pem"
echo $ export CONSUL_CLIENT_KEY="/etc/consul.d/tls/dc1-server-consul-0-key.pem"
echo $ export CONSUL_HTTP_ADDR="https://127.0.0.1:8300"
echo $ export NOMAD_CAPATH="/etc/nomad.d/tls/nomad-agent-ca.pem"
echo $ export NOMAD_CLIENT_CERT="/etc/nomad.d/tls/global-server-nomad-0.pem"
echo $ export NOMAD_CLIENT_KEY="/etc/nomad.d/tls/global-server-nomad-0-key.pem"
echo $ export NOMAD_ADDR="https://127.0.0.1:4646"
EOF