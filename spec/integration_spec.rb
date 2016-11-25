require "spec_helper"

describe "integration test", type: :feature do
  let(:options) { ActiveAdminCsvWithBom.csv_options }

  before do
    5.times.each do |i|
      Post.create(title: "表題 #{i}", content: "本文 #{i}")
    end
    visit admin_posts_path
    click_link "CSV"
  end

  subject(:result) { page.body }

  it { result.encoding.to_s.should include options[:encoding] }

  it "should return expected csv" do
    parsed_csv = result.encode(options[:encoding_options]).split(options[:row_sep]).map do |row|
      row.remove(%(")).split(options[:col_sep])
    end
    fetched_values = Post.order(id: :desc).pluck(:id, :title, :content, :created_at, :updated_at).map { |row| row.map(&:to_s) }
    parsed_csv[1..-1].should match_array fetched_values
  end
end
