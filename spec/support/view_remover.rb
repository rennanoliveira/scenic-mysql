module ViewRemover

  class RemoveViews
    def self.run
      ActiveRecord::Base.connection.execute('DROP VIEW IF EXISTS greetings')
      ActiveRecord::Base.connection.execute('DROP VIEW IF EXISTS parents')
      ActiveRecord::Base.connection.execute('DROP VIEW IF EXISTS children')
    end
  end

end