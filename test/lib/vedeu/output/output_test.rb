require 'test_helper'

module Vedeu

  describe Output do

    let(:described) { Vedeu::Output }
    let(:instance)  { described.new(interface) }
    let(:interface) {
      Vedeu.interface 'flourine' do
        geometry do
          height 3
          width  32
        end
      end
    }
    let(:lines) {
      [
        Line.new({ streams: [Stream.new({ value: 'this is the first' })] }),
        Line.new({ streams: [Stream.new({ value: 'this is the second and it is long' })] }),
        Line.new({ streams: [Stream.new({ value: 'this is the third, it is even longer and still truncated' })] }),
        Line.new({ streams: [Stream.new({ value: 'this should not render' })] }),
      ]
    }

    before do
      interface.lines = lines
      IO.console.stubs(:print)
    end

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@interface').must_equal(interface) }
    end

    describe '.render' do
      before { Vedeu::FileRenderer.stubs(:render) }

      subject { described.render(interface) }

      it { subject.must_be_instance_of(Array) }

      context 'when a border is defined for the interface' do
      end

      context 'when a border is not defined for the interface' do
      end
    end

  end # Output

end # Vedeu
