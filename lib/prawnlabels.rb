$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# Label printing library based on Prawn.
# See the module 'PrawnLabels' and its classes for further documentation.

require 'prawnlabels/generate'
require 'prawnlabels/template'
require 'prawnlabels/templates'

# Label printing library based on Prawn.
# The Template and Layout classes define how the labels are laid out on the page.
# The Generator class uses a Template to render your text on the labels.
#
# This is really important:
# Your PDF viewer and printer driver must be configured to avoid fitting the contents to
# printable margins.  If any scaling is done, the layout will be wrong on the page.
# Consider checking this before filing a bug saying the layout is wrong, or before fiddling with the templates!

module PrawnLabels
  VERSION = '0.0.1'
end
