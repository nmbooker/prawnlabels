
# Pre-defined label templates

require 'prawnlabels/template'

module PrawnLabels
  # Templates contains pre-defined templates.
  # Currently, this is only the Avery 7160 template.
  # TODO: Import from glabels templates files.
  #
  # Use PrawnLabels::Templates.get(make, code) to get the template for a particular type of paper.
  # For example:
  #  PrawnLabels::Templates.get('Avery', '7160') will return a Template
  class Templates
    # Return a Template for the given make and code of paper.
    # nil is returned if it doesn't exist.
    def self.get(make, code)
      return self.get_instance.get(make, code)
    end

    # Return a hash mapping available makes to the available models of paper.
    # e.g.
    #     {'Avery' => ['7160', '7161', ...], ...}
    def self.list
      return self.get_instance.list
    end

    # Used internally.  Use class methods Templates.get and Templates.list.
    @@instance = nil
    def self.get_instance
      @@instance ||= self.new
      return @@instance
    end

    # Used internally.  Use class methods Templates.get and Tempalates.list.
    def initialize
      @templates = {
        'Avery' => {
          '7160' => {
            :template => {
              :page_size => 'A4',
              :width => 181.4,
              :height => 108.0,
              :round => 5,
              :markup_margin_size => 5,
              },
            :layout => {
              :nx => 3, :ny => 7,
              :x0 => 21.2, :y0 => 43.9,
              :dx => 187.2, :dy => 108.0,
              },
          }, # 7160
        }, # Avery
      } # @templates
    end

    # Used internally. Use class method Templates.list instead.
    def list
      makes = {}
      @templates.each_pair do |make, models|
        makes[make] = []
        models.each_key do |model|
          makes[make] << model
        end
      end
      return makes
    end

    # Used internally.  Use class method Templates.get instead.
    def get(vendor, code)
      vendor_types = @templates[vendor]
      paper_type = vendor_types[code]
      template_data = paper_type[:template]
      template_data[:layout] = Layout.new(paper_type[:layout])
      return Template.new(template_data)
    end
  end
end
