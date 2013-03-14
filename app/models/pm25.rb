
class PM25
  class << self
    def find(option={})
      year = option[:year] || "2013"
      month = option[:month].to_s.rjust(2, "0")
      day = option[:day].to_s.rjust(2, "0")
      MyDrip.read_tag(start_key, "collect_pm25_date=#{year}-#{month}-#{day}", 24)
      #key = start_key
      #buf = []
      #while key 
        #tmp = MyDrip.read_tag(key, "collect_pm25_date=#{year}-#{month}-#{day}", 10)
        #buf.concat tmp
        #key = tmp[-1] ? tmp[-1][0] : nil
      #end
      #buf
    end

    private
    def start_key
      k, = MyDrip.head(1, 'collect_pm25_start')[0]
      k
    end
  end
end
