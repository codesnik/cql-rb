# encoding: ascii-8bit

require 'spec_helper'


module Cql
  module Protocol
    describe DetailedErrorResponse do
      describe '.decode!' do
        it 'decodes an unavailable error' do
          response = described_class.decode!(0x1000, '', ByteBuffer.new("\x00\x05\x00\x00\x00\x03\x00\x00\x00\x02"))
          response.details.should == {
            :cl => :all,
            :required => 3,
            :alive => 2
          }
        end

        it 'decodes a write_timeout error' do
          response = described_class.decode!(0x1100, '', ByteBuffer.new("\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\tBATCH_LOG"))
          response.details.should == {
            :cl => :one,
            :received => 0,
            :blockfor => 1,
            :write_type => 'BATCH_LOG'
          }
        end

        it 'decodes a read_timeout error' do
          response = described_class.decode!(0x1200, '', ByteBuffer.new("\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x01"))
          response.details.should == {
            :cl => :one,
            :received => 0,
            :blockfor => 1,
            :data_present => true
          }
          response = described_class.decode!(0x1200, '', ByteBuffer.new("\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00"))
          response.details.should == {
            :cl => :one,
            :received => 0,
            :blockfor => 1,
            :data_present => false
          }
        end

        it 'decodes an already_exists error with a keyspace' do
          response = described_class.decode!(0x2400, '', ByteBuffer.new("\x00\x05stuff\x00\x00"))
          response.details.should == {
            :ks => 'stuff',
            :table => '',
          }
        end

        it 'decodes an already_exists error with a keyspace and table' do
          response = described_class.decode!(0x2400, '', ByteBuffer.new("\x00\x05stuff\x00\x06things"))
          response.details.should == {
            :ks => 'stuff',
            :table => 'things',
          }
        end

        it 'decodes unprepared error' do
          response = described_class.decode!(0x2500, '', ByteBuffer.new("\x00\x10\xCAH\x7F\x1Ez\x82\xD2<N\x8A\xF35Qq\xA5/"))
          response.details.should == {
            :id => "\xCAH\x7F\x1Ez\x82\xD2<N\x8A\xF35Qq\xA5/"
          }
        end
      end

      describe '#to_s' do
        it 'returns a string with the error code, message and details' do
          response = described_class.new(0xffff, 'This is an error', {:foo => 'bar'})
          response.to_s.should == 'ERROR 0xFFFF "This is an error" {:foo=>"bar"}'
        end
      end
    end
  end
end
