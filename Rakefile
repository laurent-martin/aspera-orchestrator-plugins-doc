# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require_relative 'lib/aspera_orchestrator_doc_generator'

# working folder
def build_main_dir
  "build/#{ENV['VERSION']}/"
end

def build_src_dir
  "#{build_main_dir}src/"
end

def build_out_dir
  "#{build_main_dir}out/"
end

desc 'Build all documentation'
task default: "#{build_out_dir}doc.created"

# requires: brew install wkhtmltopdf
file "#{build_out_dir}doc.created" => ["#{build_out_dir}doc.html"] do
  pwd = Dir.pwd
  version = ENV['VERSION']

  sh "wkhtmltopdf --enable-local-file-access file://#{pwd}/#{build_out_dir}doc.html #{build_out_dir}Orchestrator_#{version}_Plugin_Manual.pdf"
  sh "wkhtmltopdf --enable-local-file-access file://#{pwd}/#{build_out_dir}summary.html #{build_out_dir}Orchestrator_#{version}_Plugin_List.pdf"
  sh "wkhtmltopdf --enable-local-file-access -O landscape file://#{pwd}/#{build_out_dir}banner.html #{build_out_dir}Orchestrator_#{version}_Plugin_Banner.pdf"

  touch "#{build_out_dir}doc.created"
end

# build doc (create latest link)
file "#{build_out_dir}doc.html" => [build_main_dir] do
  version = ENV['VERSION']
  AsperaOrchestratorDocGenerator.new.build_doc(version, build_src_dir, build_out_dir)
end

directory build_main_dir do
  puts 'do: VERSION=xxx RPM=/path/to/rpm rake extract_rpm  or  rake extract_remote'
  exit 1
end

desc 'Extract RPM package'
task :extract_rpm do
  rpm = ENV['RPM']
  version = ENV['VERSION']

  raise 'set RPM env var' if rpm.nil? || rpm.empty?
  raise 'set VERSION env var' if version.nil? || version.empty?

  puts "Version: #{version}"

  mkdir_p build_main_dir
  mkdir_p build_out_dir
  mkdir_p "#{build_src_dir}lib"
  mkdir_p "#{build_main_dir}rpmout"

  sh "rpm2cpio #{rpm} | (cd #{build_main_dir}rpmout && cpio -idv \"*\" \"*/actions/*\" \"*/lib/action_tools.rb\")"
  sh "mv #{build_main_dir}rpmout/opt/aspera/orchestrator*/actions #{build_src_dir}"
  sh "mv #{build_main_dir}rpmout/opt/aspera/orchestrator*/lib/action_tools.rb #{build_src_dir}lib"
  # sh "rm -fr #{build_main_dir}rpmout"
end

desc 'Extract from remote server'
task :extract_remote do
  rpm = ENV['RPM']
  version = ENV['VERSION']
  ascp = ENV['ASCP']
  keys = ENV['KEYS']
  remote_host = ENV['REMOTE_HOST']
  remote_user = ENV['REMOTE_USER']

  raise 'set RPM env var' if rpm.nil? || rpm.empty?
  raise 'set VERSION env var' if version.nil? || version.empty?

  puts "Version: #{version}"

  mkdir_p build_main_dir
  mkdir_p build_out_dir
  mkdir_p "#{build_src_dir}lib"

  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} --src-base=/opt/aspera/orchestrator/actions /opt/aspera/orchestrator/actions #{build_src_dir}actions"
  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} /opt/aspera/orchestrator/lib/action_tools.rb #{build_src_dir}lib"
end

desc 'Clean generated files'
task :clean do
  rm_f Dir.glob("#{build_out_dir}*.{html,pdf,created}")
end

# Made with Bob
