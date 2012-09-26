require 'date'

module TddiumStatus
  class Project
    include Comparable
    attr_reader :name, :url, :status, :build_time, :activity

    def initialize(name, url, options = {})
      @name       = name
      @url        = url
      @status     = options[:status]
      @activity   = options[:activity]
      @build_time = options[:build_time]
      @build_time = DateTime.parse(@build_time).to_time if @build_time.is_a?(String)
    end

    def to_yaml_properties
      [:@name, :@url, :@status, :@build_time, :@activity]
    end

    def passing?
      status.nil? || status.strip == '' || status == 'Success'
    end

    def building?
      activity == 'Building'
    end

    def <=>(other)
      other.build_time.to_i <=> build_time.to_i
    end
  end
end
