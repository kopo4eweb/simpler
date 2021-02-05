require 'erb'

module Simpler
  class HtmlRenderer

    VIEW_BASE_PATH = 'app/views'.freeze
    VIEW_TYPE_FILE = '.html.erb'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template_file_path = template_path

      if File.exist?(template_file_path)
        template = File.read(template_file_path)
      
        render_layout do
          ERB.new(template).result(binding)
        end
      else
        @env['simpler.status'] = 500
        "Internal Server Error"
      end
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template'][:value]
    end

    def template_path
      path = template || [controller.name, action].join('/')

      file = "#{path}#{VIEW_TYPE_FILE}"

      @env['simpler.template_file'] = file

      Simpler.root.join(VIEW_BASE_PATH, file)
    end

    def render_layout
      layout = File.read(Simpler.root.join(VIEW_BASE_PATH,"layouts/app#{VIEW_TYPE_FILE}"))
      
      ERB.new(layout).result(binding)
    end

  end
end