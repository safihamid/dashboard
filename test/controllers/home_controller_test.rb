# -*- coding: utf-8 -*-
require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "language is determined from cookies" do
    @request.cookies[:language_] = "es-ES"

    get :index

    assert_select 'a', 'Iniciar Sesión'
  end

  test "language is set with cookies" do
    sign_in User.new # devise uses an empty user instead of nil? Hm

    request.host = "learn.code.org"

    get :set_locale, :return_to => "http://blahblah", :locale => "es-ES"

    assert_equal "es-ES", cookies[:language_]

    assert_equal "language_=es-ES; domain=.code.org; path=/", @response.headers["Set-Cookie"]
  end

end
