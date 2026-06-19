# frozen_string_literal: true

# Stub classes and modules for missing dependencies
# These are used during documentation generation to avoid loading actual gems

FTPFXPTLS = nil
FTPFXP = nil
module ActiveRecord
  class Base
    def self.has_many(*); end
  end
end

class ApplicationRecord
end

module ProgressObserver
end

module AsperaFiles
  AUTHORIZATION_SCOPES = []
end

module ActiveAssignment
  INPUT_PROVIDER_VAR = 'input_provider'
end

module Action
  TRIG_ABSOLULE = 'absolute'
  TRIG_STEP = 'by step'
  TRIG_GROUP = 'by workorder group'
  TRIG_WORKFLOW = 'by workflow'
  TRIG_ACTION = 'by action template'
  TRIG_NONE = 'none'

  TYPE_INT = 'int'
  TYPE_FLOAT = 'float'
  TYPE_STRING = 'string'
  TYPE_ARRAY = 'array'
  TYPE_HASH = 'hash'
  TYPE_FLAG = 'flag'
  TYPE_DATE = 'date'
  TYPE_OBJECT = 'object'
  TYPE_PASSWORD = 'pwd'
  TYPE_ATTACHMENT = 'attachment'
end

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

  def self.root
    @root ||= Pathname.new('.')
  end
end

class WorkInput
  def self.clone_for_workstep
  end

  def self.has_many(*args)
  end
end

module Config
end

module VcmqAnalyzer
  OUT_TARGET_FILE = 'out_target_file'
  OUT_REPORT = 'out_report'
end

class Database < ApplicationRecord
  DATABASE_MYSQL = 'Mysql'
end

class OrchConfig
  def self.get
    self
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

  def self.archive_dir
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
  STATUS_FAILED = 'failed'
  def self.runtime_basedir(a)
    '.'
  end
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
  def self.release
    '1.0.0'
  end

  def self.exec_dir
    '/tmp'
  end
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
