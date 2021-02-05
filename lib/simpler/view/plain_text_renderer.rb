module Simpler
  class PlainTextRenderer
    
    def initialize(env)
      @env = env
    end

    def render(binding)
      template
    end

    def template
      @env['simpler.template'][:value]
    end
  end
end