require 'yaml/store'

module TddiumStatus
  class Configuration
    def initialize(path = self.class.default_path)
      @store = YAML::Store.new(path)
    end

    def feeds
      @feeds ||= @store.transaction do
        @store[:feeds] ||= []
      end
    end

    def feeds=(feeds)
      @store.transaction do
        @store[:feeds] = feeds || []
      end
    end

    def save_feed(feed)
      feeds = self.feeds
      feeds << feed unless feeds.include?(feed)
      self.feeds = feeds
    end

    def self.default_path
      File.join(Dir.home, '.tddium_status.yml')
    end
  end
end
