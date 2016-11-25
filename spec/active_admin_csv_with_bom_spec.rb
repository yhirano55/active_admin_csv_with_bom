require "spec_helper"

describe ActiveAdminCsvWithBom do
  context "version" do
    subject { described_class::VERSION }
    it { should_not be_nil }
  end
end
