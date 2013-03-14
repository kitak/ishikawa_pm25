class GraphController < ApplicationController
  def show
    month = params[:month]
    day = params[:day]
    data = PM25.find(month: month, day: day)

    dates = 
      data.each_with_index.inject({}) do |buf, ((record), i)|
        buf[i] = record.fetch_time.strftime("%H")
        buf
      end
    location_to_values =
      data.inject({}) do |buf, (record)|
        record.locations.each do |loc|
          buf[loc.name] ||= []
          buf[loc.name] << loc.value
        end
        buf
      end



    render :json => location_to_values
  end
end
