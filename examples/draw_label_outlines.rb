require 'prawnlabels'
g = PrawnLabels::Generator.new(PrawnLabels::Templates.get('Avery', '7160'))
21.times do
  g.add_label do |pdf|
    pdf.stroke_bounds
  end
end
g.render_file("hello.pdf")
