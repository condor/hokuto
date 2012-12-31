# -*- coding: UTF-8 -*-

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Hokuto::Application do
  describe :initialize do
    describe "when descriptor wasn't given" do
      subject {Hokuto::Application.new(environment: 'development', context_root: '/app', base_directory: '/apps', min_instances: '1', max_instances: '5')}
      specify 'the instance holds the values given' do
        subject.environment.should == 'development'
        subject.context_root.should == '/app'
        subject.base_directory.should == '/apps'
        subject.min_instances.should == 1
        subject.max_instances.should == 5
      end
    end
  end
end
