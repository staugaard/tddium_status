require 'uri'
require 'open-uri'
require 'rexml/document'

module TddiumStatus
  class Feed
    attr_accessor :patterns

    def initialize(url, patterns = nil)
      @url_string = URI.parse(url.to_s).to_s
      @patterns   = patterns
      @updated_at = nil
    end

    def to_yaml_properties
      [:@url_string, :@patterns, :@updated_at, :@projects]
    end

    def url
      @url = URI.parse(@url_string) if @url_string.is_a?(String)
    end

    def add_pattern(pattern)
      return if @patterns && @patterns.include?(pattern)
      @patterns ||= []
      @patterns << pattern
      expire
    end

    def needs_refresh?
      (@updated_at.to_i + TddiumStatus.refresh_every) < Time.now.to_i
    end

    def document
      @document = nil if needs_refresh?

      @document ||= REXML::Document.new(url.read)
    end

    def projects
      @projects = nil if needs_refresh?

      return @projects if @projects

      @projects = document.root.elements.map do |project_element|
        project_name   = project_element.attributes['name']
        project_url    = project_element.attributes['webUrl']
        project_options = {
          :status     => project_element.attributes['lastBuildStatus'],
          :build_time => project_element.attributes['lastBuildTime'],
          :activity   => project_element.attributes['activity']
        }

        project = Project.new(project_name, project_url, project_options)

        matches_pattern?(project) ? project : nil
      end.compact

      @updated_at = Time.now
      save

      @projects
    end

    def matches_pattern?(project)
      return true if patterns.nil?

      patterns.any? do |pattern|
        project.name =~ pattern
      end
    end

    def expire
      @updated_at = nil
    end

    def save
      TddiumStatus.configuration.save_feed(self)
    end

  end
end
