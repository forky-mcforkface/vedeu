require_relative '../../test_helper'

module Vedeu
  describe Renderer do
    let(:klass)    { Renderer }
    let(:instance) { klass.new(row) }
    let(:row)      {
      ["\e[31;49ma\e[0m", "\e[39;49mb\e[0m", "\e[32;49mc\e[0m"]
    }

    it { instance.must_be_instance_of(Vedeu::Renderer) }

    describe '#render' do
      subject { instance.render }

      it { subject.must_be_instance_of(String) }

      it 'renders the row of data' do
        subject
          .must_equal("\e[31;49ma\e[0m\e[39;49mb\e[0m\e[32;49mc\e[0m")
      end
    end
  end
end
