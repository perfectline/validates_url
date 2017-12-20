require "spec_helper"

if defined?(ActiveModel)
  require_relative "../lib/rspec_matcher"

  describe "RSpec matcher" do
    subject { User }

    it "should ensure that attributes are validated" do
      should validate_url_of(:homepage)
    end
  end
end
