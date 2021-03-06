# encoding: ascii-8bit

require 'spec_helper'


module Cql
  module Protocol
    describe TopologyChangeEventResponse do
      describe '.decode!' do
        let :response do
          described_class.decode!(ByteBuffer.new("\x00\fREMOVED_NODE\x04\x00\x00\x00\x00\x00\x00#R"))
        end

        it 'decodes the change' do
          response.change.should == 'REMOVED_NODE'
        end

        it 'decodes the address' do
          response.address.should == IPAddr.new('0.0.0.0')
        end

        it 'decodes the port' do
          response.port.should == 9042
        end
      end

      describe '#to_s' do
        it 'returns a string that includes the change, address and port' do
          response = described_class.new('REMOVED_NODE', IPAddr.new('0.0.0.0'), 9042)
          response.to_s.should == 'EVENT TOPOLOGY_CHANGE REMOVED_NODE 0.0.0.0:9042'
        end
      end
    end
  end
end
