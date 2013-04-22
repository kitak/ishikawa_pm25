# coding: utf-8

class GraphController < ApplicationController
  def index
  end

  def show
    year = "2013"
    month = params[:month]
    day = params[:day]

    data = PM25.find(month: month, day: day)
    if data.empty?
      render :status => 404, :nothing => true
      return 
    end

    # TODO: 横軸用のデータ．グラフの生成に利用している．ビューヘルパーに移す？
    @dates = 
      data.each_with_index.inject({}) do |buf, ((record), i)|
        buf[i] = record.fetch_time.strftime("%H").gsub(/\A0/, "") if i % 2 == 1 
        buf
      end
    @location_to_value = data.location_to_value(month: month, day: day)

    if params[:format] == "png"
      redis = Redis.new
      key = "ishikawa-pm25#{year}-#{month}-#{day}"
      unless (image = redis.get(key))
        image = generate_graph
        redis.set(key, image)
      end
      send_data image, type: 'png', disposition: "inline"
    else
      render :json => @location_to_values
    end
  end

  private
  def generate_graph
    g = ::Gruff::Line.new
    g.font = app[:font_path]
    g.x_axis_label = 'hour'
    g.y_axis_label = 'μg/m^3'
    g.maximum_value = 100
    g.minimum_value = 0
    @location_to_values.each do |k, v|
      g.data(k, v)
    end
    g.theme = {
      :background_colors => %w(white white),
      :marker_color => "#999",
      :font_color => "black"
    }
    g.labels = @dates
    g.to_blob('png')
  end
end
