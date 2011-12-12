
# Pre-defined label templates

require 'prawnlabels/template'

module PrawnLabels
  class Templates
    def self.get(make, code)
      return self.get_instance.get(make, code)
    end

    def self.list
      return self.get_instance.list
    end

    @@instance = nil
    def self.get_instance
      @@instance ||= self.new
      return @@instance
    end

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

    def get(vendor, code)
      vendor_types = @templates[vendor]
      paper_type = vendor_types[code]
      template_data = paper_type[:template]
      template_data[:layout] = Layout.new(paper_type[:layout])
      return Template.new(template_data)
    end
  end
end
