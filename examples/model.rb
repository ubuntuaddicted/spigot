require 'spigot'

Spigot.define do
  service :twitter do
    resource :user do
      id       :twitter_id
      name     :name
      username :username
    end
  end
end

Spigot.define do
  service :github do
    resource :user do
      id        :github_id
      full_name :name
      login     :username
      contact do
        address   :address
        telephone do
          work :work_phone
          home :home_phone
        end
        url :homepage do |value|
          "https://github.com/#{value}"
        end
      end
    end

    resource :pull_request do
      id        :id
      title     :title
      body      :body
    end
  end
end

class User
  include Spigot::Base

  attr_reader :name, :username

  def initialize(params = {})
    params.each_pair do |k, v|
      instance_variable_set("@#{k}".to_sym, v)
    end
  end

  def self.api_data
    { id: '9238475', full_name: 'matthew', login: 'mwerner' }
  end

  def self.build
    new_by_api(github: api_data)
  end
end

puts 'Map Built:'
puts Spigot.config.map.to_hash

user = User.build
puts "\nUser Parsed:"
puts user.name
puts user.inspect
