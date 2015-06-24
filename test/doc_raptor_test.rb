require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DocRaptorTest < MiniTest::Test
  describe "the public interface" do
    methods = [:api_key,
               :create,
               :create!,
               :list_docs,
               :list_docs!,
               :status,
               :status!,
               :download,
               :download!].each do |method_name|
      it "should respond to #{method_name}" do
        assert DocRaptor.respond_to?(method_name)
      end
    end
  end

  # TODO basic tests of the various exception/error classes beyond
  # what is used in the gem functionality tests
end
