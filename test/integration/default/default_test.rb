# # encoding: utf-8

# Inspec test for recipe test::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# This is an example test, replace it with your own test.
describe package 'docker' do
  it { should be_installed }
end
describe service 'docker' do
  it { should be_running }
end
describe file ('/etc/docker/daemon.json') do
  it { should be_file }
end
describe file ('/etc/docker/daemon.json') do
  its ('content') { should match "{ \"insecure-registries\" : [\"192.168.0.10:5000\"] }" }
end