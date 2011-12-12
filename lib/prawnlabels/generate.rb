require 'prawn'

module PrawnLabels

  # Generates a set of labels based on a template.
  class Generator
    def initialize(template)
      @template = template

      @pdf = Prawn::Document.new(
        :page_size => @template.page_size,
        :skip_page_creation => true, :margin => 0)

      @this_x = 0
      @this_y = 0
    end

    def render
      @pdf.render
    end

    def render_file(filename)
      @pdf.render_file(filename)
    end

    # add_label do |pdf, generator|
    #   pdf.text("Hello")
    # end
    def add_label(&block)
      x, y = new_box
      @pdf.canvas do
        @pdf.bounding_box([x, y], :width => @template.width, :height => @template.height, :margin => @template.markup_margin_size) do
          @pdf.bounding_box([@template.markup_margin_size, @pdf.bounds.top - @template.markup_margin_size], :width => @template.width - (2 * @template.markup_margin_size)) do
              block.call(@pdf)
          end
        end
      end
    end

    def layout
      @template.layout
    end


    private
    # => x, y
    def this_box_pos
      #x = layout.x0 + (@this_x * (layout.dx + @template.markup_margin_size))
      #y = layout.y0 + (@this_y * (layout.dy + @template.markup_margin_size))
      x = layout.x0 + (@this_x * layout.dx)
      y = layout.y0 + (@this_y * layout.dy)
      [x, @pdf.bounds.absolute_top - y]
    end

    def new_box
      if @this_x == 0 and @this_y == 0 then
        @pdf.start_new_page
      end
      pos = this_box_pos
      next_box
      return pos
    end

    def next_box
      @this_x += 1
      if @this_x >= layout.nx
        @this_x = 0
        @this_y += 1
        if @this_y >= layout.ny
          @this_y = 0
        end
      end
    end
  end
end
