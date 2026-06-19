# frozen_string_literal: true

# Stub classes and modules for missing dependencies
# These are used during documentation generation to avoid loading actual gems

module Action; end
module ActiveRecord; class Base; end; end

module ActionsHelper
  MANDATORY = 'mandatory'
  ORDERED_LIST = 'ordered_list'
end

class String
  def html_safe
    self
  end
end

module Rails
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

class WorkInput
  def self.clone_for_workstep
  end

  def self.has_many(*args)
  end
end

class OrchConfig
  def self.get(*args)
    nil
  end

  def self.run_dir
    '/tmp'
  end

  def self.config_dir
    '/tmp'
  end

  def self.actionplugins_load_directory
    '/tmp'
  end
end

module ModuleSSHTools
end

module ModuleTriggerTools
end

module ModuleSoapTools
end

class ActionTools
end

class ManagedQueue
  DEFAULT_PRIORITY = 0
  DEFAULT_WEIGHT = 1
end

class ManagedResource
end

module Net
  module SSH
    module Transport
      module Kex
        class Curve25519Sha256
        end
      end
    end
  end

  class FTPFXPTLS
  end
end

class XMLParserError < StandardError
end

class MultiJson
end

class Carrot
end

module Engine
end

class AssetLayer
  class XSD
  end
end

# Stub method for silence_warnings
def silence_warnings
  yield
end

# Stub method for action_dir (make it public)
class Object
  def action_dir
    ''
  end
end
