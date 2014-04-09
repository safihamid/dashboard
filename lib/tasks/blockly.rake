require 'fileutils'

require 'open3'

class << File
  alias_method :old_symlink, :symlink
  alias_method :old_symlink?, :symlink?

  def symlink(old_name, new_name)
    #if on windows, call mklink, else self.symlink
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #windows mklink syntax is reverse of unix ln -s
      #windows mklink is built into cmd.exe
      #vulnerable to command injection, but okay because this is a hack to make a cli tool work.
      stdin, stdout, stderr, wait_thr = Open3.popen3('cmd.exe', "/c mklink #{new_name} #{old_name}")
      wait_thr.value.exitstatus
    else
      self.old_symlink(old_name, new_name)
    end
  end

  def symlink?(file_name)
    #if on windows, call mklink, else self.symlink
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #vulnerable to command injection because calling with cmd.exe with /c?
      stdin, stdout, stderr, wait_thr = Open3.popen3("cmd.exe /c dir #{file_name} | find \"SYMLINK\"")
      wait_thr.value.exitstatus
    else
      self.old_symlink?(file_name)
    end
  end
end

namespace :blockly do

  def dist_project
    'blockly-mooc'
  end

  def dist_root
    "https://s3.amazonaws.com/cdo-dist/#{dist_project}"
  end

  def dist_version
    "#{dist_root}/VERSION"
  end

  def dist_file(version)
    "#{dist_root}/#{dist_project}-v#{version}.tgz"
  end

  def dest
    'public/blockly'
  end

  def clean!
    if File.symlink?(dest)
      File.unlink(dest)
    else
      FileUtils.rm_rf(dest)
    end
    FileUtils.rm_rf('.cache_bust')
  end

  task latest: :environment do
    puts "Asking #{dist_version} for latest version number"
    latest = `curl --silent --insecure #{dist_version}`.strip
    puts "Latest version: #{latest}"
    Rake::Task['blockly:get'].invoke(latest)
  end

  task :get, [:version] => :environment do |t, args|
    clean!
    filepath = dist_file(args[:version])
    puts "Downloading and extracting #{filepath}"
    curl_cmd = "curl --silent --insecure #{filepath}"
    dirname = File.dirname(dest)
    tar_cmd = "tar -xz -C #{dirname}"
    `#{curl_cmd} | #{tar_cmd}`
    FileUtils.mv("#{dirname}/package", dest)
    File.open('.cache_bust', 'w') { |f| f.write(args[:version]) }
  end

  task :dev, [:src] => :environment do |t, args|
    src = args[:src]
    unless src
      raise 'Expected argument: path to blockly mooc source.'
    end
    fullsrc = "#{File.absolute_path(src)}/build/package"
    unless File.directory?(fullsrc)
      raise "No such directory: #{fullsrc}"
    end
    clean!
    File.symlink(fullsrc, dest)
  end

end
