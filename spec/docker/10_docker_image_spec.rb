require "docker_helper"

### DOCKER_IMAGE ###############################################################

describe "Docker image", :test => :docker_image do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_IMAGE #############################################################

  describe docker_image(ENV["DOCKER_IMAGE"]) do
    # Execute Serverspec command locally
    before(:each) { set :backend, :exec }
    it { is_expected.to exist }
  end

  ### OS #######################################################################

  describe "Operating system" do
    context "family" do
      # We can not simple test the os[:family] because CentOS is reported as "redhat"
      subject { file("/etc/centos-release") }
      it "sould eq \"centos\"" do
        expect(subject).to be_file
      end
    end
    context "locale" do
      context "CHARSET" do
        subject { command("echo ${CHARSET}") }
        it { expect(subject.stdout.strip).to eq("UTF-8") }
      end
      context "LANG" do
        subject { command("echo ${LANG}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
      context "LC_ALL" do
        subject { command("echo ${LC_ALL}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
    end
  end

  ### USERS ####################################################################

  describe "Users" do
    [
      # [user,                      uid,  primary_group]
      ["kibana",                    1000, "kibana"],
    ].each do |user, uid, primary_group|
      context user(user) do
        it { is_expected.to exist }
        it { is_expected.to have_uid(uid) } unless uid.nil?
        it { is_expected.to belong_to_primary_group(primary_group) } unless primary_group.nil?
      end
    end
  end

  ### GROUPS ###################################################################

  describe "Groups" do
    [
      # [group,                     gid]
      ["kibana",                    1000],
    ].each do |group, gid|
      context group(group) do
        it { is_expected.to exist }
        it { is_expected.to have_gid(gid) } unless gid.nil?
      end
    end
  end

  ### PACKAGES #################################################################

  describe "Packages" do
    [
      # [package,                   version,                    installer]
      "bash",
    ].each do |package, version, installer|
      describe package(package) do
        it { is_expected.to be_installed }                        if installer.nil? && version.nil?
        it { is_expected.to be_installed.with_version(version) }  if installer.nil? && ! version.nil?
        it { is_expected.to be_installed.by(installer) }          if ! installer.nil? && version.nil?
        it { is_expected.to be_installed.by(installer).with_version(version) } if ! installer.nil? && ! version.nil?
      end
    end
  end

  ### COMMANDS #################################################################

  describe "Commands" do
    [
      # [command,                           version,                args]
      ["/usr/share/kibana/bin/kibana",      ENV["DOCKER_VERSION"]],
    ].each do |command, version, args|
      describe "Command \"#{command}\"" do
        subject { file(command) }
        let(:version_regex) { /\W#{version}\W/ }
        let(:version_cmd) { "#{command} #{args.nil? ? "--version" : "#{args}"}" }
        it "should be installed#{version.nil? ? nil : " with version \"#{version}\""}" do
          expect(subject).to exist
          expect(subject).to be_executable
          expect(command(version_cmd).stdout).to match(version_regex) unless version.nil?
        end
      end
    end
  end

  ### FILES ####################################################################

  describe "Files" do
    files = [
      # [
      #   file,
      #   mode, user, group, [expectations],
      #   localdir, srcfile,
      #   match
      # ]
      [
        "/docker-entrypoint.sh",
        755, "root", "root", [:be_file],
      ],
      [
        "/docker-entrypoint.d/30-kibana-environment.sh",
        644, "root", "root", [:be_file, :eq_sha256sum]
      ],
      [
        "/docker-entrypoint.d/60-kibana-fragments.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/docker-entrypoint.d/70-kibana-settings.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/docker-entrypoint.d/80-kibana-opts.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/usr/share/kibana",
        755, "root", "root", [:be_directory],
      ],
      [
        "/usr/share/kibana/bin",
        755, "root", "root", [:be_directory],
      ],
      [
        "/usr/share/kibana/config",
        750, "kibana", "kibana", [:be_directory],
      ],
      [
        "/usr/share/kibana/config/kibana.docker.yml",
        640, "kibana", "kibana", [:be_file],
      ],
      [
        "/usr/share/kibana/config/kibana.server-certs.yml",
        640, "kibana", "kibana", [:be_file],
      ],
      [
        "/usr/share/kibana/config/kibana.yml",
        640, "kibana", "kibana", [:be_file],
        nil, nil,
        [
          "^# kibana.docker.yml$",
          "^# kibana.server-certs.yml$",
        ],
      ],
      [
        "/usr/share/kibana/data",
        750, "kibana", "kibana", [:be_directory],
      ],
      [
        "/usr/share/kibana/logs",
        750, "kibana", "kibana",   [:be_directory],
      ],
      [
        "/usr/share/kibana/plugins",
        755, "root", "root", [:be_directory],
      ],
      [
        "/usr/share/kibana/optimize",
        750, "kibana", "kibana", [:be_directory],
      ],
    ]

    if ENV["KIBANA_VERSION"].start_with?("4.") then
      files += [
        [
          "/docker-entrypoint.d/31-kb4x-environment.sh",
          644, "root", "root", [:be_file, :eq_sha256sum],
          "#{ENV["KIBANA_VERSION"]}/rootfs",
        ],
        [
          "/docker-entrypoint.d/61-kb4x-fragments.sh",
          644, "root", "root", [:be_file, :eq_sha256sum],
          "#{ENV["KIBANA_VERSION"]}/rootfs",
        ],
      ]
    end

    files.each do |file, mode, user, group, expectations, rootfs, srcfile, match|
      expectations ||= []
      rootfs = "rootfs" if rootfs.nil?
      srcfile = file if srcfile.nil?
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        case match
        when String
          its(:content) { is_expected.to match(match) }
        when Array
          match.each do |m|
            its(:content) { is_expected.to match(m) }
          end
        end
        its(:sha256sum) do
          is_expected.to eq(
            Digest::SHA256.file("#{rootfs}/#{srcfile}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ### XPACK_FILES ##############################################################

  describe "X-Pack Files", :test => :docker_image, :x_pack => true do
    [
      # [
      #   file,
      #   mode, user, group, [expectations],
      #   rootfs, srcfile,
      #   match,
      # ]
      [
        "/docker-entrypoint.d/32-x-pack-environment.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/docker-entrypoint.d/62-x-pack-fragments.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/docker-entrypoint.d/72-x-pack-settings.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/kibana/config/kibana.x-pack.basic.yml",
        640, "kibana", "kibana", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/kibana/config/kibana.x-pack.gold.yml",
        640, "kibana", "kibana", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/kibana/config/kibana.x-pack.platinum.yml",
        640, "kibana", "kibana", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/kibana/config/kibana.yml",
        640, "kibana", "kibana", [:be_file],
        nil, nil,
        [
          "^# kibana.docker.yml$",
          "^# kibana.server-certs.yml$",
          "^# kibana.x-pack.#{ENV["XPACK_EDITION"]}.yml$",
        ],
      ],
      [
        "/usr/share/kibana/plugins/x-pack",
        755, "root", "root", [:be_directory],
      ],
    ].each do |file, mode, user, group, expectations, rootfs, srcfile, match|
      expectations ||= []
      rootfs = "rootfs" if rootfs.nil?
      srcfile = file if srcfile.nil?
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        case match
        when String
          its(:content) { is_expected.to match(match) }
        when Array
          match.each do |m|
            its(:content) { is_expected.to match(m) }
          end
        end
        its(:sha256sum) do
          is_expected.to eq(
            Digest::SHA256.file("#{rootfs}/#{srcfile}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end

  end

  ############################################################################################################################################################

end

################################################################################
