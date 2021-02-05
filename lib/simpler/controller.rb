require_relative 'view'

module Simpler
  class Controller

    SUCCESS_STATUS = 200
    REDIRECT_STATUS = 302

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.status'] = SUCCESS_STATUS

      set_default_headers
      send(action)
      write_response

      @response.status = @request.env['simpler.status']

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      if @request.env['simpler.redirect'].nil?
        body = render_body
        @response.write(body)
      end
    end

    def render_body
      set_render_template

      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template = nil, **args)
      set_status(args)
      set_headers(args)
      set_render_template(template, args)
    end

    def set_render_template(template = nil, args = {})
      if @request.env['simpler.template'].nil?
        res = { type: 'template', value: template }

        if args.has_key?(:plain)
          res = { type: 'plain', value: args[:plain] }
        end

        @request.env['simpler.template'] = res
      end
    end

    def set_status(args)
      if args.has_key?(:status)
        @request.env['simpler.status'] = args[:status]
        @response.status = args[:status].to_i
      end
    end

    def set_headers(args)
      if args.has_key?(:headers) && args[:headers].class == Hash
        @request.env['simpler.headers'] = args[:headers]
        
        args[:headers].each do |key, value|
          @response[key] = value
        end
      end
    end

    def redirect_to(url, status = REDIRECT_STATUS)
      @request.env['simpler.status'] = status
      @request.env['simpler.redirect'] = url

      @response.redirect(url, status)
    end

  end
end
