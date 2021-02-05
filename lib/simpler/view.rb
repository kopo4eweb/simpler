require_relative 'view/html_renderer'
require_relative 'view/plain_text_renderer'

module Simpler
  class View

    RENDER_CLASSES = { template: HtmlRenderer, plain: PlainTextRenderer }

    def initialize(env)
      @env = env
    end

    def render(binding)
      type = template[:type].to_sym

      RENDER_CLASSES[type].new(@env).render(binding)
    end

    private

    def template
      @env['simpler.template']
    end

  end
end
