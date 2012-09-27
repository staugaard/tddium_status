require 'yaml'

module TddiumStatus
  class Configuration
    def initialize(path = self.class.default_path)
      @path = path
      @lock = Mutex.new
    end

    def feeds
      @feeds ||= transaction do |data|
        data[:feeds] ||= []
      end
    end

    def feeds=(feeds)
      transaction do |data|
        data[:feeds] = feeds || []
      end
    end

    def save_feed(feed)
      feeds = self.feeds
      feeds << feed unless feeds.include?(feed)
      self.feeds = feeds
    end

    def transaction(&block)
      @lock.synchronize do
        data = YAML.load(File.read(@path)) rescue {}
        result = block.call(data)
        File.open(@path, "w") do |f|
          f.write(YAML.dump(data))
        end
        result
      end
    end

    def self.default_path
      File.join(Dir.home, '.tddium_status.yml')
    end
  end
end
