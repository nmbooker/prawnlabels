require 'prawnlabels'
template = PrawnLabels::Templates.get('Avery', '7160')
g = PrawnLabels::Generator.new(template)
22.times do
  g.add_label do |pdf|
    pdf.text "10 Hello World"
    pdf.text "District"
    pdf.text "Town"
    pdf.text "County"
    pdf.text "Postcode"
    pdf.text "Country"
  end
end
g.render_file("hello.pdf")
