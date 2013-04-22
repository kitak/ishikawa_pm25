
class PM25
  class << self
    def find(option={})
      year = option[:year] || "2013"
      month = option[:month].to_s.rjust(2, "0")
      day = option[:day].to_s.rjust(2, "0")
      day_data = MyDrip.read_tag(start_key, "collect_pm25_date=#{year}-#{month}-#{day}", 24)
      
      day_data.map { |record|
        if record[1]["fetch_time"].kind_of? String
          record[1]["fetch_time"] = DateTime.parse(record[1]["fetch_time"]) 
        end
        Hashie::Mash.new(record[1])
      }
    end

    private
    def start_key
      k, = MyDrip.head(1, 'collect_pm25_start')[0]
      k
    end
  end

  def location_to_value
    Rails.logger.info self
    self.inject({}) do |buf, (record)|
      record.locations.each do |loc|
        buf[loc.name] ||= []
        val = loc.value < 0 ? 0 : loc.value
        buf[loc.name] << val
      end
      buf
    end
  end
end
