# coding: utf-8

module VSRake
  class Config
    attr_accessor :exe, :solution
  end

  attr_reader :config

  def self.configure(&block)
    @config = Config.new
    yield @config
  end

end
