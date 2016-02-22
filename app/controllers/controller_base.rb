require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative '../../config/session'
require 'active_support/inflector'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = req.params.merge(route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise DoubleRenderError if already_built_response?
    res.header['location'] = url
    res.status = 302
    @already_built_response = true
    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise DoubleRenderError if already_built_response?
    res['Content-Type'] = content_type
    res.body = [content]
    @already_built_response = true
    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    body_string = ""
    File.open("./app/views/#{controller_name}/#{template_name}.html.erb", "r") do |f|
      f.each_line do |line|
        body_string += line
      end
    end
    #File.readlines
    #File.read

    content = ERB.new(body_string).result(binding)
    render_content(content, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  def controller_name
    self.class.name.underscore
  end
end

class DoubleRenderError < RuntimeError
end
