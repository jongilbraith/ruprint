module Ruprint #:nodoc:
  module Builders #:nodoc:
    
    class GridBuilder

      include ActionView::Helpers::TagHelper

      # String / symbol - the css id applied to the main
      # container div of the grid.
      attr_accessor :css_id

      # Array of string / symbol - any additional classes to
      # be added to the main container div of the grid.
      attr_accessor :css_classes

      # Boolean (default false) - apply the container class to the grid, for use on the main outer grid of a page
      attr_accessor :container

      # Boolean (default false) - turn on showing of the grid.
      attr_accessor :showgrid
      
      # Internal use
      attr_accessor :rows, :html, :template #:nodoc:

      # On creation of a new GridBuilder object, pass in the
      # template object (i.e. self when called within a helper).
      def initialize(template)
        @html        = ""
        @rows        = []
        @container   = false
        @showgrid    = false
        @css_classes = []
        @template    = template
      end

      # Add a row to this grid. Use like so:
      #  grid.add_row do |row|
      #    row.width = 5
      #    row.add_column do |column|
      #      column.html do
      #        <p>Some content</p>
      #      end
      #    end
      #  end
      def add_row(&block)
        row = RowBuilder.new(@template)
        yield row
        @rows << row
      end

      # Generate the html for the grid
      def render
        # Add extra classes based on boolean accessors
        @css_classes << :container if @container
        @css_classes << :showgrid  if @showgrid
        
        options         = {}
        options[:id]    = @css_id if @css_id.present?
        options[:class] = @css_classes.join(" ") if @css_classes.present?

        @rows.each do |row|
          @html << row.render
        end

        content_tag(:div, @html, options)
      end

    end

    class RowBuilder

      include ActionView::Helpers::TagHelper

      # Internal use.
      attr_accessor :columns, :html, :template #:nodoc:

      # On creation of a new RowBuilder object, pass in the
      # template object (i.e. grid.template).
      def initialize(template)
        @html        = ""
        @css_classes = []
        @columns     = []
        @template    = template
      end

      # Add a column to this row. Use like so:
      #  row.add_column do |column|
      #    column.width  = 5
      #    column.box    = true
      #    column.border = 0
      #    column.html do
      #      <p>Some content</p>
      #    end
      #  end
      def add_column(&block)
        column = ColumnBuilder.new(@template)
        yield column
        @columns << column
      end

      # Returns the width of the row, by interrogating the columns.
      def counted_width
        @columns.inject(0) do |total, column|
          total + column.width
        end
      end

      # Generate the html for all the columns in this row.
      def render
        @columns.each do |column|
          column.css_classes << "last" if column == @columns.last
          @html << column.render
        end

        @html
      end

    end

    class ColumnBuilder

      include ActionView::Helpers::TagHelper

      # String / symbol - the css id applied to this column div.
      attr_accessor :css_id

      # Array of string / symbol - any additional classes applied to this column div.
      attr_accessor :css_classes

      # Fixnum - the width of this column (columns).
      attr_accessor :width

      # Fixnum - a push or pull value (no sanatization to prevent you adding both).
      attr_accessor :push, :pull

      # Fixnum - append and prepend values (no sanatization to prevent you adding both).
      attr_accessor :append, :prepend

      # Boolean - (default false) - turn on adding of a padded box inside the column.
      attr_accessor :box

      # Boolean - (default false) - turns on drawing of a border on the right border of a column.
      attr_accessor :border

      # Boolean - (default false) - turns on drawing of a border with more whitespace (spans one column).
      attr_accessor :colborder

      # Internal use.
      attr_accessor :template #:nodoc:

      # On creation of a new ColumnBuilder object, pass in the
      # template object (i.e. row.template).
      def initialize(template)
        @html        = ""
        @css_classes = []
        @template    = template
        @box         = false
        @border      = false
        @colborder   = false
      end

      # Assign the inner html for this column's div using =
      # (i.e. for single line content).
      def html=(html)
        @html = html
      end

      # Assign the inner html for this column's div using a block
      # (i.e. for multiple lines).
      def html(&block)
        @html = @template.capture(&block)
      end

      # Generate the html for this row.
      def render
        @css_classes << "span-#{@width}" if @width.present?
        @css_classes << "push-#{@push}" if @push.present?
        @css_classes << "pull-#{@pull}" if @pull.present?
        @css_classes << "append-#{@append}" if @append.present?
        @css_classes << "prepend-#{@prepend}" if @prepend.present?
        @css_classes << "box" if @box.present?
        @css_classes << "border" if @border.present?
        @css_classes << "colborder" if @colborder.present?

        options         = {}
        options[:id]    = @css_id if @css_id.present?
        options[:class] = @css_classes.join(" ") if @css_classes.present?
        content_tag(:div, @html, options)
      end

    end

  end
end
