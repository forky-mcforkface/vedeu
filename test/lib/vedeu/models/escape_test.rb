require 'test_helper'

module Vedeu

  describe Escape do

    let(:described)  { Vedeu::Escape }
    let(:instance)   { described.new(attributes) }
    let(:attributes) {
      {
        value:    _value,
        position: position,
      }
    }
    let(:_value)     { "\e[?25h" }
    let(:position)   { [2, 6] }

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@value').must_equal(_value) }
    end

    describe '#colour' do
      it { instance.colour.must_equal('') }
    end

    describe '#eql?' do
      let(:other) { instance }

      subject { instance.eql?(other) }

      it { subject.must_equal(true) }

      context 'when different to other' do
        let(:other) { described.new(value: 'b') }

        it { subject.must_equal(false) }
      end

      it { instance.must_respond_to(:==) }
    end

    describe '#inspect' do
      it { instance.inspect.must_equal(
        "<Vedeu::Escape '" \
        "\\e[2;6H\\e[?25h"       \
        "'>"
      ) }
    end

    describe '#position' do
      it { instance.position.must_be_instance_of(Vedeu::Position) }
    end

    describe '#style' do
      it { instance.style.must_equal('') }
    end

    describe '#value' do
      it { instance.value.must_be_instance_of(String) }
    end

    describe '#to_s' do
      subject { instance.to_s }

      it { instance.must_respond_to(:to_str) }
    end

  end # Escape

end # Vedeu
