# coding: utf-8

class GraphController < ApplicationController
  def index
  end

  def show
    month = params[:month]
    day = params[:day]
    data = PM25.find(month: month, day: day)

    if data.empty?
      render :status => 404, :nothing => true
      return 
    end

    @dates = 
      data.each_with_index.inject({}) do |buf, ((record), i)|
        buf[i] = record.fetch_time.strftime("%H").gsub(/\A0/, "") if i % 2 == 1 
        buf
      end
    @location_to_values =
      data.inject({}) do |buf, (record)|
        record.locations.each do |loc|
          buf[loc.name] ||= []
          val = loc.value < 0 ? 0 : loc.value
          buf[loc.name] << val
        end
        buf
      end

    if params[:format] == "png"
      send_data generate_graph, type: 'png', disposition: "inline"
    else
      render :json => location_to_values
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
