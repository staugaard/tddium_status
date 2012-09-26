require 'tddium_status/version'
require 'tddium_status/configuration'
require 'tddium_status/feed'
require 'tddium_status/project'

module TddiumStatus
  CONFIGURATION = Configuration.new
  MAX_AGE       = 60 * 60 * 24 * 7 # a week in seconds

  def self.configuration
    CONFIGURATION
  end

  def self.feeds
    configuration.feeds
  end

  def self.projects(max_age = MAX_AGE)
    projects = feeds.map(&:projects).flatten
    projects = projects.select do |project|
      project.building? || (project.build_time.to_i > (Time.now.to_i - max_age))
    end
    projects.sort
  end

  def self.refresh_every
    60
  end
end
