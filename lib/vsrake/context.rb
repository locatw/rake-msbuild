# coding: utf-8

module VSRake
  class Context
    attr_accessor :exe, :solution, :options

    def initialize
      exe = ""
      solution = ""
      options = []
    end
  end
end
