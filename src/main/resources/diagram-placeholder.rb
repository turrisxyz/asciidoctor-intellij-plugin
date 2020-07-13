require 'asciidoctor/extensions'
require 'java'

include ::Asciidoctor

#
#
class DummyDiagramBlock < Asciidoctor::Extensions::BlockProcessor
  use_dsl
  on_context :listing, :literal
  name_positional_attributes 'target', 'format'

  def process(parent, reader, attrs)
    DummyDiagramProcessor.process(self, parent)
  end
end

#
#
class DummyDiagramBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  def process(parent, target, attrs)
    DummyDiagramProcessor.process(self, parent)
  end

end

class DummyDiagramProcessor
  class << self
    def process(processor, parent)
      placeholder_text = "Unable to render diagram. To render diagrams, go to the AsciiDoc plugin's settings and download extensions or enable Kroki."
      parent.document.set_header_attribute 'asciidoctor-diagram-missing-diagram-extension', 'true'
      processor.create_paragraph(parent, placeholder_text, {'missing': 'none' })
    end
  end
end

Extensions.register do
  names = %w(plantuml ditaa graphviz blockdiag seqdiag actdiag nwdiag packetdiag rackdiag c4plantuml erd mermaid nomnoml svgbob umlet vega vegalite wavedrom)
  names.each { |name|
    block_macro DummyDiagramBlockMacro, name
    block DummyDiagramBlock, name
  }
end
