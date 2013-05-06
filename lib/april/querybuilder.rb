module April
  class Querybuilder

    def self.build(config)
      query = reporting_period config
      query += append_conditions config if !config[:conditions].empty?
      query
    end

    class << self
      private
      def reporting_period(config)
        result = '' 
        result += "#{config[:date_column]} >= '#{config[:start_date]}' AND "
        result += "#{config[:date_column]} <= '#{config[:end_date]}'"
        result
      end

      def append_conditions(config)
        result = ''
        result += " AND #{config[:conditions]} "
        result
      end

    end

  end
end
