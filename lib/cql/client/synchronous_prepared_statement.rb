# encoding: utf-8

module Cql
  module Client
    # @private
    class SynchronousPreparedStatement < PreparedStatement
      include SynchronousBacktrace

      def initialize(async_statement)
        @async_statement = async_statement
        @metadata = async_statement.metadata
        @result_metadata = async_statement.result_metadata
      end

      def execute(*args)
        synchronous_backtrace { @async_statement.execute(*args).value }
      end

      def pipeline
        pl = Pipeline.new(@async_statement)
        yield pl
        synchronous_backtrace { pl.value }
      end

      def async
        @async_statement
      end
    end

    # @private
    class Pipeline
      def initialize(async_statement)
        @async_statement = async_statement
        @futures = []
      end

      def execute(*args)
        @futures << @async_statement.execute(*args)
      end

      def value
        Future.all(*@futures).value
      end
    end
  end
end