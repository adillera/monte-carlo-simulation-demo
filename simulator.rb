require 'date'
require 'csv'
require './team_data.rb'
include TeamData

class Simulator
  def initialize(target_tickets, start_date, run_time = 1000000)
    @total_runs = run_time
    @start_date = start_date
    @target_tickets = target_tickets
    @t_len = throughput.size - 1
    @h_len = hotfix.size - 1
  end

  def simulate
    progress_bar = []
    forecasts = {}
    round_ctr = 0

    while round_ctr != @total_runs
      if round_ctr % 100000 == 0
        progress_bar << "="

        puts progress_bar.to_s
      end

      current_date = @start_date
      delivery_date = run_randomizer(current_date, forecasts)

      forecasts[delivery_date.to_s] += 1

      round_ctr += 1
    end

    write_csv(forecasts)

    puts 'Done Forecasting'
  end

  private
  def run_randomizer(current_date, forecasts)
    delivered_tickets = 0

    while delivered_tickets < @target_tickets
      unless current_date.saturday? || current_date.sunday?
        forecasts[current_date.to_s] = 0 if forecasts[current_date.to_s].nil?

        t_done = throughput[rand(0..@t_len)]
        h_done = hotfix[rand(0..@h_len)]

        if t_done < h_done
          delivered_tickets += 0
        else
          delivered_tickets += t_done - h_done
        end
      end

      if delivered_tickets < @target_tickets
        current_date = current_date.next_day(1)
      else
        current_date = current_date
      end
    end

    current_date
  end

  def write_csv(forecasts)
    CSV.open('./result.csv', 'w') do |csv|
      forecasts.to_a.each do |forecast|
        csv << forecast
      end
    end
  end
end
