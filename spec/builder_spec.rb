require "spec_helper"

describe ActiveAdminCsvWithBom::Builder do
  let(:collection) do
    Array.new(10) do |i|
      Post.new(title: "title #{i}", content: "content #{i}")
    end
  end
  let(:instance) { described_class.new(collection) }

  describe "#build" do
    subject(:result) { instance.build }

    it { should be_a String }

    it "should return expected result" do
      parsed_result = CSV.parse(result.remove(instance.byte_order_mark), row_sep: instance.row_sep, col_sep: instance.col_sep, headers: true)
      parsed_result.headers.size.should eq Post.column_names.size
      parsed_result.size.should eq 10
    end
  end
end
