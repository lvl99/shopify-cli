require 'test_helper'

module ShopifyCli
  module Commands
    class CreateTest < MiniTest::Test
      def test_help_loads_app_types
        io = capture_io do
          run_cmd('create --help')
        end
        output = io.join
        assert_match('node', output)
        assert_match('rails', output)
      end

      def test_type_is_validated_and_will_call_help_on_bad_type
        io = capture_io do
          run_cmd('create nope')
        end
        assert_match('invalid app type', io.join)
      end

      def test_type_will_be_asked_for_if_not_provided
        ProjectType.load_type(:rails)
        Rails::Commands::Create.expects(:call)
        Rails::Commands::Create.expects(:ctx=)
        CLI::UI::Prompt.expects(:ask).with('What type of project would you like to create?').returns(:rails)
        run_cmd('create')
      end

      def test_with_extension_calls_extension
        Create::Extension.any_instance.expects(:call)
          .with(['new-extension'], 'extension')
        run_cmd('create extension new-extension')
      end
    end
  end
end
