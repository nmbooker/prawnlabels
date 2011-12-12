require 'prawn'

# Label printing library based on Prawn.
# See the module 'PrawnLabels' and its classes for further documentation.

# Label printing library based on Prawn.
# The Template and Layout classes define how the labels are laid out on the page.
# The Generator class uses a Template to render your text on the labels.
#
# This is really important:
# Your PDF viewer and printer driver must be configured to avoid fitting the contents to
# printable margins.  If any scaling is done, the layout will be wrong on the page.
# Consider checking this before filing a bug saying the layout is wrong, or before fiddling with the templates!
module PrawnLabels
  # Specifies the label format and how they're laid out on the page.
  # width: The width of each label.
  # height: The height of each label.
  # round: The radius of rounded corners on the labels.
  # markup_margin_size: The size of the margin within the label.
  # layout: A Layout object, that describes how labels are laid out on the page.
  # page_size: The size of each sheet of labels.  Either a valid pre-defined Prawn page size, or [width, height].
  class Template
    attr_accessor :width, :height, :round, :markup_margin_size, :layout, :page_size
    def initialize(params)
      @page_size = params[:page_size]
      @width = params[:width]
      @height = params[:height]
      @round = params[:round]
      @markup_margin_size = params[:markup_margin_size]
      @layout = params[:layout]
    end


    def self.avery_7160
      Template.new(
        page_size: 'A4',
        width: 181.4, height: 108.0, round: 5,
        markup_margin_size: 5,
        layout: Layout.new(
          nx: 3, ny: 7,
          x0: 21.2, y0: 43.9,
          dx: 187.2, dy: 108.0
        )
      )
    end
  end

  # Specifies how labels are laid out on a page.  Units are in points.
  # nx: Number of labels across
  # ny: Number of labels down
  # x0: Distance of first label from left edge of page.
  # y0: Distance of first label from top edge of page.
  # dx: Horizontal Pitch (Distance from left of one label to left of next label.)
  # dy: Vertical Pitch (Distance from top of one label to top of next label.)
  class Layout
    attr_accessor :nx, :ny, :x0, :y0, :dx, :dy
    # params: The layout parameters in a hash of, e.g., {:nx => 3, ...}
    def initialize(params)
      @nx = params[:nx]
      @ny = params[:ny]
      @x0 = params[:x0]
      @y0 = params[:y0]
      @dx = params[:dx]
      @dy = params[:dy]
    end
  end


  class Generator
    def initialize(template=nil)
      @template ||= Template.new(
        page_size: 'A4',
        width: 181.4, height: 108.0, round: 5,
        markup_margin_size: 5,
        layout: Layout.new(
          nx: 3, ny: 7,
          x0: 21.2, y0: 43.9,
          dx: 187.2, dy: 108.0
        )
      )

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
