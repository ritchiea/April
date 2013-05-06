module April
  class Querybuilder

    DEFAULTS = {}

    def self.build(config)
      query = reporting_period config
      query += self.send("build_#{config[:klass]}".downcase.to_sym, config) if DEFAULTS.keys.include? config[:klass].to_s.downcase.to_sym
      query += append_conditions config if config[:conditions].present?
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

      DEFAULTS.each do |k,v|
        define_method "build_#{k}".to_sym do |*args|
          config = args[0]
          result = DEFAULTS[k.to_sym]
          result += " AND #{config[:value_column]} > 0" if config[:type] == 'sum'
          result
        end
      end
    end

  end
end
