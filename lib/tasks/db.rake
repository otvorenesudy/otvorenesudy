Rake::Task['db:structure:dump'].clear
db_namespace =
  namespace :db do
    namespace :structure do
      desc 'Dump the database structure to db/structure.sql'
      task dump: %i[environment load_config] do
        config = current_config
        filename = ENV['DB_STRUCTURE'] || File.join(Rails.root, 'db', 'structure.sql')
        case config['adapter']
        when /postgresql/
          set_psql_env(config)
          search_path = config['schema_search_path']
          unless search_path.blank?
            search_path =
              search_path
                .split(',')
                .map { |search_path_part| "--schema=#{Shellwords.escape(search_path_part.strip)}" }
                .join(' ')
          end
          `pg_dump -s -x -O -f #{Shellwords.escape(filename)} #{search_path} #{Shellwords.escape(config['database'])}`
          raise 'Error dumping database' if $?.exitstatus == 1
          File.open(filename, 'a') do |f|
            f << "SET search_path TO #{ActiveRecord::Base.connection.schema_search_path};\n\n"
          end
        else
          raise "Task not supported by '#{config['adapter']}'"
        end

        if ActiveRecord::Base.connection.supports_migrations?
          File.open(filename, 'a') { |f| f << ActiveRecord::Base.connection.dump_schema_information }
        end

        db_namespace['structure:dump'].reenable
      end
    end
  end
