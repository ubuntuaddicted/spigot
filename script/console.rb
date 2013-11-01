require 'active_record'
require 'spigot'

ActiveRecord::Base.logger = Spigot.logger
require File.join(Spigot.root, 'spec', 'support', 'active_record')

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

map = {'activeuser' => {
        name: 'name',
        login: 'username',
        'spigot' => {
          'primary_key' => 'username',
          'foreign_key' => 'login'
        }
      }}

Spigot.configure do |config|
  config.translations = map
end

user = ActiveUser.create(name: 'Matt', username: 'mttwrnr', token: 'abc123')
