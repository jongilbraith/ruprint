module Ruprint #:nodoc:
  module Helpers
    
    include Builders

    # The main helper for generating a grid
    def grid(&block)
      builder = GridBuilder.new(self)
      yield builder
      builder.render
    end

  end
end
