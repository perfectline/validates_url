# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'URL validation' do
  before(:all) do
    ActiveRecord::Schema.define(version: 1) do
      create_table :users, force: true do |t|
        t.column :homepage, :string
      end
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:users)
  end

  context 'with regular validator' do
    let!(:user) { User.new }

    it 'does not allow nil as url' do
      user.homepage = nil

      expect(user).not_to be_valid
    end

    it 'does not allow blank as url' do
      user.homepage = ''

      expect(user).not_to be_valid
    end

    it 'does not allow an url without scheme' do
      user.homepage = 'www.example.com'

      expect(user).not_to be_valid
    end

    it 'allows an url with http' do
      user.homepage = 'http://localhost'

      expect(user).to be_valid
    end

    it 'allows an url with https' do
      user.homepage = 'https://localhost'

      expect(user).to be_valid
    end

    it 'does not allow a url with an invalid scheme' do
      user.homepage = 'ftp://localhost'

      expect(user).not_to be_valid
    end

    it 'does not allow a url with only a scheme' do
      user.homepage = 'http://'

      expect(user).not_to be_valid
    end

    it 'does not allow a url without a host' do
      user.homepage = 'http:/'

      expect(user).not_to be_valid
    end

    it 'allows a url with an underscore' do
      user.homepage = 'http://foo_bar.com'

      expect(user).to be_valid
    end

    it "does not allow a url with a space in the hostname" do
      user.homepage = "http://foo bar.com"
      expect(user).not_to be_valid
    end

    it "does not allow a url with a space in the querystring" do
      user.homepage = "http://example.com/some/? doodads=ok"
      expect(user).not_to be_valid
    end

    it "returns a default error message" do
      user.homepage = "invalid"
      user.valid?
      expect(user.errors[:homepage]).to eq(["is not a valid URL"])
    end

    it "does not allow an array of urls" do
      user.homepage = ["https://foo.com", "https://bar.com"]
      expect(user).not_to be_valid
    end

    context "when locale is turkish" do
      it "returns a Turkish default error message" do
        I18n.locale = :tr
        user.homepage = 'Black Tea'
        user.valid?

        expect(user.errors[:homepage]).to eq(['Geçerli bir URL değil'])
      end
    end

    context 'when locale is Japanese' do
      it 'returns a Japanese default error message' do
        I18n.locale = :ja
        user.homepage = '黒麦茶'
        user.valid?
        expect(user.errors[:homepage]).to eq(['は不正なURLです'])
      end
    end

    it 'does not allow a mailto url without local-part' do
      user.homepage = 'mailto:@bar.com'

      expect(user).not_to be_valid
    end
  end

  context 'with allow nil' do
    let!(:user) { UserWithNil.new }

    it 'allows nil as url' do
      user.homepage = nil

      expect(user).to be_valid
    end

    it 'does not allow blank as url' do
      user.homepage = ''

      expect(user).not_to be_valid
    end

    it 'allows a valid url' do
      user.homepage = 'http://www.example.com'

      expect(user).to be_valid
    end

    it 'allows a url with an underscore' do
      user.homepage = 'http://foo_bar.com'

      expect(user).to be_valid
    end
  end

  context 'with allow blank' do
    let!(:user) { UserWithBlank.new }

    it 'allows nil as url' do
      user.homepage = nil

      expect(user).to be_valid
    end

    it 'allows blank as url' do
      user.homepage = ''

      expect(user).to be_valid
    end

    it 'allows a valid url' do
      user.homepage = 'http://www.example.com'

      expect(user).to be_valid
    end

    it 'allows a url with an underscore' do
      user.homepage = 'http://foo_bar.com'

      expect(user).to be_valid
    end
  end

  context 'with no_local' do
    let!(:user) { UserWithNoLocal.new }

    it 'allows a valid internet url' do
      user.homepage = 'http://www.example.com'

      expect(user).to be_valid
    end

    it 'does not allow a local hostname' do
      user.homepage = 'http://localhost'

      expect(user).not_to be_valid
    end

    it 'does not allow weird urls that get interpreted as local hostnames' do
      user.homepage = 'http://http://example.com'

      expect(user).not_to be_valid
    end

    it 'does not allow an url without scheme' do
      user.homepage = 'www.example.com'

      expect(user).not_to be_valid
    end
  end

  context 'with public_suffix' do
    let!(:user) { UserWithPublicSuffix.new }

    it 'allows a valid public suffix' do
      user.homepage = 'http://www.example.com'

      expect(user).to be_valid
    end

    it 'does not allow a local hostname' do
      user.homepage = 'http://localhost'

      expect(user).not_to be_valid
    end

    it 'does not allow non public hosts suffixes' do
      user.homepage = 'http://example.not_a_valid_tld'

      expect(user).not_to be_valid
    end

    it "should not allow an array with non public hosts suffixes" do
      user.homepage = ["http://www.example.com", "http://example.not_a_valid_tld"]
      expect(user).not_to be_valid
    end
  end

  context "with accept array" do
    let!(:user) { UserWithAcceptArray.new }

    it "allows an array of urls" do
      user.homepage = ["https://foo.com", "https://bar.com"]
      expect(user).to be_valid
    end

    it "returns errors on an array of urls if one is invalid" do
      user.homepage = ["https://foo.com", "https://foo bar.com"]
      expect(user).not_to be_valid
    end

    it "returns errors on an array of urls if one is nil" do
      user.homepage = ["https://foo.com", nil]
      expect(user).not_to be_valid
    end

    it "returns errors on an array of urls if one is empty" do
      user.homepage = ["https://foo.com", ""]
      expect(user).not_to be_valid
    end

    it "allows a normal string to be validated without an array" do
      user.homepage = "https://www.example.com"
      expect(user).to be_valid
    end
  end

  context "with accept array with nil" do
    let!(:user) { UserWithAcceptArrayWithNil.new }

    it "allows an array of urls with a nil" do
      user.homepage = ["https://foo.com", nil]
      expect(user).to be_valid
    end
  end

  context "with accept array with blank" do
    let!(:user) { UserWithAcceptArrayWithBlank.new }

    it "allows an array of urls with a blank" do
      user.homepage = ["https://foo.com", ""]
      expect(user).to be_valid
    end
  end

  context "with accept array with message" do
    let!(:user) { UserWithAcceptArrayWithMessage.new }

    it "uses the custom message" do
      user.homepage = ["https://foo.com", "https://foo bar.com"]
      user.valid?

      expect(user.errors[:homepage]).to eq(["wrong"])
    end
  end

  context 'with legacy syntax' do
    let!(:user) { UserWithLegacySyntax.new }

    it 'allows nil as url' do
      user.homepage = nil

      expect(user).to be_valid
    end

    it 'allows blank as url' do
      user.homepage = ''

      expect(user).to be_valid
    end

    it 'allows a valid url' do
      user.homepage = 'http://www.example.com'

      expect(user).to be_valid
    end

    it 'does not allow invalid url' do
      user.homepage = 'random'

      expect(user).not_to be_valid
    end

    it 'allows a url with an underscore' do
      user.homepage = 'http://foo_bar.com'

      expect(user).to be_valid
    end
  end

  context 'with ActiveRecord' do
    let!(:user) { UserWithAr.new }

    it 'does not allow invalid url' do
      user.homepage = 'random'

      expect(user).not_to be_valid
    end
  end

  context 'with ActiveRecord and legacy syntax' do
    let!(:user) { UserWithArLegacy.new }

    it 'does not allow invalid url' do
      user.homepage = 'random'

      expect(user).not_to be_valid
    end
  end

  context 'with regular validator and custom scheme' do
    let!(:user) { UserWithCustomScheme.new }

    it 'allows alternative URI schemes' do
      user.homepage = 'ftp://ftp.example.com'

      expect(user).to be_valid
    end
  end

  context 'with custom message' do
    let!(:user) { UserWithCustomMessage.new }

    it 'uses custom message' do
      user.homepage = 'invalid'
      user.valid?

      expect(user.errors[:homepage]).to eq(['wrong'])
    end

    it 'uses custom message for URIs that can not be parsed' do
      user.homepage = ':::'
      user.valid?

      expect(user.errors[:homepage]).to eq(['wrong'])
    end
  end
end
