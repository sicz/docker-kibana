require "docker_helper"

### SERVER_CERTIFICATE #########################################################

describe "Server certificate", :test => :server_cert do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### CONFIG ###################################################################

  crt         = ENV["SERVER_CRT_FILE"]        || "/usr/share/kibana/config/server.crt"
  crt_subj    = ENV["SERVER_CRT_SUBJECT"]     || "CN=#{ENV["CONTAINER_NAME"]}"
  crt_user    = ENV["SERVER_CRT_FILE_USER"]   || "kibana"
  crt_group   = ENV["SERVER_CRT_FILE_GROUP"]  || "kibana"
  crt_mode    = ENV["SERVER_CRT_FILE_MODE"]   || 640

  key         = ENV["SERVER_KEY_FILE"]        || "/usr/share/kibana/config/server.key"
  key_pwd     = ENV["SERVER_KEY_PWD_FILE"]    || "/usr/share/kibana/config/server.pwd"
  key_user    = ENV["SERVER_KEY_FILE_USER"]   || "kibana"
  key_group   = ENV["SERVER_KEY_FILE_GROUP"]  || "kibana"
  key_mode    = ENV["SERVER_KEY_FILE_MODE"]   || 640

  ### CERTIFICATE ##############################################################

  describe x509_certificate(crt) do
    context "file" do
      subject { file(crt) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(crt_mode) }
      it { is_expected.to be_owned_by(crt_user) }
      it { is_expected.to be_grouped_into(crt_group) }
    end
    context "certificate" do
      it { is_expected.to be_certificate }
      it { is_expected.to be_valid }
    end
    its(:subject) { is_expected.to eq "/#{crt_subj}" }
    its(:issuer) { is_expected.to eq "/CN=Simple CA" }
    its(:validity_in_days) { is_expected.to be > 3650 }
    context "subject_alt_names" do
      if ! ENV["SERVER_CRT_HOST"].nil? then
        ENV["SERVER_CRT_HOST"].split(/,/).each do |host|
          it { expect(subject.subject_alt_names).to include("DNS:#{host}") }
        end
      end
      it { expect(subject.subject_alt_names).to include("DNS:#{ENV["CONTAINER_NAME"]}") }
      it { expect(subject.subject_alt_names).to include("DNS:localhost") }
      it { expect(subject.subject_alt_names).to include("IP Address:#{ENV["SERVER_CRT_IP"]}") } unless ENV["SERVER_CRT_IP"].nil?
      it { expect(subject.subject_alt_names).to include("IP Address:127.0.0.1") }
      it { expect(subject.subject_alt_names).to include("Registered ID:#{ENV["SERVER_CRT_OID"]}") } unless ENV["SERVER_CRT_OID"].nil?
    end
  end

  ### PRIVATE_KEY_PASSPHRASE ###################################################

  describe "X509 private key passphrase \"#{key_pwd}\"" do
    context "file" do
      subject { file(key_pwd) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(key_mode) }
      it { is_expected.to be_owned_by(key_user) }
      it { is_expected.to be_grouped_into(key_group) }
    end
  end

  ### PRIVATE_KEY ##############################################################

  describe x509_private_key(key, {:passin => "file:#{key_pwd}"}) do
    context "file" do
      subject { file(key) }
      it { is_expected.to be_file }
      it { is_expected.to be_mode(key_mode) }
      it { is_expected.to be_owned_by(key_user) }
      it { is_expected.to be_grouped_into(key_group) }
    end
    context "key" do
      it { is_expected.to be_encrypted }
      it { is_expected.to be_valid }
      it { is_expected.to have_matching_certificate(crt) }
    end
  end

  ##############################################################################

end

################################################################################
