module GraphHelper
  def x_axis_label(data)
    data.each_with_index.inject({}) do |buf, ((record), i)|
      buf[i] = record.fetch_time.strftime("%H").gsub(/\A0/, "") if i % 2 == 1 
      buf
    end
  end
end
