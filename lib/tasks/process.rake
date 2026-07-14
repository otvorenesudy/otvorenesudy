namespace :process do
  desc 'Process known paragraph descriptions'
  task paragraphs: :environment do
    require Rails.root.join('lib/justice_gov_sk/processor/paragraphs')
    # TODO: migrate to standalone service
    raise NotImplementedError, 'Paragraph processor has been removed with crawler infrastructure'
  end

  namespace :court_expenses do
    %w[2010 2011 2012 2013].each do |year|
      desc "Process court expenses from #{year}"
      task year.to_sym => :environment do
        raise NotImplementedError, 'Court expenses processor has been removed with crawler infrastructure'
      end
    end
  end

  desc 'Process court statistical summaries'
  namespace :court_statistical_summaries do
    %w[2011 2012].each do |year|
      desc "Process court statistical summaries from #{year}"
      task year.to_sym => :environment do
        raise NotImplementedError, 'Court statistical summaries processor has been removed with crawler infrastructure'
      end
    end
  end

  namespace :judge_designations do
    desc 'Process judge designations'
    task nrsr_sk: :environment do
      raise NotImplementedError, 'Judge designations processor has been removed with crawler infrastructure'
    end

    desc 'Process judge designations'
    task prezident_sk: :environment do
      raise NotImplementedError, 'Judge designations processor has been removed with crawler infrastructure'
    end
  end

  namespace :judge_statistical_summaries do
    %w[2011 2012].each do |year|
      desc "Process judge statistical summaries from #{year}"
      task year.to_sym => :environment do
        raise NotImplementedError, 'Judge statistical summaries processor has been removed with crawler infrastructure'
      end
    end
  end
end
