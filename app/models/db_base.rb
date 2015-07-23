class DbBase
  include ActiveModel::Validations

  PATH = ENV['IPALLOC_DATAPATH']
  VAL_DELIMITER = ','

  class << self
    def has_columns(*cols)
      self.instance_eval <<-STR
        def columns
          #{cols}
        end
      STR

      cols.each do |col|
        self.class_eval do
          attr_accessor col
        end
      end
    end

    def find(val, by = nil)
      by ||= columns.first
      col_index = columns.index(by.to_sym)
      found = nil

      with_read_lock do |f|
        f.each_line do |row|
          vals = row.chomp.split(VAL_DELIMITER)

          if vals[col_index] == val
            found = vals
            break
          end
        end # line
      end # read

      found ? serialize(found) : nil
    end

    private

    def with_read_lock
      File.open(PATH, 'r') do |f|
        # use shared lock for reads
        f.flock(File::LOCK_SH)

        yield(f)

        # unlock the file
        f.flock(File::LOCK_UN)
      end
    end

    def serialize(found)
      hsh = {}
      self.columns.each_with_index do |col, i|
        hsh[col] = found[i]
      end
      hsh
    end
  end # self

  def initialize(opts = {})
    opts.each do |attr, val|
      self.public_send("#{attr}=".to_sym, val)
    end
  end

  def save
    return false unless self.valid?

    vals = []
    self.class.columns.each do |col|
      vals << self.public_send(col)
    end
    data = vals.join(VAL_DELIMITER)

    with_write_lock do |f|
      f.write(data + "\n")
    end
    true
  end

  private

  def with_write_lock
    File.open(PATH, 'a', 0644) do |f|
      # use exclusive lock for writes
      f.flock(File::LOCK_EX)

      yield(f)

      # unlock the file
      f.flock(File::LOCK_UN)
    end
  end
end # class
