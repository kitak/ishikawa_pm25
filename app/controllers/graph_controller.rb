# coding: utf-8

class GraphController < ApplicationController
  def index
    @months = [3]
    @days = (8..Time.now.day).to_a
  end

  def show
    month = params[:month]
    day = params[:day]
    data = PM25.find(month: month, day: day)

    if data.empty?
      render :status => 404, :nothing => true
      return 
    end

    # TODO: モデルの仕事では？
    dates = 
      data.each_with_index.inject({}) do |buf, ((record), i)|
        buf[i] = record.fetch_time.strftime("%H").gsub(/\A0/, "") if i % 2 == 1 
        buf
      end
    location_to_values =
      data.inject({}) do |buf, (record)|
        record.locations.each do |loc|
          buf[loc.name] ||= []
          val = loc.value < 0 ? 0 : loc.value
          buf[loc.name] << val
        end
        buf
      end

    if params[:format] == "png"
      # TODO: グラフの生成をメソッドに分割する
      g = ::Gruff::Line.new
      # TODO: 環境でパスが違う
      g.font = "/Library/Fonts/ヒラギノ角ゴ Pro W3.otf"
      g.x_axis_label = 'hour'
      g.y_axis_label = 'μg/m^3'
      g.maximum_value = 100
      g.minimum_value = 0
      location_to_values.each do |k, v|
        g.data(k, v)
      end
      g.theme = {
        :background_colors => %w(white white),
        :marker_color => "#999",
        :font_color => "black"
      }
      g.labels = dates 

      send_data g.to_blob('png'), type: 'png', disposition: "inline"
    else
      render :json => location_to_values
    end
  end
end
