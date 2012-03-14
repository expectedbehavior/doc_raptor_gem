require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ApiKeyTest < MiniTest::Unit::TestCase
  describe "test API keys" do
    before do
      DocRaptor.default_options.delete :api_key
      ENV.delete "DOCRAPTOR_API_KEY"
      @test_key = "Test Key!"
    end

    it "should throw an error if no api key is provided via a key, set in the environment, or already set on the DocRaptor class object" do
      assert_raises(DocRaptorError::NoApiKeyProvidedError) {DocRaptor.api_key}
    end

    it "should read the api key from the ENV" do
      ENV["DOCRAPTOR_API_KEY"] = @test_key
      assert_equal @test_key, DocRaptor.api_key
    end

    it "changes to the ENV variable shouldn't be implicitly picked up" do
      ENV["DOCRAPTOR_API_KEY"] = @test_key
      DocRaptor.api_key

      ENV["DOCRAPTOR_API_KEY"] = "some other key"
      assert_equal @test_key, DocRaptor.api_key
    end

    it "should use the passed in key" do
      assert_equal @test_key, DocRaptor.api_key(@test_key)
    end

    it "should persist the passed in key on subsequent calls" do
      DocRaptor.api_key(@test_key)
      assert_equal @test_key, DocRaptor.api_key
    end

    it "should override keys when passed in explicitly" do
      other_key = "some other key"
      DocRaptor.api_key(@test_key)
      assert_equal other_key, DocRaptor.api_key(other_key)
    end

    it "should persist overridden keys" do
      other_key = "some other key"
      DocRaptor.api_key(@test_key)
      DocRaptor.api_key(other_key)
      assert_equal other_key, DocRaptor.api_key
    end
  end
end
