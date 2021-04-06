# frozen_string_literal: true

require "spec_helper"

RSpec.describe "RSpec matcher", if: defined?(ActiveModel) do
  subject { User }

  it "ensures that attributes are validated" do
    is_expected.to validate_url_of(:homepage)
  end
end
