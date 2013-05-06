require 'chronic'

class April

  DEFAULTS = { start_date: Chronic.parse("1 month ago 12:00am"),
               end_date: Chronic.parse("1 day ago 11:59pm"),
               date_format: '%-m-%-d',
               date_column: 'created_at',
               conditions: '',
               type: 'sum'}

  def self.get_report(options={})
    config = DEFAULTS.merge!(options)
    config[:start_date] = DateHelper.convert_time_zone config[:start_date]
    config[:end_date] = DateHelper.convert_time_zone config[:end_date]
    hash = {}

    query = Querybuilder.build config

    model = ( config[:klass].is_a? Class ) ? config[:klass] : eval(config[:klass].capitalize) 
    records = model.send :where, query

    records.each do |record|
      date = record.created_at.strftime(config[:date_format])
      if config[:type] == 'sum'
        hash[date] = 0 if hash[date].nil? 
        hash[date] += record.send config[:value_column].to_sym
      end
    end
    result = []
    if config[:type] == 'sum'
      hash.each { |k,v| result << {date: k, total: v} }
    end
    result
  end

end
