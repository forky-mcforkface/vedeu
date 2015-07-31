require 'test_helper'

module Vedeu

  describe Interface do

    let(:described)  { Vedeu::Interface }
    let(:instance)   { described.new(attributes) }
    let(:attributes) {
      {
        client:  client,
        colour:  colour,
        delay:   delay,
        group:   group,
        lines:   lines,
        name:    _name,
        parent:  parent,
        style:   style,
        visible: visible,
        zindex:  zindex,
      }
    }
    let(:client)     {}
    let(:colour)     {}
    let(:delay)      { 0.0 }
    let(:group)      { '' }
    let(:lines)      { [] }
    let(:_name)      { 'hydrogen' }
    let(:parent)     {}
    let(:repository) { Vedeu.interfaces }
    let(:style)      {}
    let(:visible)    { true }
    let(:zindex)     { 1 }

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@client').must_equal(client) }
      it { instance.instance_variable_get('@delay').must_equal(delay) }
      it { instance.instance_variable_get('@group').must_equal(group) }
      it { instance.instance_variable_get('@lines').must_equal(lines) }
      it { instance.instance_variable_get('@name').must_equal(_name) }
      it { instance.instance_variable_get('@parent').must_equal(parent) }
      it {
        instance.instance_variable_get('@repository').must_equal(repository)
      }
      it { instance.instance_variable_get('@visible').must_equal(visible) }
      it { instance.instance_variable_get('@zindex').must_equal(zindex) }
    end

    describe 'accessors' do
      it { instance.must_respond_to(:client) }
      it { instance.must_respond_to(:client=) }
      it { instance.must_respond_to(:delay) }
      it { instance.must_respond_to(:delay=) }
      it { instance.must_respond_to(:group) }
      it { instance.must_respond_to(:group=) }
      it { instance.must_respond_to(:name) }
      it { instance.must_respond_to(:name=) }
      it { instance.must_respond_to(:parent) }
      it { instance.must_respond_to(:parent=) }
      it { instance.must_respond_to(:zindex) }
      it { instance.must_respond_to(:zindex=) }
      it { instance.must_respond_to(:visible) }
      it { instance.must_respond_to(:visible=) }
      it { instance.must_respond_to(:visible?) }
      it { instance.must_respond_to(:attributes) }
      it { instance.must_respond_to(:lines=) }
    end

    describe '#add' do
      subject { instance.add(child) }

      it { instance.must_respond_to(:add) }

      it { instance.must_respond_to(:<<) }
    end

    describe '#hide' do
      let(:buffer) { Vedeu::Buffer.new }

      before { Vedeu.buffers.stubs(:by_name).returns(buffer) }

      subject { instance.hide }

      it {
        Vedeu.buffers.by_name('hydrogen').expects(:hide)
        subject
      }
    end

    describe '#inspect' do
      subject { instance.inspect }

      it { subject.must_be_instance_of(String) }

      it { subject.must_equal(
        "<Vedeu::Interface name: 'hydrogen', group: '', visible: 'true', " \
        "zindex: '1'>"
        )
      }
    end

    describe '#lines' do
      subject { instance.lines }

      it { instance.must_respond_to(:value) }
    end

    describe '#lines?' do
      subject { instance.lines? }

      context 'when the interface has content' do
        let(:lines) { [:line] }

        it { subject.must_equal(true) }
      end

      context 'when the interface does not have content' do
        it { subject.must_equal(false) }
      end
    end

    describe '#group?' do
      subject { instance.group? }

      context 'when the interface belongs to a group' do
        let(:group) { 'interfaces' }

        it { subject.must_equal(true) }
      end

      context 'when the interface does not belong to a group' do
        it { subject.must_equal(false) }
      end
    end

    describe '#render' do
      let(:clear)  { mock('Vedeu::Clear') }
      let(:border) { mock('Vedeu::Border') }
      let(:view)   { mock('Vedeu::Viewport') }

      before {
        Vedeu.stubs(:trigger).with(:_hide_cursor_, _name)

        Vedeu::Clear::NamedInterface.stubs(:render).returns(:clear)

        Vedeu::Viewport.stubs(:render).returns(:view)

        Vedeu.borders.stubs(:by_name).returns(border)
        border.stubs(:render).returns(:border)

        Vedeu.stubs(:trigger).with(:_show_cursor_, _name)
      }

      subject { instance.render }

      it { subject.must_be_instance_of(Array) }

      context 'when the interface is visible' do
        it {
          Vedeu::Clear::NamedInterface.expects(:render).with(_name)
          subject
        }

        it { subject.must_equal([nil, :clear, :view, :border, nil]) }
      end

      context 'when the interface is not visible' do
        let(:visible) { false }

        it { subject.must_equal([]) }
      end
    end

    describe '#show' do
      let(:buffer) { Vedeu::Buffer.new }

      before { Vedeu.buffers.stubs(:by_name).returns(buffer) }

      subject { instance.show }

      it {
        Vedeu.buffers.by_name('hydrogen').expects(:show)
        subject
      }
    end

    describe '#store' do
      subject { instance.store }

      context 'when the interface has no name' do
        let(:_name) {}

        it { proc { subject }.must_raise(MissingRequired) }
      end
    end

  end # Interface

end # Vedeu
