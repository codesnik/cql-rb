# encoding: ascii-8bit

require 'spec_helper'


module Cql
  module Protocol
    describe StartupRequest do
      describe '#compressable?' do
        it 'is not compressable' do
          described_class.new.should_not be_compressable
        end
      end

      describe '#write' do
        it 'encodes a STARTUP request frame' do
          bytes = StartupRequest.new('3.0.0', 'snappy').write('')
          bytes.should == "\x00\x02\x00\x0bCQL_VERSION\x00\x053.0.0\x00\x0bCOMPRESSION\x00\x06snappy"
        end

        it 'defaults to CQL 3.0.0 and no compression' do
          bytes = StartupRequest.new.write('')
          bytes.should == "\x00\x01\x00\x0bCQL_VERSION\x00\x053.0.0"
        end
      end

      describe '#to_s' do
        it 'returns a pretty string' do
          request = StartupRequest.new
          request.to_s.should == 'STARTUP {"CQL_VERSION"=>"3.0.0"}'
        end
      end
    end
  end
end