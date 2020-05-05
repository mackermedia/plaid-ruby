require 'spec_helper.rb'

RSpec.describe Plaid::Account do
  describe '#new' do
    # The reason this looks weird is because it is. This will be refactored for 2.0
    subject { Plaid::Account.new.new(results) }

    def self.with_results(_results, &examples)
      context "with results #{_results}" do
        let(:results) { _results }
        instance_eval(&examples)
      end
    end

    with_results('name' => 'Name') do it { expect(subject.name).to eql('Name') } end
    with_results('_id' =>  'ID')   do it { expect(subject.id).to   eql('ID') }   end
    with_results('type' => 'Type') do it { expect(subject.type).to eql('Type') } end
    with_results('meta' => nil)    do it { expect(subject.meta).to be_nil }      end
    with_results('meta' => {})     do it { expect(subject.meta).to eql({}) }     end

    with_results('balance' => { 'available' => 100.00 } ) do it { expect(subject.available_balance).to eql(100.00) } end
    with_results('balance' => { 'current'   => 200.00 } ) do it { expect(subject.current_balance).to   eql(200.00) } end

    with_results('institution_type' => 'Type') do it { expect(subject.institution_type).to eql('Type') } end

    with_results('numbers' => nil) do
      it { expect(subject.numbers).to eql('Upgrade user to access routing information for this account') }
    end

    with_results('numbers' => {}) do
      it { expect(subject.numbers).to eql({}) }
    end
  end
end
