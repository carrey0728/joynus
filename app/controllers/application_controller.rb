class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  private
  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

  def authorize_if_admin
    redirect_to root_url, alert: "Not authorized" if current_user.nil? || !current_user.admin?
  end

  def authorize_if_admin_or_current_user
    redirect_to root_url, alert: "Not authorized" if current_user.nil? || current_user.id != User.find(params[:id]).id && !current_user.admin?
  end
end
