$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/resources')
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'sqlite3'
require 'active_record'
require 'active_record/base'
require 'active_record/migration'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(
    "adapter"   => "sqlite3",
    "database"  => ":memory:"
)

require File.join(File.dirname(__FILE__), '..', 'rails', 'init')

autoload :User,                 'resources/user'
autoload :UserWithNil,          'resources/user_with_nil'
autoload :UserWithBlank,        'resources/user_with_blank'
autoload :UserWithLegacySyntax, 'resources/user_with_legacy_syntax'
autoload :UserWithAr,           'resources/user_with_ar'
autoload :UserWithArLegacy,     'resources/user_with_ar_legacy'