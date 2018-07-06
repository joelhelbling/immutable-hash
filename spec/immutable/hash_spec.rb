RSpec.describe Immutable::Hash do
  context "has a version number" do
    Then { expect(Immutable::Hash::VERSION).not_to be nil }
  end

  context 'ok' do
    Given(:initial_state) do
      { name: 'Gandalf', title: 'The Grey' }
    end
    Given(:hashlike) { described_class.new(initial_state) }

    context 'responds to' do
      Then do
        expect(hashlike).to respond_to(
          :[], :[]=,
          :merge, :delete,
          :keys, :values,
          :to_h, :to_hash,
        )
      end
    end

    context 'initial state' do
      context '#[]' do
        Then { hashlike[:name] == 'Gandalf' }
        Then { hashlike[:title] == 'The Grey' }
        Then { hashlike.to_h == initial_state }
      end
      context '#keys' do
        Then { hashlike.keys == %i[name title] }
      end
      context '#values' do
        Then { hashlike.values == ['Gandalf', 'The Grey'] }
      end
    end

    context 'after #merge' do
      When(:newhashlike) do
        hashlike.merge(weapon: 'Glamdring', title: 'The White')
      end

      context '#[]' do
        Then { newhashlike[:weapon] == 'Glamdring' }
        Then { newhashlike[:title] == 'The White' }
        Then { newhashlike[:name] == 'Gandalf' }
      end

      context '#to_hash' do
        Given(:expected_hash) do
          {
            name: 'Gandalf',
            title: 'The White',
            weapon: 'Glamdring'
          }
        end
        Then { newhashlike.to_hash == expected_hash }
      end

      context '#keys' do
        Then { newhashlike.keys == %i[name title weapon] }
      end

      context '#values' do
        Given(:expected_values) do
          [ 'Gandalf', 'The White', 'Glamdring' ]
        end

        Then { newhashlike.values == expected_values }
      end
    end

    context 'after #prune' do
      Given(:initial_state) do
        { name: 'Gandalf', title: 'The Grey', nickname: 'Wizard' }
      end

      When(:newhashlike) { hashlike.prune(:title) }

      context '#[]' do
        Then { newhashlike[:name] == 'Gandalf' }
        Then { newhashlike[:title].nil? }
        Then { newhashlike[:nickname] == 'Wizard' }
      end

      context '#keys' do
        Then { newhashlike.keys == %i[name nickname] }
      end

      context '#values' do
        Then { newhashlike.values == ['Gandalf', 'Wizard'] }
      end
    end

    describe '#undo' do
      Given(:initial_state) do
        { name: 'Gandalf', title: 'The Grey' }
      end

      When(:newhashlike) { hashlike.undo }

      context 'undo merge' do
        Given(:newhashlike) { hashlike.merge horse: 'Shadowfax' }

        When(:undohashlike) { newhashlike.undo }

        Then { undohashlike[:horse].nil? }
        Then { undohashlike.keys == %i[name title] }
      end

      context 'undo delete' do
        Given(:newhashlike) { hashlike.prune(:title) }
        When(:undohashlike) { newhashlike.undo }

        Then { undohashlike.keys == %i[name title] }
        Then { undohashlike[:title] == 'The Grey' }
      end
    end

    context '#[]= considered dangerous' do
      Then do
        expect { hashlike[:name] = 'Radagast' }.to \
          raise_error(Immutable::HashMutationException)
      end
    end
    context '#delete considered dangerous' do
      Then do
        expect { hashlike.delete(:title) }.to \
          raise_error(Immutable::HashMutationException)
      end
    end
  end

end
