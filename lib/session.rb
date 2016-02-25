# require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie =  req.cookies['_rails_lite_app']
    if cookie
       @session_data = JSON.parse(cookie)
    else
      @session_data = {}
    end
  end

  def [](key)
    @session_data[key]
  end

  def []=(key, val)
    @session_data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie("_rails_lite_app", { path: '/', value: @session_data.to_json })
  end
end
