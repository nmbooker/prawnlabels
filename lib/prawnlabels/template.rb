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
end
