# -*- coding: utf-8 -*-
require 'tofu'
require 'pathname'
require 'pp'
require_relative 'name'

module Tofu
  class Tofu
    def normalize_string(str_or_param)
      str ,= str_or_param
      return '' unless str
      str.force_encoding('utf-8').strip
    end
  end
end

module PoWo
  class Session < Tofu::Session
    def initialize(bartender, hint='')
      super
      @base = BaseTofu.new(self)
      @user = nil
    end
    attr_reader :user
    
    def do_GET(context)
      context.res_header('cache-control', 'no-store')
      super(context)
    end

    def lookup_view(context)
      @base
    end
  end

  class BaseTofu < Tofu::Tofu
    set_erb(__dir__ + '/base.html')

    def initialize(session)
      super(session)
      @doc = PoWo::dp_filter
      @mode = 'dp'
    end

    def doc
      @doc
    end

    def tofu_id
      'base'
    end

    def pathname(context)
      script_name = context.req_script_name
      script_name = '/' if script_name.empty?
      Pathname.new(script_name)
    end

    def do_login(context, params)
      @login.show = true
    end

    def do_logout(context, params)
      @session.logout
    end

    def to_a
      doc.to_a
    end
    
    def do_ignore(context, params)
      name = normalize_string(params['w'])
      @doc.add_ignore(name)
    end

    def do_keep(context, params)
      ch = normalize_string(params['w'])
      @doc.add_keep(ch)
    end

    def do_dp(context, params)
      @doc = PoWo::dp_filter
      @mode = 'dp'
    end

    def do_all(context, params)
      @doc = PoWo::all_filter
      @mode = 'all'
    end
  end
end