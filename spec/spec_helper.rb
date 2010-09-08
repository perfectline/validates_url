$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/resources')
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'spec'
require 'rails'
require 'validates_url'

autoload :User,                 'resources/user'
autoload :UserWithNil,          'resources/user_with_nil'
autoload :UserWithBlank,        'resources/user_with_blank'
autoload :UserWithLegacySyntax, 'resources/user_with_legacy_syntax'

