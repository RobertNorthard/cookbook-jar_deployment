require_relative '../spec_helper'

describe 'jar_deployment::default' do
  subject { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'includes java recipe' do
    expect(subject).to include_recipe('java::default')
  end
end
