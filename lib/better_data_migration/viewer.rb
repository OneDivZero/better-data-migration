module BetterDataMigration
  class Viewer
    LINE = ('-' * 120).freeze
    ARROWS = '>>>>>>>>>>>>>>>>>>>>'.freeze
    FILE_NOT_FOUND_STRING = 'cannot load such file --'.freeze

    def list
      show_list_for(MigrationState.ordered)
    end

    def pending
      show_list_for(MigrationState.pending)
    end

    def show(id = nil)
      puts "\n> Type the ID of migration for details:" if id.nil?
      id ||= $stdin.readline.chomp

      # TODO: :show_list_for must be ordered by :id for comprehensive migrations across branches
      # It must be such intelligent, that it can handle migration-diffs across branches
      # Such inconsitencies should be automatically detected!!!
      show_list_for(MigrationState.where(id: id), with_description: true)
    end

    private def show_list_for(migration_list, with_description: false)
      list = []

      migration_list.each do |entry|
        text =  "  #{entry.state_symbol}  | #{entry.id} | #{entry.name.ljust(60)} "
        text += "|   #{entry.unattended_value}   | #{entry.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
        list << text
        list << "#{ARROWS} #{entry.description}" if with_description
      rescue LoadError => e
        print_load_error(e)
      end

      print_migration_list(list)
    end

    private def print_migration_list(list)
      print_list_header unless list.empty?
      list << '>> No migrations available' if list.empty?
      puts list.join("\n").encode('utf-8')
      print_separator
      puts "\n\n"
    end

    private def print_list_header
      print_separator
      print 'state | migration  | name                                                         | auto? | created at'
      print_separator
    end

    private def print_separator(break_after: true)
      break_after = break_after ? "\n" : ''
      puts "#{break_after}#{LINE}"
    end

    private def print_load_error(e)
      raise e unless e.message.starts_with?(FILE_NOT_FOUND_STRING)

      file_name = e.message.remove(FILE_NOT_FOUND_STRING).split('/').last
      print_separator
      puts "\u2757 WARNING: Ignored due to database-mismatch with file-system:"
      puts file_name
      puts 'Maybe defined in another git-branch ?!'
      print_separator(break_after: false)
    end
  end
end
