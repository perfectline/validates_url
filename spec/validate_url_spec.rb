# encoding: utf-8
require 'spec_helper'

describe "URL validation" do

  before(:all) do
    ActiveRecord::Schema.define(:version => 1) do

      create_table :users, :force => true do |t|
        t.column :homepage, :string
      end

    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:users)
  end

  context "with regular validator" do
    before do
      @user = User.new
    end

    it "should not allow nil as url" do
      @user.homepage = nil
      @user.should_not be_valid
    end

    it "should not allow blank as url" do
      @user.homepage = ""
      @user.should_not be_valid
    end

    it "should not allow an url without scheme" do
      @user.homepage = "www.example.com"
      @user.should_not be_valid
    end

    it "should allow an url with http" do
      @user.homepage = "http://localhost"
      @user.should be_valid
    end

    it "should allow an url with https" do
      @user.homepage = "https://localhost"
      @user.should be_valid
    end

    it "should not allow a url with an invalid scheme" do
      @user.homepage = "ftp://localhost"
      @user.should_not be_valid
    end

    it "should not allow a url with only a scheme" do
      @user.homepage = "http://"
      @user.should_not be_valid
    end
    
    it "should not allow a url without a host" do
      @user.homepage = "http:/"
      @user.should_not be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      @user.should be_valid
    end

    it "should return a default error message" do
      @user.homepage = "invalid"
      @user.valid?
      @user.errors[:homepage].should == ["is not a valid URL"]
    end

    context "when locale is turkish" do
      it "should return a Turkish default error message" do
        I18n.locale = :tr
        @user.homepage = "Black Tea"
        @user.valid?
        @user.errors[:homepage].should == ["Geçerli bir URL değil"]
      end
    end
  end

  context "with allow nil" do
    before do
      @user = UserWithNil.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      @user.should be_valid
    end

    it "should not allow blank as url" do
      @user.homepage = ""
      @user.should_not be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      @user.should be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      @user.should be_valid
    end
  end

  context "with allow blank" do
    before do
      @user = UserWithBlank.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      @user.should be_valid
    end

    it "should allow blank as url" do
      @user.homepage = ""
      @user.should be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      @user.should be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      @user.should be_valid
    end
  end

  context "with legacy syntax" do
    before do
      @user = UserWithLegacySyntax.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      @user.should be_valid
    end

    it "should allow blank as url" do
      @user.homepage = ""
      @user.should be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      @user.should be_valid
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      @user.should_not be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      @user.should be_valid
    end
  end

  context "with ActiveRecord" do
    before do
      @user = UserWithAr.new
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      @user.should_not be_valid
    end
  end

  context "with ActiveRecord and legacy syntax" do
    before do
      @user = UserWithArLegacy.new
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      @user.should_not be_valid
    end
  end

  context "with regular validator and custom scheme" do
    before do
      @user = UserWithCustomScheme.new
    end

    it "should allow alternative URI schemes" do
      @user.homepage = "ftp://ftp.example.com"
      @user.should be_valid
    end
  end

  context "with custom message" do
    before do
      @user = UserWithCustomMessage.new
    end

    it "should use custom message" do
      @user.homepage = "invalid"
      @user.valid?
      @user.errors[:homepage].should == ["wrong"]
    end
  end
end
