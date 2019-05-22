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
      expect(@user).not_to be_valid
    end

    it "should not allow blank as url" do
      @user.homepage = ""
      expect(@user).not_to be_valid
    end

    it "should not allow an url without scheme" do
      @user.homepage = "www.example.com"
      expect(@user).not_to be_valid
    end

    it "should allow an url with http" do
      @user.homepage = "http://localhost"
      expect(@user).to be_valid
    end

    it "should allow an url with https" do
      @user.homepage = "https://localhost"
      expect(@user).to be_valid
    end

    it "should not allow a url with an invalid scheme" do
      @user.homepage = "ftp://localhost"
      expect(@user).not_to be_valid
    end

    it "should not allow a url with only a scheme" do
      @user.homepage = "http://"
      expect(@user).not_to be_valid
    end

    it "should not allow a url without a host" do
      @user.homepage = "http:/"
      expect(@user).not_to be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      expect(@user).to be_valid
    end

    it "should return a default error message" do
      @user.homepage = "invalid"
      @user.valid?
      expect(@user.errors[:homepage]).to eq(["is not a valid URL"])
    end

    context "when locale is turkish" do
      it "should return a Turkish default error message" do
        I18n.locale = :tr
        @user.homepage = "Black Tea"
        @user.valid?
        expect(@user.errors[:homepage]).to eq(["Geçerli bir URL değil"])
      end
    end
    context "when locale is Japanese" do
      it "should return a Japanese default error message" do
        I18n.locale = :ja
        @user.homepage = "黒麦茶"
        @user.valid?
        expect(@user.errors[:homepage]).to eq(["は不正なURLです。"])
      end
    end
  end

  context "with allow nil" do
    before do
      @user = UserWithNil.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      expect(@user).to be_valid
    end

    it "should not allow blank as url" do
      @user.homepage = ""
      expect(@user).not_to be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      expect(@user).to be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      expect(@user).to be_valid
    end
  end

  context "with allow blank" do
    before do
      @user = UserWithBlank.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      expect(@user).to be_valid
    end

    it "should allow blank as url" do
      @user.homepage = ""
      expect(@user).to be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      expect(@user).to be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      expect(@user).to be_valid
    end
  end

  context "with no_local" do
    before do
      @user = UserWithNoLocal.new
    end

    it "should allow a valid internet url" do
      @user.homepage = "http://www.example.com"
      expect(@user).to be_valid
    end

    it "should not allow a local hostname" do
      @user.homepage = "http://localhost"
      expect(@user).not_to be_valid
    end

    [
      'https://127.0.0.1',
      'https://192.168.1.13',
      'https://127.0.254.254',
      'https://10.100.103.243',
      'https://127.0.0.1:5555',
      'https://127.0.0.1.xip.io',
      'https://169.254.1.1',
      'https://0:0:0:0:0:ffff:7f00:1'
    ].each do |url|
      it "should not allow #{url}" do
        @user.homepage = url
        expect(@user).not_to be_valid
      end
    end
  end

  context "with blacklisted_domains" do
    before do
      @user = UserWithBlacklistedDomains.new
    end

    it "should allow a valid internet url" do
      @user.homepage = "http://www.example.com"
      expect(@user).to be_valid
    end

    it "should not allow a blacklisted domain" do
      @user.homepage = "http://example.net"
      expect(@user).not_to be_valid
    end

    it "should not allow a blacklisted subdomain" do
      @user.homepage = "http://sub.example.net"
      expect(@user).not_to be_valid
    end
  end

  context "with legacy syntax" do
    before do
      @user = UserWithLegacySyntax.new
    end

    it "should allow nil as url" do
      @user.homepage = nil
      expect(@user).to be_valid
    end

    it "should allow blank as url" do
      @user.homepage = ""
      expect(@user).to be_valid
    end

    it "should allow a valid url" do
      @user.homepage = "http://www.example.com"
      expect(@user).to be_valid
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      expect(@user).not_to be_valid
    end

    it "should allow a url with an underscore" do
      @user.homepage = "http://foo_bar.com"
      expect(@user).to be_valid
    end
  end

  context "with ActiveRecord" do
    before do
      @user = UserWithAr.new
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      expect(@user).not_to be_valid
    end
  end

  context "with ActiveRecord and legacy syntax" do
    before do
      @user = UserWithArLegacy.new
    end

    it "should not allow invalid url" do
      @user.homepage = "random"
      expect(@user).not_to be_valid
    end
  end

  context "with regular validator and custom scheme" do
    before do
      @user = UserWithCustomScheme.new
    end

    it "should allow alternative URI schemes" do
      @user.homepage = "ftp://ftp.example.com"
      expect(@user).to be_valid
    end
  end

  context "with custom message" do
    before do
      @user = UserWithCustomMessage.new
    end

    it "should use custom message" do
      @user.homepage = "invalid"
      @user.valid?
      expect(@user.errors[:homepage]).to eq(["wrong"])
    end
  end

  context "with SNS" do
    before do
      @user = UserWithArAndSns.new
    end

    it "should allow a valid sns uri" do
      @user.homepage = "sns://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI%2FK7MDENG%2FbPxRfiCYEXAMPLEKEY@us-east-2/478320183963/checkr-webhooks"
      expect(@user).not_to be_valid
    end

    it "should not allow invalid sns uri with colons used instead of slashes" do
      @user.homepage = "sns://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI%2FK7MDENG%2FbPxRfiCYEXAMPLEKEY@us-east-2:478320183963:checkr-webhooks"
      expect(@user).not_to be_valid
    end
  end
end
