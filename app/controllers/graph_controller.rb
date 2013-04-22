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

    @location_to_values = data.location_to_values
    # TODO: デコレータを使うべき？
    @dates = GraphController.helpers.x_axis(data)

    if params[:format] == "png"
      redis = Redis.new
      #TODO: グラフの生成タスクを作成してcronで動かす
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
