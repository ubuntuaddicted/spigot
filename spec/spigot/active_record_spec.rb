require 'spec_helper'

describe Spigot::ActiveRecord do
  let(:subject){ActiveUser}
  let(:service){:github}
  let(:data){ Spigot::ApiData.user.merge(id: '987') }

  context 'with invalid mapping' do
    with_mapping(:basic_active_user, Spigot::Mapping::ActiveUser.basic)

    context '#find_by_api' do
      it 'requires the primary key to be accurate' do
        expect {
          subject.find_by_api(service, data).should_not be_nil
        }.to raise_error(Spigot::InvalidSchemaError)
      end
    end
  end

  context 'with valid mapping' do
    with_mapping(:active_user_with_options, Spigot::Mapping::ActiveUser.with_options)

    before do
      ActiveUser.create(name: 'Dean Martin', username: 'classyasfuck')
    end

    context '#find_by_api' do
      it 'queries by the specified primary_key' do
        subject.find_by_api(service, data).should_not be_nil
      end
    end
  end

end