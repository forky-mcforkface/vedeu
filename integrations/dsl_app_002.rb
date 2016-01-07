#!/usr/bin/env ruby

# frozen_string_literal: true

require 'bundler/setup'
require 'vedeu'

class DSLApp

  Vedeu.bind(:_initialize_) { Vedeu.trigger(:_refresh_) }

  Vedeu.configure do
    debug!
    log '/tmp/vedeu_views_dsl.log'
    renderers [
                Vedeu::Renderers::Terminal.new(
                  filename:   '/tmp/dsl_app_002.out',
                  write_file: true),
                # Vedeu::Renderers::JSON.new(filename: '/tmp/dsl_app_002.json'),
                # Vedeu::Renderers::HTML.new(filename: '/tmp/dsl_app_002.html'),
                # Vedeu::Renderers::Text.new(filename: '/tmp/dsl_app_002.txt'),
              ]
    run_once!
    standalone!
  end

  load './support/test_interface.rb'

  Vedeu.render do
    view(:test_interface) do
      line 'view->line 1', { foreground: '#ff7f00' }
      line 'view->line 2', { foreground: '#ffff00' }
    end
  end

  def self.actual
    File.read('/tmp/dsl_app_002.out')
  end

  def self.expected
    File.read(File.expand_path('../expected/dsl_app_002.out', __FILE__))
  end

  def self.start(argv = ARGV)
    Vedeu::Launcher.execute!(argv)
  end

end # DSLApp

DSLApp.start

if DSLApp.expected == DSLApp.actual
  puts "#{__FILE__} \e[32mPassed.\e[39m"
else
  puts "#{__FILE__} \e[31mFailed.\e[39m"
end

