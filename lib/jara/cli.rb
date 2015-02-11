# encoding: utf-8

require 'jara'
require 'optparse'

module Jara
  class Cli
    def initialize(argv)
      parse_argv(argv)
      options = {}
      options[:archiver] = @archiver if @archiver
      options[:build_command] = @build_command if @build_command
      @releaser = Jara::Releaser.new(@environment, @bucket, options)
    end

    def run
      if @release
        @releaser.release
      else
        @releaser.build_artifact
      end
    end

    private

    def parse_argv(argv)
      parser = OptionParser.new do |parser|
        parser.on('-r', '--[no-]release', 'Release artifact to S3') { |r| @release = r }
        parser.on('-b', '--bucket=BUCKET', 'S3 bucket for releases') { |b| @bucket = b }
        parser.on('-e', '--environment=ENV', 'Environment to release to (e.g. production, staging)') { |e| @environment = e }
        parser.on('-a', '--archiver=TYPE', 'Archiver to use (jar or tgz)') { |t| @archiver = t.to_sym }
        parser.on('-c', '--build-command=COMMAND', 'Command to run before creating the archive') { |c| @build_command = c }
      end
      parser.parse(argv)
    end
  end
end
