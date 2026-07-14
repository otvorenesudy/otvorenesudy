namespace :storage do
  desc "Copy standard storage into distributed storage"
  task :distribute, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.distribute args[:src], args[:dst], args
  end

  desc "Copy distributed storage into standard storage"
  task :merge, [:src, :dst, :verbose] => :environment do |_, args|
    args.with_defaults verbose: false
    Core::Storage::Utils.merge args[:src], args[:dst], args
  end

  desc "Compute size statistics of distributed storage"
  task :stat, [:src, :verbose] => :environment do |_, args|
    Core::Storage::Utils.stat args[:src], args
  end
end
